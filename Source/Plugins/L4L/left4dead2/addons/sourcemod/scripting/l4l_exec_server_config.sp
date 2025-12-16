#pragma semicolon 1
#pragma newdecls required

#define PLUGIN_VERSION  "0.0.1"
#define EXPERT          "Expert"
#define IMPOSSIBLE_PLUS "Impossible+"
#define HARDCORE        "Hardcore"

ConVar g_hCvarServerConfig, g_hCvarDifficultyEx, g_hCvarHostname;
bool   g_bHostnameGuard;

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
    g_hCvarServerConfig = CreateConVar(
        "l4l_exec_server_config",
        "",
        "Server instance config name (without .cfg), executed from cfg/sourcemod/l4l/");

    g_hCvarDifficultyEx = FindConVar("z_difficulty_ex");
    g_hCvarHostname     = FindConVar("hostname");
    HookConVarChange(g_hCvarHostname, PatchHostname);
    HookConVarChange(g_hCvarDifficultyEx, PatchHostname);

    if (g_hCvarDifficultyEx == null)
    {
        LogError("ConVar 'z_difficulty_ex' not found");
    }
}

public void OnConfigsExecuted()
{
    ExecInstanceConfig();

    if (g_hCvarDifficultyEx == null)
    {
        return;
    }

    ExecDifficultyConfig();
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
    if (g_bHostnameGuard || g_hCvarHostname == null || g_hCvarDifficultyEx == null)
    {
        return;
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