#pragma semicolon 1
#pragma newdecls required

#include <l4l/utils>
#include <l4l/lifecycle>

#define PLUGIN_VERSION "0.0.1"

ConVar g_hCvarEnable, g_hCvarDebug;
int    g_iCvarDebug;

public Plugin myinfo =
{
    name    = "L4L: Hide Kill Feed",
    author  = "Sefo",
    version = PLUGIN_VERSION,
    url     = "Sefo.su"
};

public void OnPluginStart()
{
    CreateConVar("l4l_hide_kill_feed_version", PLUGIN_VERSION, "L4L: Hide Kill Feed version", CVAR_FLAGS | FCVAR_DONTRECORD);
    g_hCvarEnable = CreateConVar("l4l_hide_kill_feed_enable", "0", "0 = Plugin off, 1 = Plugin on", CVAR_FLAGS, true, float(DISABLE), true, float(ENABLE));
    g_hCvarDebug  = CreateConVar("l4l_hide_kill_feed_debug", "0", "0 = Debug off, 1 = Debug on, 2 = Debug events, 3 = Debug sounds", CVAR_FLAGS, true, float(DISABLE), true, float(DEBUG_SOUNDS));

    CreateDirectory("cfg/sourcemod/l4l_plugins", 511, true);
    AutoExecConfig(true, "l4l_hide_kill_feed", "sourcemod/l4l_plugins");

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
    HookEvent(EVENT_PLAYER_DEATH, Event_Hide, EventHookMode_Pre);
    HookEvent(EVENT_PLAYER_INCAP, Event_Hide, EventHookMode_Pre);
    HookEvent(EVENT_DEFIB_USED, Event_Hide, EventHookMode_Pre);
    HookEvent(EVENT_HEAL_SUCCESS, Event_Hide, EventHookMode_Pre);
    HookEvent(EVENT_REVIVE_SUCCESS, Event_Hide, EventHookMode_Pre);
    HookEvent(EVENT_SURVIVOR_RESCUED, Event_Hide, EventHookMode_Pre);
    HookEvent(EVENT_AWARD_EARNED, Event_Hide, EventHookMode_Pre);

    HookUserMessage(GetUserMessageId(EVENT_USER_MESSAGE), PZDmgMsg, true);
}

void L4L_Unhook()
{
    UnhookEvent(EVENT_PLAYER_DEATH, Event_Hide, EventHookMode_Pre);
    UnhookEvent(EVENT_PLAYER_INCAP, Event_Hide, EventHookMode_Pre);
    UnhookEvent(EVENT_DEFIB_USED, Event_Hide, EventHookMode_Pre);
    UnhookEvent(EVENT_HEAL_SUCCESS, Event_Hide, EventHookMode_Pre);
    UnhookEvent(EVENT_REVIVE_SUCCESS, Event_Hide, EventHookMode_Pre);
    UnhookEvent(EVENT_SURVIVOR_RESCUED, Event_Hide, EventHookMode_Pre);
    UnhookEvent(EVENT_AWARD_EARNED, Event_Hide, EventHookMode_Pre);

    UnhookUserMessage(GetUserMessageId(EVENT_USER_MESSAGE), PZDmgMsg, true);
}

Action Event_Hide(Event event, const char[] name, bool dontBroadcast)
{
    if (g_iCvarDebug == DEBUG_EVENTS) PrintToChatAll("%s Event_Hide \x04%s \x05%s", DEBUG_TAG, GetName(GetEventClient(event)), name);

    event.BroadcastDisabled = true;

    return Plugin_Changed;
}

Action PZDmgMsg(UserMsg messageId, BfRead message, const int[] players, int playersNum, bool reliable, bool init)
{
    return Plugin_Handled;
}