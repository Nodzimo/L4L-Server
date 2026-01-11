#pragma semicolon 1
#pragma newdecls required

#include <l4l/utils>
#include <multicolors>
#include <sdktools>

#define PLUGIN_VERSION  "0.0.1"
#define EXPERT          "Expert"
#define IMPOSSIBLE_PLUS "Impossible+"
#define HARDCORE        "Hardcore"
#define SOUND_HARDCORE  "UI/Pickup_Secret01.wav"

ConVar    g_hCvarServerConfig, g_hCvarDifficultyEx, g_hCvarHostname;
bool      g_bHostnameGuard;
StringMap g_smSeenAuthIds;

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
}

public void OnMapStart()
{
    PrecacheSound(SOUND_HARDCORE);
}

static void ExecInstanceConfig()
{
    char config[64];
    g_hCvarServerConfig.GetString(config, sizeof(config));

    ServerCommand("exec \"sourcemod/l4l/%s.cfg\"", config);
}

static void ExecDifficultyConfig()
{
    char difficulty[32];
    g_hCvarDifficultyEx.GetString(difficulty, sizeof(difficulty));

    if (StrEqual(difficulty, IMPOSSIBLE_PLUS, false))
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

    if (cvar == g_hCvarDifficultyEx
        && StrEqual(newVal, IMPOSSIBLE_PLUS, false)
        && !StrEqual(oldVal, IMPOSSIBLE_PLUS, false))
    {
        MarkCurrentPlayersAsSeen();
        PlaySoundForCurrentPlayers();
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

    char difficultyEx[32];
    g_hCvarDifficultyEx.GetString(difficultyEx, sizeof(difficultyEx));

    if (!StrEqual(difficultyEx, IMPOSSIBLE_PLUS, false))
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
    for (int client = 1; client <= MaxClients; client++)
    {
        if (IsClientInGame(client) && !IsFakeClient(client))
        {
            PlaySound(client, SOUND_HARDCORE);
        }
    }
}

void PlaySound(int client, const char sound[32])
{
    EmitSoundToClient(client, sound, SOUND_FROM_PLAYER, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
}