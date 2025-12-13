#include <sdkhooks>

#define PLUGIN_VERSION "0.0.1"
#define DAMAGE_FIRE    8

// 0..100 (% of incoming fire damage applied)
ConVar g_FireScale;

public Plugin myinfo =
{
    name        = "L4L: Fireproof Bots",
    author      = "Sefo",
    description = "Scales incoming fire damage for survivor bots",
    version     = PLUGIN_VERSION,
    url         = "Sefo.su"
};

public void OnPluginStart()
{
    g_FireScale = CreateConVar(
        "l4l_fire_bots_scale", "10",
        "L4L Fireproof Bots\nScales incoming fire damage for survivor bots (0..100)\nExamples:\n0 = no fire damage\n100 = vanilla damage\n50 = half damage\n1 = 1% of incoming damage",
        FCVAR_NOTIFY, true, 0.0, true, 100.0);

    CreateDirectory("cfg/sourcemod/l4l_plugins", 511, true);
    AutoExecConfig(true, "l4l_fireproof_bots", "sourcemod/l4l_plugins");

    for (int client = 1; client <= MaxClients; client++)
    {
        if (IsSurvivorBot(client))
        {
            HookDamage(client);
        }
    }
}

public void OnClientPutInServer(int client)
{
    if (IsSurvivorBot(client))
    {
        HookDamage(client);
    }
}

Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype)
{
    if (!IsSurvivorBot(victim))
    {
        return Plugin_Continue;
    }

    if (!(damagetype & DAMAGE_FIRE))
    {
        return Plugin_Continue;
    }

    damage *= (g_FireScale.FloatValue / 100.0);

    return Plugin_Changed;
}

bool IsSurvivorBot(int client)
{
    return IsClientInGame(client) && IsFakeClient(client) && GetClientTeam(client) == 2;
}

void HookDamage(int client)
{
    SDKHook(client, SDKHook_OnTakeDamageAlive, OnTakeDamage);
}