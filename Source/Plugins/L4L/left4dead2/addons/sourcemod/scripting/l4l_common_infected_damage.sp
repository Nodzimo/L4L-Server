#pragma semicolon 1
#pragma newdecls required

#include <l4l/utils>
#include <l4l/lifecycle>
#include <sdkhooks>

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
    if (attacker > MaxClients && (damagetype & DAMAGE_TYPE_PUNCH))
    {
        if (!IsValidEntity(attacker))
        {
            return Plugin_Continue;
        }

        char classname[16];
        GetEntityClassname(attacker, classname, sizeof(classname));

        // Common infected
        if (StrEqual(classname, "infected"))
        {
            // PrintToChatAll("OnTakeDamage type: %d, victim: %d", damagetype, victim);
            damage = g_fCvarInfectedDamage;

            return Plugin_Changed;
        }
    }

    return Plugin_Continue;
}