#pragma semicolon 1
#pragma newdecls required

#include <l4l/utils>
#include <l4l/lifecycle>

#define PLUGIN_VERSION "0.0.1"

ConVar g_hCvarEnable, g_hCvarDebug;
int    g_iCvarDebug;

public Plugin myinfo =
{
    name    = "L4L: Survivor Death Spawn Mob",
    author  = "Sefo",
    version = PLUGIN_VERSION,
    url     = "Sefo.su"
};

public void OnPluginStart()
{
    CreateConVar("l4l_survivor_death_spawn_mob_version", PLUGIN_VERSION, "L4L: Survivor Death Spawn Mob version", CVAR_FLAGS | FCVAR_DONTRECORD);
    g_hCvarEnable = CreateConVar("l4l_survivor_death_spawn_mob_enable", "0", "0 = Plugin off, 1 = Plugin on", CVAR_FLAGS, true, float(DISABLE), true, float(ENABLE));
    g_hCvarDebug  = CreateConVar("l4l_survivor_death_spawn_mob_debug", "0", "0 = Debug off, 1 = Debug on, 2 = Debug events, 3 = Debug sounds", CVAR_FLAGS, true, float(DISABLE), true, float(DEBUG_SOUNDS));

    CreateDirectory("cfg/sourcemod/l4l_plugins", 511, true);
    AutoExecConfig(true, "l4l_survivor_death_spawn_mob", "sourcemod/l4l_plugins");

    g_hCvarEnable.AddChangeHook(CvarChanged_Enable);
    g_hCvarDebug.AddChangeHook(CvarChanged_Cvars);
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
    g_iCvarDebug = g_hCvarDebug.IntValue;
}

void L4L_Hook()
{
    HookEvent(EVENT_PLAYER_DEATH, Event_PlayerDeath);
}

void L4L_Unhook()
{
    UnhookEvent(EVENT_PLAYER_DEATH, Event_PlayerDeath);
}

void Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
    int client = GetEventClient(event);

    if (IsValidSurvivor(client))
    {
        if (g_iCvarDebug) PrintToChatAll("%s Event_SurvivorDeath \x04%s \x05%s", DEBUG_TAG, GetName(client), name);

        SpawnMob(client, g_iCvarDebug);
        SpawnWitch(client);

        return;
    }

    if (IsTankClient(client))
    {
        int exec = GetAnySurvivorExecutor();

        if (exec == 0) return;

        if (g_iCvarDebug) PrintToChatAll("%s Event_TankDeath \x04%s \x05%s", DEBUG_TAG, GetName(client), name);

        SpawnWitch(exec);

        return;
    }
}

void SpawnWitch(int client, int count = DEFAULT_SPAWN_COUNT)
{
    for (int i = 0; i < count; i++)
    {
        if (g_iCvarDebug) PrintToChatAll("%s SpawnWitch \x04%s", DEBUG_TAG, GetName(client));

        char argument[MAX_ARGUMENT_LENGTH];
        Format(argument, sizeof argument, "witch %s", SPAWN_ARGUMENT_AUTO);
        ExecuteCheat(client, SPAWN_COMMAND_OLD, argument, g_iCvarDebug);
    }
}

int GetAnySurvivorExecutor()
{
    for (int i = 1; i <= MaxClients; i++)
    {
        if (!IsClientInGame(i)) continue;

        if (!IsValidSurvivor(i)) continue;

        return i;
    }

    return 0;
}

bool IsTankClient(int client)
{
    if (client <= 0) return false;

    if (!IsClientInGame(client)) return false;

    if (!IsInfected(client)) return false;

    return IsTank(client);
}