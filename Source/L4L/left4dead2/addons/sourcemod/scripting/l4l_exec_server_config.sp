#pragma semicolon 1
#pragma newdecls required

#include <l4l/utils>
#include <multicolors>
#include <vscript>
#include <l4d2_custom_difficulty>

#define PLUGIN_VERSION            "0.0.1"
#define ALL_CLIENTS               0
#define CUSTOM_DIFFICULTY_MAX_LEN 80

#define INDEX_VANILLA_MIN         1
#define INDEX_VANILLA_MAX         4
#define INDEX_HARDCORE_ALL        5
#define INDEX_FOG                 6
#define INDEX_HARDCORE_LITE       7

#define VSCRIPT_HARDCORE          "hardcore"
#define VSCRIPT_VANILLA           "vanilla"

#define SOUND_HARDCORE            "UI/Pickup_Secret01.wav"
#define MUSIC_HARDCORE1           "music/infection/infection_09_01.wav"
#define MUSIC_HARDCORE2           "music/infection/infection_10_01.wav"
#define MUSIC_HARDCORE3           "music/infection/infection_11_01.wav"

#define SOUND_FOG                 "Ambient/Alarms/Perimeter_Alarm.wav"
#define SOUND_FOG_DURATION        2.0

ConVar            g_hCvarServerConfig, g_hCvarHostname;
bool              g_bHostnameGuard;
char              g_sLastSuffix[MAX_NAME_LENGTH];
StringMap         g_smSeenAuthIds;

static const char g_sHardcoreMusic[][] = {
    MUSIC_HARDCORE1,
    MUSIC_HARDCORE2,
    MUSIC_HARDCORE3
};

public Plugin myinfo =
{
    name        = "L4L: Exec Server Config",
    author      = "Sefo",
    description = "Server-side config orchestration and state synchronization",
    version     = PLUGIN_VERSION,
    url         = "Sefo.su"
};

public void OnPluginStart()
{
    LoadTranslations("l4l_exec_server_config.phrases");

    g_hCvarServerConfig = CreateConVar(
        "l4l_exec_server_config",
        "",
        "Server instance config name (without .cfg), executed from cfg/sourcemod/l4l/");

    g_smSeenAuthIds  = new StringMap();
    g_sLastSuffix[0] = '\0';

    HookEvent("player_disconnect", OnPlayerDisconnect, EventHookMode_PostNoCopy);
}

public void OnAllPluginsLoaded()
{
    if (!LibraryExists("l4d2_custom_difficulty"))
    {
        SetFailState("Required dependency l4d2_custom_difficulty not found");
    }

    g_hCvarHostname = FindConVar("hostname");

    HookConVarChange(g_hCvarHostname, PatchHostname);
}

public void OnConfigsExecuted()
{
    ExecInstanceConfig();
    ApplyCurrentDifficultyState(true);
}

public void OnMapStart()
{
    PrecacheSound(SOUND_HARDCORE);
    PrecacheSound(SOUND_FOG);
    PrecacheSound(MUSIC_HARDCORE1);
    PrecacheSound(MUSIC_HARDCORE2);
    PrecacheSound(MUSIC_HARDCORE3);
}

static void ExecInstanceConfig()
{
    char config[64];
    g_hCvarServerConfig.GetString(config, sizeof(config));

    ServerCommand("exec \"sourcemod/l4l/%s.cfg\"", config);
}

public void OnClientPostAdminCheck(int client)
{
    if (IsFakeClient(client))
    {
        return;
    }

    if (!IsCustomIndex(GetCurrentDifficultyIndex()))
    {
        return;
    }

    if (!MarkClientAsSeen(client))
    {
        return;
    }

    CreateTimer(
        5.0,
        Timer_ShowInfo,
        GetClientUserId(client),
        TIMER_FLAG_NO_MAPCHANGE);
}

static Action Timer_ShowInfo(Handle timer, int userId)
{
    int client = GetClientOfUserId(userId);

    if (IsValidClient(client))
    {
        int  index = GetCurrentDifficultyIndex();
        char customDifficulty[CUSTOM_DIFFICULTY_MAX_LEN];
        GetCustomSuffixByIndex(index, customDifficulty, sizeof(customDifficulty));

        CPrintToChat(client, "%t", "Difficulty warning", customDifficulty);
        CPrintToChat(client, "%t", "Difficulty info");
        PlayEntryEffectsForDifficultyIndex(index, client);
    }

    return Plugin_Stop;
}

static void OnPlayerDisconnect(Event event, const char[] name, bool dontBroadcast)
{
    int client = GetClientOfUserId(event.GetInt("userid"));

    if (client > 0)
    {
        char authId[MAX_AUTHID_LENGTH];

        if (GetClientAuthId(client, AuthId_Engine, authId, sizeof(authId)))
        {
            g_smSeenAuthIds.Remove(authId);
        }
    }
}

static bool MarkClientAsSeen(int client)
{
    if (!IsClientInGame(client) || IsFakeClient(client))
    {
        return false;
    }

    char authId[MAX_AUTHID_LENGTH];
    if (!GetClientAuthId(client, AuthId_Engine, authId, sizeof(authId)))
    {
        return false;
    }

    return g_smSeenAuthIds.SetValue(authId, true, false);
}

static void MarkCurrentPlayersAsSeen()
{
    for (int client = 1; client <= MaxClients; client++)
    {
        MarkClientAsSeen(client);
    }
}

static void PlaySoundTarget(int target, const char[] sound, bool stopLoop = false, float duration = SOUND_FOG_DURATION)
{
    if (target == ALL_CLIENTS)
    {
        for (int client = 1; client <= MaxClients; client++)
        {
            if (!IsClientInGame(client) || IsFakeClient(client))
                continue;

            PlaySound(client, sound);
            StopSoundTimer(client, stopLoop, duration);
        }

        return;
    }

    if (target <= 0 || target > MaxClients || !IsClientInGame(target) || IsFakeClient(target))
        return;

    PlaySound(target, sound);
    StopSoundTimer(target, stopLoop, duration);
}

void PlaySound(int client, const char[] sound)
{
    EmitSoundToClient(client, sound, SOUND_FROM_PLAYER, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
}

static bool RunVScriptFile(const char[] scriptBaseName)
{
    if (!VScript_IsScriptVMInitialized())
    {
        PrintToServer("[L4L] VScript VM not initialized");

        return false;
    }

    char path[PLATFORM_MAX_PATH];
    BuildPath(Path_SM, path, sizeof(path), "vscripts/l4l/%s.nut", scriptBaseName);

    File file = OpenFile(path, "r");

    if (file == null)
    {
        PrintToServer("[L4L] Cannot open VScript file: %s", path);

        return false;
    }

    char code[16384];
    code[0] = '\0';
    char line[512];
    bool truncated = false;

    while (!file.EndOfFile())
    {
        file.ReadLine(line, sizeof(line));

        if (strlen(code) + strlen(line) >= sizeof(code) - 1)
        {
            truncated = true;

            break;
        }

        StrCat(code, sizeof(code), line);
    }

    if (truncated)
    {
        PrintToServer("[L4L] WARNING: VScript file too large, truncated: %s", path);
    }

    delete file;

    if (code[0] == '\0')
    {
        PrintToServer("[L4L] Empty VScript file: %s", path);

        return false;
    }

    HSCRIPT script = VScript_CompileScript(code);

    if (!script)
    {
        PrintToServer("[L4L] VScript compile failed: %s", path);

        return false;
    }

    VScriptExecute exec = new VScriptExecute(script);
    exec.Execute();

    PrintToServer("[L4L] VScript %s => return %d", scriptBaseName, exec.ReturnValue);

    delete exec;
    script.ReleaseScript();

    return true;
}

static bool IsVanillaIndex(int index)
{
    return (index >= INDEX_VANILLA_MIN && index <= INDEX_VANILLA_MAX);
}

static bool IsCustomIndex(int index)
{
    return (index > INDEX_VANILLA_MAX);
}

static int GetCurrentDifficultyIndex()
{
    // Native returns 0 if no current custom difficulty
    return GetCurCustomDifficultyIndex();
}

// // For custom difficulties only: return suffix to append
static void GetCustomSuffixByIndex(int index, char[] buffer, int maxlen)
{
    buffer[0] = '\0';
    char customDifficulty[MAX_NAME_LENGTH];

    if (GetCustomDifficultyNameByIndex(index, customDifficulty, sizeof(customDifficulty)))
        strcopy(buffer, maxlen, customDifficulty);
}

static void ApplyCurrentDifficultyState(bool isInitial)
{
    int index = GetCurrentDifficultyIndex();

    if (!isInitial && IsCustomIndex(index))
    {
        MarkCurrentPlayersAsSeen();
        PlayEntryEffectsForDifficultyIndex(index);
    }

    ApplyVScriptByDifficultyIndex(index);
    UpdateHostnameSuffix(index);
}

static void UpdateHostnameSuffix(int index)
{
    char hostname[MAX_NAME_LENGTH];
    g_hCvarHostname.GetString(hostname, sizeof(hostname));

    // Strip previous suffix if it's still present
    if (g_sLastSuffix[0] != '\0')
    {
        int hostnameLen = strlen(hostname);
        int suffixLen   = strlen(g_sLastSuffix);

        if (hostnameLen >= suffixLen && StrEqual(hostname[hostnameLen - suffixLen], g_sLastSuffix, false))
        {
            hostname[hostnameLen - suffixLen] = '\0';
        }
    }

    // Build new suffix (only for custom index >= 5)
    char suffixText[96];
    suffixText[0] = '\0';

    if (IsCustomIndex(index))
    {
        char customDifficulty[CUSTOM_DIFFICULTY_MAX_LEN];
        GetCustomSuffixByIndex(index, customDifficulty, sizeof(customDifficulty));

        if (customDifficulty[0] != '\0')
        {
            FormatEx(suffixText, sizeof(suffixText), " %s", customDifficulty);
        }
    }

    // Apply if changed
    if (!StrEqual(g_sLastSuffix, suffixText, false))
    {
        strcopy(g_sLastSuffix, sizeof(g_sLastSuffix), suffixText);

        if (suffixText[0] != '\0')
        {
            StrCat(hostname, sizeof(hostname), suffixText);
        }

        g_bHostnameGuard = true;
        g_hCvarHostname.SetString(hostname, false, false);
        g_bHostnameGuard = false;
    }
}

// Re-apply suffix if someone changes hostname manually
static void PatchHostname(ConVar cvar, const char[] oldVal, const char[] newVal)
{
    if (g_bHostnameGuard)
    {
        return;
    }

    ApplyCurrentDifficultyState(true);
}

// Forward from l4d2_custom_difficulty.inc
public void OnCustomDifficultyLoaded(const char[] sBaseDifficulty, const char[] sCustomDifficultyName)
{
    // Runtime change sync (with transition effects)
    ApplyCurrentDifficultyState(false);
}

static void ApplyVScriptByDifficultyIndex(int index)
{
    if (IsVanillaIndex(index) || index == 0)
    {
        RunVScriptFile(VSCRIPT_VANILLA);

        return;
    }

    switch (index)
    {
        case INDEX_HARDCORE_ALL:
        {
            RunVScriptFile(VSCRIPT_HARDCORE);
        }
        case INDEX_FOG:
        {
            RunVScriptFile(VSCRIPT_VANILLA);
        }
        case INDEX_HARDCORE_LITE:
        {
            RunVScriptFile(VSCRIPT_HARDCORE);
        }
    }
}

static void PlayEntryEffectsForDifficultyIndex(int index, int target = ALL_CLIENTS)
{
    if (!IsCustomIndex(index))
        return;

    switch (index)
    {
        case INDEX_HARDCORE_ALL:
        {
            int randomMusicId = GetRandomInt(0, sizeof(g_sHardcoreMusic) - 1);

            PlaySoundTarget(target, SOUND_HARDCORE);
            PlaySoundTarget(target, g_sHardcoreMusic[randomMusicId]);
        }
        case INDEX_FOG:
        {
            PlaySoundTarget(target, SOUND_FOG, true, SOUND_FOG_DURATION);
        }
        case INDEX_HARDCORE_LITE:
        {
            PlaySoundTarget(target, SOUND_HARDCORE);
        }
    }
}

static void StopSoundTimer(int client, bool stopLoop, float duration)
{
    if (stopLoop)
        CreateTimer(duration, Timer_StopSound, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
}

static Action Timer_StopSound(Handle timer, int userId)
{
    int client = GetClientOfUserId(userId);

    if (client <= 0 || !IsClientInGame(client))
        return Plugin_Stop;

    StopSound(client, SNDCHAN_AUTO, SOUND_FOG);

    return Plugin_Stop;
}