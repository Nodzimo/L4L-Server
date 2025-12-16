#pragma semicolon 1
#pragma newdecls required

#include <l4l/utils>
#include <l4l/lifecycle>

#define PLUGIN_VERSION "0.0.1"

ConVar g_hCvarEnable, g_hCvarDebug, g_hCvarInfectedLimit;
int    g_iCvarDebug, g_iCvarInfectedLimit;
bool   g_bCvarEnable;

public Plugin myinfo =
{
    name    = "L4L: Director Spawn SI Limit",
    author  = "Sefo",
    version = PLUGIN_VERSION,
    url     = "Sefo.su"
};

public void OnPluginStart()
{
    CreateConVar("l4l_director_spawn_si_limit_version", PLUGIN_VERSION, "L4L: Director Spawn SI Limit version", CVAR_FLAGS | FCVAR_DONTRECORD);
    g_hCvarEnable        = CreateConVar("l4l_director_spawn_si_limit_enable", "0", "0 = Plugin off, 1 = Plugin on", CVAR_FLAGS, true, float(DISABLE), true, float(ENABLE));
    g_hCvarDebug         = CreateConVar("l4l_director_spawn_si_limit_debug", "0", "0 = Debug off, 1 = Debug on, 2 = Debug events, 3 = Debug sounds", CVAR_FLAGS, true, float(DISABLE), true, float(DEBUG_SOUNDS));
    g_hCvarInfectedLimit = CreateConVar("l4l_director_spawn_si_limit_count", "6", "0 = Off, Limit of special infected alive (tanks & witches not included)", CVAR_FLAGS, true, float(DISABLE), true, float(MAX_SI));

    CreateDirectory("cfg/sourcemod/l4l_plugins", 511, true);
    AutoExecConfig(true, "l4l_director_spawn_si_limit", "sourcemod/l4l_plugins");

    g_hCvarEnable.AddChangeHook(CvarChanged_Enable);
    g_hCvarDebug.AddChangeHook(CvarChanged_Cvars);
    g_hCvarInfectedLimit.AddChangeHook(CvarChanged_Cvars);

    RegAdminCmd("l4l_si_limit", CommandLimitSI, ADMFLAG_ROOT, "Limit of special infected alive (tanks & witches not included)");
}

public void OnConfigsExecuted()
{
    L4L_LC_OnConfigsExecuted(g_hCvarEnable.BoolValue);
}

void CvarChanged_Enable(ConVar cvar, const char[] oldValue, const char[] newValue)
{
    L4L_LC_OnEnableChanged(g_hCvarEnable.BoolValue);
}

void CvarChanged_Cvars(ConVar cvar, const char[] oldValue, const char[] newValue)
{
    L4L_LC_OnCvarsChanged();
}

void L4L_ReadCvars()
{
    g_iCvarDebug         = g_hCvarDebug.IntValue;
    g_iCvarInfectedLimit = g_hCvarInfectedLimit.IntValue;
}

void L4L_Hook()
{
    g_bCvarEnable = true;
}

void L4L_Unhook()
{
    g_bCvarEnable = false;
}

Action CommandLimitSI(int client, int arguments)
{
    g_iCvarInfectedLimit = GetInfectedLimit(arguments, g_iCvarInfectedLimit);

    if (g_iCvarDebug) PrintToChatAll("%s CommandLimitSI \x04%d", DEBUG_TAG, g_iCvarInfectedLimit);

    return Plugin_Handled;
}

public Action L4D_OnGetScriptValueInt(const char[] key, int &retVal)
{
    if (!g_bCvarEnable)
    {
        return Plugin_Continue;
    }

    if (StrEqual(key, "MaxSpecials"))
    {
        retVal = g_iCvarInfectedLimit;

        return Plugin_Handled;
    }

    return Plugin_Continue;
}