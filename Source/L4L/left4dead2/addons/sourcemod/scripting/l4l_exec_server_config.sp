#pragma semicolon 1
#pragma newdecls required

#include <l4l/utils>
#include <multicolors>
#include <vscript>

#define PLUGIN_VERSION   "0.0.1"
#define EXPERT           "Expert"
#define IMPOSSIBLE_PLUS  "Impossible+"
#define HARDCORE         "Hardcore"
#define VSCRIPT_HARDCORE "hardcore"
#define VSCRIPT_VANILLA  "vanilla"
#define SOUND_HARDCORE   "UI/Pickup_Secret01.wav"
#define MUSIC_HARDCORE1  "music/infection/infection_09_01.wav"
#define MUSIC_HARDCORE2  "music/infection/infection_10_01.wav"
#define MUSIC_HARDCORE3  "music/infection/infection_11_01.wav"

ConVar            g_hCvarServerConfig, g_hCvarDifficultyEx, g_hCvarHostname;
bool              g_bHostnameGuard;
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

    g_smSeenAuthIds = new StringMap();

    HookEvent("player_disconnect", OnPlayerDisconnect, EventHookMode_PostNoCopy);
}

public void OnAllPluginsLoaded()
{
    g_hCvarDifficultyEx = FindConVar("z_difficulty_ex");

    if (g_hCvarDifficultyEx == null)
    {
        SetFailState("Required dependency z_difficulty_ex not found");
    }

    g_hCvarHostname = FindConVar("hostname");

    HookConVarChange(g_hCvarHostname, PatchHostname);
    HookConVarChange(g_hCvarDifficultyEx, PatchHostname);
}

public void OnConfigsExecuted()
{
    ExecInstanceConfig();
    ExecDifficultyConfig();
    RunVScriptFile(IsDifficultyHardcore() ? VSCRIPT_HARDCORE : VSCRIPT_VANILLA);
}

public void OnMapStart()
{
    PrecacheSound(SOUND_HARDCORE);
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

static void ExecDifficultyConfig()
{
    if (IsDifficultyHardcore())
    {
        ServerCommand("exec \"server_expert+.cfg\"");
    }
}

static void PatchHostname(ConVar cvar, const char[] oldVal, const char[] newVal)
{
    if (g_bHostnameGuard)
    {
        return;
    }

    if (cvar == g_hCvarDifficultyEx)
    {
        bool oldHardcore = StrEqual(oldVal, IMPOSSIBLE_PLUS, false);
        bool newHardcore = StrEqual(newVal, IMPOSSIBLE_PLUS, false);

        if (oldHardcore != newHardcore)
        {
            if (newHardcore)
            {
                MarkCurrentPlayersAsSeen();
                PlaySoundForCurrentPlayers();
            }

            RunVScriptFile(newHardcore ? VSCRIPT_HARDCORE : VSCRIPT_VANILLA);
        }
    }

    char difficultyEx[32];
    g_hCvarDifficultyEx.GetString(difficultyEx, sizeof(difficultyEx));

    char hostname[128];
    g_hCvarHostname.GetString(hostname, sizeof(hostname));

    if (StrEqual(difficultyEx, IMPOSSIBLE_PLUS, false))
    {
        if (ReplaceString(hostname, sizeof(hostname), EXPERT, HARDCORE, false) <= 0)
        {
            return;
        }
    }
    else
    {
        if (ReplaceString(hostname, sizeof(hostname), HARDCORE, EXPERT, false) <= 0)
        {
            return;
        }
    }

    g_bHostnameGuard = true;
    g_hCvarHostname.SetString(hostname, false, false);
    g_bHostnameGuard = false;
}

public void OnClientPostAdminCheck(int client)
{
    if (IsFakeClient(client))
    {
        return;
    }

    if (!IsDifficultyHardcore())
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
        CPrintToChat(client, "%t", "Hardcore warning");
        CPrintToChat(client, "%t", "Hardcore info");
        PlaySound(client, SOUND_HARDCORE);
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

static void PlaySoundForCurrentPlayers()
{
    int randomMusicId = GetRandomInt(0, sizeof(g_sHardcoreMusic) - 1);

    PrintToServer("[L4L] Hardcore music: %s", g_sHardcoreMusic[randomMusicId]);

    for (int client = 1; client <= MaxClients; client++)
    {
        if (IsClientInGame(client) && !IsFakeClient(client))
        {
            PlaySound(client, SOUND_HARDCORE);
            PlaySound(client, g_sHardcoreMusic[randomMusicId]);
        }
    }
}

void PlaySound(int client, const char[] sound)
{
    EmitSoundToClient(client, sound, SOUND_FROM_PLAYER, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
}

static bool IsDifficultyHardcore()
{
    char difficulty[32];
    g_hCvarDifficultyEx.GetString(difficulty, sizeof(difficulty));

    return StrEqual(difficulty, IMPOSSIBLE_PLUS, false);
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