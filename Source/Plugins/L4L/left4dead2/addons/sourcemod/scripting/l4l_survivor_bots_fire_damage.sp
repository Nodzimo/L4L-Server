#include <l4l/utils>
#include <sdkhooks>

#define PLUGIN_VERSION "0.0.1"

ConVar g_hCvarFireDamage;
float  g_fCvarFireDamage;

public Plugin myinfo =
{
    name        = "L4L: Survivor Bots Fire Damage",
    author      = "Sefo",
    description = "Overrides incoming fire damage for survivor bots",
    version     = PLUGIN_VERSION,
    url         = "Sefo.su"
};

public void OnPluginStart()
{
    g_hCvarFireDamage = CreateConVar(
        "l4l_survivor_bots_fire_damage", "0.1",
        "Fixed fire damage applied to survivor bots (float)",
        FCVAR_NOTIFY, true, 0.0, true, 100.0);

    CreateDirectory("cfg/sourcemod/l4l_plugins", 511, true);
    AutoExecConfig(true, "l4l_survivor_bots_fire_damage", "sourcemod/l4l_plugins");

    g_fCvarFireDamage = g_hCvarFireDamage.FloatValue;
    g_hCvarFireDamage.AddChangeHook(OnCvarChanged);

    for (int client = 1; client <= MaxClients; client++)
    {
        if (IsSurvivorBot(client))
        {
            // PrintToChatAll("OnPluginStart client: %d", client);
            HookDamage(client);
        }
    }
}

public void OnClientPutInServer(int client)
{
    if (IsSurvivorBot(client))
    {
        // PrintToChatAll("OnClientPutInServer client: %d", client);
        HookDamage(client);
    }
}

void OnCvarChanged(Handle conVar, const char[] oldValue, const char[] newValue)
{
    g_fCvarFireDamage = g_hCvarFireDamage.FloatValue;
}

Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype)
{
    if (!IsSurvivorBot(victim))
    {
        return Plugin_Continue;
    }

    // 8 Fire started, 2056 Fire from middle to end, 131072 Incap damage
    if ((damagetype == 8 || damagetype == 2056))
    {
        // PrintToChatAll("OnTakeDamage type: %d, victim: %d", damagetype, victim);
        damage = g_fCvarFireDamage;

        return Plugin_Changed;
    }

    return Plugin_Continue;
}

void HookDamage(int client)
{
    SDKHook(client, SDKHook_OnTakeDamageAlive, OnTakeDamage);
}