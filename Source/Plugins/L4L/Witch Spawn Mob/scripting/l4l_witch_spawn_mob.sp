#pragma semicolon 1
#pragma newdecls required

#include <l4l/utils>
#include <l4l/lifecycle>

#define PLUGIN_VERSION "0.0.1"

ConVar g_hCvarEnable, g_hCvarDebug;
int    g_iCvarDebug;

public Plugin myinfo =
{
    name    = "L4L: Witch Spawn Mob",
    author  = "Sefo",
    version = PLUGIN_VERSION,
    url     = "Sefo.su"
};

public void OnPluginStart()
{
    CreateConVar("l4l_witch_spawn_mob_version", PLUGIN_VERSION, "L4L: Witch Spawn Mob version", CVAR_FLAGS | FCVAR_DONTRECORD);
    g_hCvarEnable = CreateConVar("l4l_witch_spawn_mob_enable", "0", "0 = Plugin off, 1 = Plugin on", CVAR_FLAGS, true, float(DISABLE), true, float(ENABLE));
    g_hCvarDebug  = CreateConVar("l4l_witch_spawn_mob_debug", "0", "0 = Debug off, 1 = Debug on, 2 = Debug events, 3 = Debug sounds", CVAR_FLAGS, true, float(DISABLE), true, float(DEBUG_SOUNDS));

    CreateDirectory("cfg/sourcemod/l4l_plugins", 511, true);
    AutoExecConfig(true, "l4l_witch_spawn_mob", "sourcemod/l4l_plugins");

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
    HookEvent(EVENT_WITCH_HARASSER, Event_WitchRage);
}

void L4L_Unhook()
{
    UnhookEvent(EVENT_WITCH_HARASSER, Event_WitchRage);
}

void Event_WitchRage(Event event, const char[] name, bool dontBroadcast)
{
    int client = GetEventClient(event);

    if (!client) return;

    if (g_iCvarDebug) PrintToChatAll("%s Event_WitchRage \x04%s \x05%s", DEBUG_TAG, GetName(client), name);

    SpawnMob(client, g_iCvarDebug);
}