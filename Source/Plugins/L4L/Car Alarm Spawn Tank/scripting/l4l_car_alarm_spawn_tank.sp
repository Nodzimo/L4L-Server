#pragma semicolon 1
#pragma newdecls required

#include <l4l/utils>
#include <l4l/lifecycle>
#include <left4dhooks>

#define PLUGIN_VERSION "0.0.1"

ConVar g_hCvarEnable, g_hCvarDebug, g_hCvarCarAlarmChance;
int    g_iCvarDebug, g_iCvarCarAlarmChance;

public Plugin myinfo =
{
    name    = "L4L: Car Alarm Spawn Tank",
    author  = "Sefo",
    version = PLUGIN_VERSION,
    url     = "Sefo.su"
};

public void OnPluginStart()
{
    CreateConVar("l4l_car_alarm_spawn_tank_version", PLUGIN_VERSION, "L4L: Car Alarm Spawn Tank", CVAR_FLAGS | FCVAR_DONTRECORD);
    g_hCvarEnable         = CreateConVar("l4l_car_alarm_spawn_tank_enable", "0", "0 = Plugin off, 1 = Plugin on", CVAR_FLAGS, true, float(DISABLE), true, float(ENABLE));
    g_hCvarDebug          = CreateConVar("l4l_car_alarm_spawn_tank_debug", "0", "0 = Debug off, 1 = Debug on, 2 = Debug events, 3 = Debug sounds", CVAR_FLAGS, true, float(DISABLE), true, float(DEBUG_SOUNDS));
    g_hCvarCarAlarmChance = CreateConVar("l4l_car_alarm_spawn_tank_chance", "50", "0 = Off, Car alarm: spawn tank chance", CVAR_FLAGS, true, float(DISABLE), true, float(MAX_CHANCE));

    CreateDirectory("cfg/sourcemod/l4l_plugins", 511, true);
    AutoExecConfig(true, "l4l_car_alarm_spawn_tank", "sourcemod/l4l_plugins");

    g_hCvarEnable.AddChangeHook(CvarChanged_Enable);
    g_hCvarDebug.AddChangeHook(CvarChanged_Cvars);
    g_hCvarCarAlarmChance.AddChangeHook(CvarChanged_Cvars);

    RegAdminCmd("l4l_spawn_tank", CommandSpawnTank, ADMFLAG_ROOT, "Spawns specified number of tanks (1 by default)");
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
    g_iCvarDebug          = g_hCvarDebug.IntValue;
    g_iCvarCarAlarmChance = g_hCvarCarAlarmChance.IntValue;
}

void L4L_Hook()
{
    HookEntityOutput(PROP_CAR_ALARM, EVENT_CAR_ALARM, Event_CarAlarm);
}

void L4L_Unhook()
{
    UnhookEntityOutput(PROP_CAR_ALARM, EVENT_CAR_ALARM, Event_CarAlarm);
}

void Event_CarAlarm(const char[] output, int caller, int activator, float delay)
{
    if (!IsValidEntity(caller) || HasTank()) return;

    int client = GetAnyClient();

    if (!client) return;

    if (g_iCvarDebug) PrintToChatAll("%s Event_CarAlarm \x04%s \x05%s", DEBUG_TAG, GetName(client), output);

    if (IsLucky(g_iCvarCarAlarmChance)) SpawnTank(client);
}

void SpawnTank(int client, int count = DEFAULT_SPAWN_COUNT)
{
    for (int i = 0; i < count; i++)
    {
        if (g_iCvarDebug) PrintToChatAll("%s SpawnTank \x04%s", DEBUG_TAG, GetName(client));

        char argument[MAX_ARGUMENT_LENGTH];
        Format(argument, sizeof argument, "tank %s", SPAWN_ARGUMENT_AUTO);
        ExecuteCheat(client, SPAWN_COMMAND_OLD, argument, g_iCvarDebug);
    }
}

Action CommandSpawnTank(int client, int arguments)
{
    SpawnTank(client, GetSpawnCount(arguments));

    return Plugin_Handled;
}