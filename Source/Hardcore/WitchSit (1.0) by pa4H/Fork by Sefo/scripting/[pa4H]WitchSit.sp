#include <l4l/utils>
#include <l4l/lifecycle>
#include <left4dhooks>

ConVar g_hCvarEnable;

public Plugin myinfo =
{
    name        = "WitchSit",
    author      = "pa4H",
    description = "Witch sits down after kill",
    version     = "1.0",
    url         = "https://t.me/pa4H232"
};

public OnPluginStart()
{
    g_hCvarEnable = CreateConVar(
        "l4l_witch_stops_after_kill_enable",
        "0",
        "0 = Plugin off, 1 = Plugin on",
        CVAR_FLAGS,
        true, float(DISABLE),
        true, float(ENABLE));

    CreateDirectory("cfg/sourcemod/l4l_plugins", 511, true);
    AutoExecConfig(true, "l4l_witch_stops_after_kill", "sourcemod/l4l_plugins");

    g_hCvarEnable.AddChangeHook(CvarChanged_Enable);
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

void L4L_ReadCvars() {}

void L4L_Hook()
{
    HookEvent(EVENT_PLAYER_DEATH, player_death);
}

void L4L_Unhook()
{
    UnhookEvent(EVENT_PLAYER_DEATH, player_death);
}

public Action player_death(Handle hEvent, char[] strName, bool DontBroadcast)
{
    int witch  = GetEventInt(hEvent, "attackerentid");
    int victim = GetClientOfUserId(GetEventInt(hEvent, "userid"));

    if (victim <= 0 || !IsWitch(witch))
    {
        return Plugin_Continue;
    }

    int iWitchRef = EntIndexToEntRef(witch);
    CreateTimer(15.0, RestoreWitch, iWitchRef, TIMER_FLAG_NO_MAPCHANGE);

    return Plugin_Continue;
}

public Action RestoreWitch(Handle timer, any iWitchRef)
{
    int witch = EntRefToEntIndex(iWitchRef);

    if (witch <= 0 || !IsWitch(witch))
    {
        return Plugin_Stop;
    }

    float origin[3];
    float angles[3];

    GetEntPropVector(witch, Prop_Send, "m_vecOrigin", origin);
    GetEntPropVector(witch, Prop_Send, "m_angRotation", angles);

    AcceptEntityInput(witch, "Kill");
    L4D2_SpawnWitch(origin, angles);

    return Plugin_Stop;
}

bool IsWitch(entity)
{
    if (entity > 0 && IsValidEntity(entity) && IsValidEdict(entity))
    {
        char strClassName[64];
        GetEdictClassname(entity, strClassName, sizeof(strClassName));

        return StrEqual(strClassName, "witch");
    }

    return false;
}