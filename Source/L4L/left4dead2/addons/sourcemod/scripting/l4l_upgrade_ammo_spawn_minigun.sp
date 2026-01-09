#pragma semicolon 1
#pragma newdecls required

#include <l4l/utils>
#include <l4l/lifecycle>
#include <sdktools>

#define PLUGIN_VERSION "0.0.1"

// Upgrade packs
#define PACK_INC       "upgrade_ammo_incendiary"
#define PACK_EXP       "upgrade_ammo_explosive"

// Models
#define MODEL_MINIGUN  "models/w_models/weapons/w_minigun.mdl"
#define MODEL_50CAL    "models/w_models/weapons/50cal.mdl"

// Turrets
#define TURRET_MINIGUN "prop_minigun_l4d1"
#define TURRET_50CAL   "prop_mounted_machine_gun"

// Offsets
#define OFF_FWD        32.0
#define OFF_UP         0.0

ConVar g_hCvarEnable, g_hCvarDebug;
int    g_iCvarDebug;

public Plugin myinfo =
{
    name    = "L4L: Upgrade Ammo Spawn Minigun",
    author  = "Sefo",
    version = PLUGIN_VERSION,
    url     = "Sefo.su"
};

public void OnPluginStart()
{
    CreateConVar("l4l_upgrade_ammo_spawn_minigun_version", PLUGIN_VERSION, "L4L: Upgrade Ammo Spawn Minigun version", CVAR_FLAGS | FCVAR_DONTRECORD);
    g_hCvarEnable = CreateConVar("l4l_upgrade_ammo_spawn_minigun_enable", "0", "0 = Plugin off, 1 = Plugin on", CVAR_FLAGS, true, float(DISABLE), true, float(ENABLE));
    g_hCvarDebug  = CreateConVar("l4l_upgrade_ammo_spawn_minigun_debug", "0", "0 = Debug off, 1 = Debug on, 2 = Debug events, 3 = Debug sounds", CVAR_FLAGS, true, float(DISABLE), true, float(DEBUG_SOUNDS));

    CreateDirectory("cfg/sourcemod/l4l_plugins", 511, true);
    AutoExecConfig(true, "l4l_upgrade_ammo_spawn_minigun", "sourcemod/l4l_plugins");

    g_hCvarEnable.AddChangeHook(CvarChanged_Enable);
    g_hCvarDebug.AddChangeHook(CvarChanged_Cvars);
}

public void OnMapStart()
{
    if (!IsModelPrecached(MODEL_MINIGUN))
    {
        PrecacheModel(MODEL_MINIGUN, true);
    }

    if (!IsModelPrecached(MODEL_50CAL))
    {
        PrecacheModel(MODEL_50CAL, true);
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
    g_iCvarDebug = g_hCvarDebug.IntValue;
}

void L4L_Hook()
{
    HookEvent("upgrade_pack_used", Event_UpgradePackUsed);
}

void L4L_Unhook()
{
    UnhookEvent("upgrade_pack_used", Event_UpgradePackUsed);
}

public void Event_UpgradePackUsed(Event event, const char[] name, bool dontBroadcast)
{
    int client = GetClientOfUserId(event.GetInt("userid"));

    if (client <= 0 || client > MaxClients || !IsClientInGame(client))
    {
        return;
    }

    int packEnt = event.GetInt("upgradeid");

    if (packEnt <= MaxClients || !IsValidEdict(packEnt) || !IsValidEntity(packEnt))
    {
        return;
    }

    char cls[64];
    GetEdictClassname(packEnt, cls, sizeof(cls));

    char turretClass[64];
    char turretModel[128];

    if (StrEqual(cls, PACK_INC, false))
    {
        strcopy(turretClass, sizeof(turretClass), TURRET_MINIGUN);
        strcopy(turretModel, sizeof(turretModel), MODEL_MINIGUN);
    }
    else if (StrEqual(cls, PACK_EXP, false))
    {
        strcopy(turretClass, sizeof(turretClass), TURRET_50CAL);
        strcopy(turretModel, sizeof(turretModel), MODEL_50CAL);
    }
    else
    {
        return;
    }

    SpawnTurretNearPack(turretClass, turretModel, client, packEnt);
}

static void SpawnTurretNearPack(const char[] turretClass, const char[] turretModel, int client, int packEnt)
{
    float origin[3];
    GetEntPropVector(packEnt, Prop_Send, "m_vecOrigin", origin);

    float ang[3];
    GetClientEyeAngles(client, ang);
    ang[0] = 0.0;
    ang[2] = 0.0;

    float fwd[3];
    GetAngleVectors(ang, fwd, NULL_VECTOR, NULL_VECTOR);

    origin[0] += fwd[0] * OFF_FWD;
    origin[1] += fwd[1] * OFF_FWD;
    origin[2] += OFF_UP;

    int ent = CreateEntityByName(turretClass);

    if (ent <= 0)
    {
        return;
    }

    DispatchKeyValue(ent, "model", turretModel);
    DispatchKeyValueFloat(ent, "MaxPitch", 360.0);
    DispatchKeyValueFloat(ent, "MinPitch", -360.0);
    DispatchKeyValueFloat(ent, "MaxYaw", 90.0);
    DispatchKeyValueVector(ent, "Angles", ang);

    TeleportEntity(ent, origin, NULL_VECTOR, NULL_VECTOR);
    DispatchSpawn(ent);
    ActivateEntity(ent);

    if (g_iCvarDebug >= 1)
    {
        PrintToChatAll("[L4L] Spawned %s (%s) at (%.1f %.1f %.1f) yaw=%.1f",
                       turretClass, turretModel, origin[0], origin[1], origin[2], ang[1]);
    }
}