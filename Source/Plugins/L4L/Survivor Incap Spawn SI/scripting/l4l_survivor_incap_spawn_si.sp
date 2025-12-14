#pragma semicolon 1
#pragma newdecls required

#include <l4l/utils>
#include <l4l/lifecycle>

#define PLUGIN_VERSION "0.0.1"

static const char g_sInfectedClasses[6][] = {
    "smoker",
    "boomer",
    "hunter",
    "spitter",
    "jockey",
    "charger",
};

static const int g_sInfectedClassesCount = sizeof g_sInfectedClasses - 1;

ConVar           g_hCvarEnable, g_hCvarDebug, g_hCvarSurvivorIncap;
int              g_iCvarDebug, g_iCvarSurvivorIncap;

public Plugin myinfo =
{
    name    = "L4L: Survivor Incap Spawn SI",
    author  = "Sefo",
    version = PLUGIN_VERSION,
    url     = "Sefo.su"
};

public void OnPluginStart()
{
    CreateConVar("l4l_survivor_incap_spawn_si_version", PLUGIN_VERSION, "L4L: Survivor Incap Spawn SI version", CVAR_FLAGS | FCVAR_DONTRECORD);
    g_hCvarEnable        = CreateConVar("l4l_survivor_incap_spawn_si_enable", "0", "0 = Plugin off, 1 = Plugin on", CVAR_FLAGS, true, float(DISABLE), true, float(ENABLE));
    g_hCvarDebug         = CreateConVar("l4l_survivor_incap_spawn_si_debug", "0", "0 = Debug off, 1 = Debug on, 2 = Debug events, 3 = Debug sounds", CVAR_FLAGS, true, float(DISABLE), true, float(DEBUG_SOUNDS));
    g_hCvarSurvivorIncap = CreateConVar("l4l_survivor_incap_spawn_si_count", "1", "0 = Off, Number of special infected spawned when a survivor is incapacitated", CVAR_FLAGS, true, float(DISABLE), true, float(MAX_SI));

    CreateDirectory("cfg/sourcemod/l4l_plugins", 511, true);
    AutoExecConfig(true, "l4l_survivor_incap_spawn_si", "sourcemod/l4l_plugins");

    g_hCvarEnable.AddChangeHook(CvarChanged_Enable);
    g_hCvarDebug.AddChangeHook(CvarChanged_Cvars);
    g_hCvarSurvivorIncap.AddChangeHook(CvarChanged_Cvars);

    RegAdminCmd("l4l_spawn_si", CommandSpawnRandomSI, ADMFLAG_ROOT, "Spawns specified number of random special infected (1 by default)");
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
    g_iCvarSurvivorIncap = g_hCvarSurvivorIncap.IntValue;
}

void L4L_Hook()
{
    HookEvent(EVENT_PLAYER_INCAP, Event_SurvivorIncap);
    HookEvent(EVENT_LEDGE_GRAB, Event_SurvivorIncap);
}

void L4L_Unhook()
{
    UnhookEvent(EVENT_PLAYER_INCAP, Event_SurvivorIncap);
    UnhookEvent(EVENT_LEDGE_GRAB, Event_SurvivorIncap);
}

Action CommandSpawnRandomSI(int client, int arguments)
{
    SpawnRandomSI(client, GetSpawnCount(arguments));

    return Plugin_Handled;
}

void Event_SurvivorIncap(Event event, const char[] name, bool dontBroadcast)
{
    if (!g_iCvarSurvivorIncap) return;

    int client = GetEventClient(event);

    if (!IsValidSurvivor(client)) return;

    if (g_iCvarDebug) PrintToChatAll("%s Event_SurvivorIncap \x04%s \x05%s", DEBUG_TAG, GetName(client), name);

    SpawnRandomSI(client, g_iCvarSurvivorIncap);
}

void SpawnRandomSI(int client, int count = DEFAULT_SPAWN_COUNT)
{
    for (int i = 0; i < count; i++)
    {
        if (g_iCvarDebug) PrintToChatAll("%s SpawnRandomSI \x04%s", DEBUG_TAG, GetName(client));

        int  randomIndex = GetRandomInt(0, g_sInfectedClassesCount);
        char argument[MAX_ARGUMENT_LENGTH];
        Format(argument, sizeof argument, "%s %s", g_sInfectedClasses[randomIndex], SPAWN_ARGUMENT_AUTO);
        ExecuteCheat(client, SPAWN_COMMAND_OLD, argument, g_iCvarDebug);
    }
}