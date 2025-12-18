#pragma semicolon 1
#pragma newdecls required

#include <l4l/utils>
#include <l4l/lifecycle>
#include <sdkhooks>
#include <left4dhooks>

#define PLUGIN_VERSION "0.0.1"

ConVar g_hCvarEnable, g_hCvarDebug, g_hCvarInfectedDamage;
int    g_iCvarDebug;
float  g_fCvarInfectedDamage;

public Plugin myinfo =
{
    name    = "L4L: Common Infected Damage",
    author  = "Sefo",
    version = PLUGIN_VERSION,
    url     = "Sefo.su"
};

public void OnPluginStart()
{
    CreateConVar("l4l_common_infected_damage_version", PLUGIN_VERSION, "L4L: Common Infected Damage version", CVAR_FLAGS | FCVAR_DONTRECORD);
    g_hCvarEnable         = CreateConVar("l4l_common_infected_damage_enable", "0", "0 = Plugin off, 1 = Plugin on", CVAR_FLAGS, true, float(DISABLE), true, float(ENABLE));
    g_hCvarDebug          = CreateConVar("l4l_common_infected_damage_debug", "0", "0 = Debug off, 1 = Debug on, 2 = Debug events, 3 = Debug sounds", CVAR_FLAGS, true, float(DISABLE), true, float(DEBUG_SOUNDS));
    g_hCvarInfectedDamage = CreateConVar(
        "l4l_common_infected_damage", "30.0",
        "Fixed common infected punch damage (float)",
        FCVAR_NOTIFY, true, 0.0, true, 100.0);

    CreateDirectory("cfg/sourcemod/l4l_plugins", 511, true);
    AutoExecConfig(true, "l4l_common_infected_damage", "sourcemod/l4l_plugins");

    g_hCvarEnable.AddChangeHook(CvarChanged_Enable);
    g_hCvarDebug.AddChangeHook(CvarChanged_Cvars);
    g_hCvarInfectedDamage.AddChangeHook(CvarChanged_Cvars);
    g_fCvarInfectedDamage = g_hCvarInfectedDamage.FloatValue;
}

public void OnClientPutInServer(int client)
{
    if (g_hCvarEnable.BoolValue)
    {
        // PrintToChatAll("OnClientPutInServer client: %d", client);
        SDKHook(client, SDKHook_OnTakeDamageAlive, OnTakeDamage);
    }
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
    g_fCvarInfectedDamage = g_hCvarInfectedDamage.FloatValue;
}

void L4L_Hook()
{
    for (int client = MIN_CLIENT; client <= MaxClients; client++)
    {
        if (IsValidClient(client))
        {
            SDKHook(client, SDKHook_OnTakeDamageAlive, OnTakeDamage);
        }
    }
}

void L4L_Unhook()
{
    for (int client = MIN_CLIENT; client <= MaxClients; client++)
    {
        if (IsValidClient(client))
        {
            SDKUnhook(client, SDKHook_OnTakeDamageAlive, OnTakeDamage);
        }
    }
}

Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype)
{
    if (!IsValidClient(victim) || !IsSurvivor(victim))
    {
        return Plugin_Continue;
    }

    // Attacker is not a player AND damage type is common punch
    if (attacker <= MaxClients || !(damagetype & DAMAGE_TYPE_PUNCH))
    {
        return Plugin_Continue;
    }

    if (!IsValidEntity(attacker))
    {
        return Plugin_Continue;
    }

    char classname[16];
    GetEntityClassname(attacker, classname, sizeof(classname));

    // Common infected only
    if (!StrEqual(classname, "infected"))
    {
        return Plugin_Continue;
    }

    // Skip special survivor states (engine uses different damage rules there)
    if (GetEntProp(victim, Prop_Send, "m_isIncapacitated") || GetEntProp(victim, Prop_Send, "m_isHangingFromLedge"))
    {
        return Plugin_Continue;
    }

    int   clientHealth = GetClientHealth(victim);
    float tempHealth   = L4D_GetTempHealth(victim);
    float totalHealth  = float(clientHealth) + tempHealth;

    // Guard: never make the hit lethal (preserve native incap logic)
    if (g_fCvarInfectedDamage >= totalHealth)
    {
        if (g_iCvarDebug)
        {
            PrintToChatAll("[L4L CI DMG] SKIP lethal: %N old=%.1f new=%.1f hp=%d temp=%.1f total=%.1f (type=%d)",
                           victim, damage, g_fCvarInfectedDamage, clientHealth, tempHealth, totalHealth, damagetype);
        }

        return Plugin_Continue;
    }

    float originalDamage = damage;
    damage               = g_fCvarInfectedDamage;

    if (g_iCvarDebug)
    {
        PrintToChatAll("[L4L CI DMG] APPLY: %N %.1f -> %.1f hp=%d temp=%.1f total=%.1f (type=%d)",
                       victim, originalDamage, damage, clientHealth, tempHealth, totalHealth, damagetype);
    }

    return Plugin_Changed;
}