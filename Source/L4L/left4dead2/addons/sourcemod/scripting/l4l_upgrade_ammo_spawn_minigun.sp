#pragma semicolon 1
#pragma newdecls required

#include <l4l/utils>
#include <l4l/lifecycle>
#include <sdktools>

#define PLUGIN_VERSION        "0.0.1"

// Sounds
#define SOUND_SWITCH_MODE_WEP "UI/Pickup_GuitarRiff10.wav"
#define SOUND_SWITCH_MODE_MED "UI/Helpful_Event_1.wav"
#define SOUND_USE_MODE_MED    "UI/Gift_Pickup.wav"

// Upgrade packs
#define PACK_INC              "upgrade_ammo_incendiary"
#define PACK_EXP              "upgrade_ammo_explosive"

// Models
#define MODEL_MINIGUN         "models/w_models/weapons/w_minigun.mdl"
#define MODEL_50CAL           "models/w_models/weapons/50cal.mdl"
#define MODEL_PILLS           "models/w_models/weapons/w_eq_painpills.mdl"
#define MODEL_ADREN           "models/w_models/weapons/w_eq_adrenaline.mdl"

// Turrets
#define TURRET_MINIGUN        "prop_minigun_l4d1"
#define TURRET_50CAL          "prop_mounted_machine_gun"

// Offsets
#define OFF_FWD               32.0
#define OFF_UP                0.0

ConVar g_hCvarEnable, g_hCvarDebug;
int    g_iCvarDebug, g_iPreviewRef[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... }, g_iPillsPrevRef[MAXPLAYERS + 1][4], g_iAdrenPrevRef[MAXPLAYERS + 1][4];
bool   g_bTurretMode[MAXPLAYERS + 1], g_bPillsMode[MAXPLAYERS + 1], g_bAdrenMode[MAXPLAYERS + 1];
float  g_fNextToggle[MAXPLAYERS + 1], g_fNextUse[MAXPLAYERS + 1];

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

    for (int i = 1; i <= MaxClients; i++)
    {
        for (int j = 0; j < 4; j++)
        {
            g_iPillsPrevRef[i][j] = INVALID_ENT_REFERENCE;
            g_iAdrenPrevRef[i][j] = INVALID_ENT_REFERENCE;
        }
    }
}

public void OnMapStart()
{
    PrecacheSound(SOUND_SWITCH_MODE_WEP);
    PrecacheSound(SOUND_SWITCH_MODE_MED);
    PrecacheSound(SOUND_USE_MODE_MED);

    if (!IsModelPrecached(MODEL_MINIGUN))
    {
        PrecacheModel(MODEL_MINIGUN, true);
    }

    if (!IsModelPrecached(MODEL_50CAL))
    {
        PrecacheModel(MODEL_50CAL, true);
    }

    if (!IsModelPrecached(MODEL_PILLS))
    {
        PrecacheModel(MODEL_PILLS, true);
    }

    if (!IsModelPrecached(MODEL_ADREN))
    {
        PrecacheModel(MODEL_ADREN, true);
    }
}

public void OnMapEnd()
{
    for (int i = 1; i <= MaxClients; i++)
    {
        DestroyPreview(i);
        DestroyPillsPreview(i);
        DestroyAdrenPreview(i);
    }
}

public void OnConfigsExecuted()
{
    L4L_LC_OnConfigsExecuted(g_hCvarEnable.BoolValue);
}

void CvarChanged_Enable(ConVar cvar, const char[] oldValue, const char[] newValue)
{
    L4L_LC_OnEnableChanged(g_hCvarEnable.BoolValue);

    if (!g_hCvarEnable.BoolValue)
    {
        for (int i = 1; i <= MaxClients; i++)
        {
            g_bTurretMode[i] = false;
            g_bPillsMode[i]  = false;
            g_bAdrenMode[i]  = false;

            g_fNextToggle[i] = 0.0;
            g_fNextUse[i]    = 0.0;

            DestroyPreview(i);
            DestroyPillsPreview(i);
            DestroyAdrenPreview(i);
        }
    }
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

    if (!g_bTurretMode[client])
    {
        return;
    }

    SpawnTurretNearPack(turretClass, turretModel, client, packEnt);
    AcceptEntityInput(packEnt, "Kill");
}

static void SpawnTurretNearPack(const char[] turretClass, const char[] turretModel, int client, int packEnt)
{
    float origin[3];
    GetEntPropVector(packEnt, Prop_Send, "m_vecOrigin", origin);

    float ang[3];
    GetClientEyeAngles(client, ang);
    ang[0]  = 0.0;
    ang[2]  = 0.0;

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

// Preview: turret (single)
static void DestroyPreview(int client)
{
    int ent = EntRefToEntIndex(g_iPreviewRef[client]);

    if (ent > 0 && IsValidEdict(ent) && IsValidEntity(ent))
    {
        RemoveEntity(ent);
    }

    g_iPreviewRef[client] = INVALID_ENT_REFERENCE;
}

static void EnsurePreview(int client, const char[] model)
{
    int ent = EntRefToEntIndex(g_iPreviewRef[client]);

    if (ent > 0 && IsValidEdict(ent) && IsValidEntity(ent))
    {
        return;
    }

    ent = CreateEntityByName("prop_dynamic");

    if (ent <= 0)
    {
        return;
    }

    DispatchKeyValue(ent, "model", model);
    DispatchKeyValue(ent, "solid", "0");
    DispatchSpawn(ent);
    ActivateEntity(ent);

    SetEntityRenderMode(ent, RENDER_TRANSCOLOR);
    SetEntityRenderColor(ent, 255, 255, 255, 200);

    g_iPreviewRef[client] = EntIndexToEntRef(ent);
}

// Preview helpers (4 entities)
static void EnsureQuadPreview(int refs[MAXPLAYERS + 1][4], int client, const char[] model)
{
    for (int i = 0; i < 4; i++)
    {
        int ent = EntRefToEntIndex(refs[client][i]);

        if (ent > 0 && IsValidEdict(ent) && IsValidEntity(ent))
        {
            continue;
        }

        ent = CreateEntityByName("prop_dynamic");

        if (ent <= 0)
        {
            continue;
        }

        DispatchKeyValue(ent, "model", model);
        DispatchKeyValue(ent, "solid", "0");
        DispatchSpawn(ent);
        ActivateEntity(ent);

        SetEntityRenderMode(ent, RENDER_TRANSCOLOR);
        SetEntityRenderColor(ent, 255, 255, 255, 200);

        refs[client][i] = EntIndexToEntRef(ent);
    }
}

static void DestroyQuadPreview(int refs[MAXPLAYERS + 1][4], int client)
{
    for (int i = 0; i < 4; i++)
    {
        int ent = EntRefToEntIndex(refs[client][i]);

        if (ent > 0 && IsValidEdict(ent) && IsValidEntity(ent))
        {
            RemoveEntity(ent);
        }

        refs[client][i] = INVALID_ENT_REFERENCE;
    }
}

static void UpdateQuadPreview(int refs[MAXPLAYERS + 1][4], int client)
{
    float origin[3];
    GetClientAbsOrigin(client, origin);

    float ang[3];
    GetClientEyeAngles(client, ang);
    ang[0] = 0.0;
    ang[2] = 0.0;

    float fwd[3], right[3];
    GetAngleVectors(ang, fwd, right, NULL_VECTOR);

    origin[0] += fwd[0] * OFF_FWD;
    origin[1] += fwd[1] * OFF_FWD;
    origin[2] += OFF_UP;

    const float s             = 12.0;
    float       offsets[4][2] = {
        {-s,  -s},
        { -s, s },
        { s,  -s},
        { s,  s }
    };

    for (int i = 0; i < 4; i++)
    {
        int ent = EntRefToEntIndex(refs[client][i]);

        if (ent <= 0 || !IsValidEdict(ent) || !IsValidEntity(ent))
        {
            continue;
        }

        float pos[3];
        pos[0] = origin[0] + right[0] * offsets[i][0] + fwd[0] * offsets[i][1];
        pos[1] = origin[1] + right[1] * offsets[i][0] + fwd[1] * offsets[i][1];
        pos[2] = origin[2];

        TeleportEntity(ent, pos, ang, NULL_VECTOR);
    }
}

// Pills preview wrappers
static void EnsurePillsPreview(int client)
{
    EnsureQuadPreview(g_iPillsPrevRef, client, MODEL_PILLS);
}

static void DestroyPillsPreview(int client)
{
    DestroyQuadPreview(g_iPillsPrevRef, client);
}

static void UpdatePillsPreview(int client)
{
    UpdateQuadPreview(g_iPillsPrevRef, client);
}

// Adren preview wrappers
static void EnsureAdrenPreview(int client)
{
    EnsureQuadPreview(g_iAdrenPrevRef, client, MODEL_ADREN);
}

static void DestroyAdrenPreview(int client)
{
    DestroyQuadPreview(g_iAdrenPrevRef, client);
}

static void UpdateAdrenPreview(int client)
{
    UpdateQuadPreview(g_iAdrenPrevRef, client);
}

// Spawn quad items
static void SpawnQuadItem(int client, const char[] weaponClass)
{
    float origin[3];
    GetClientAbsOrigin(client, origin);

    float ang[3];
    GetClientEyeAngles(client, ang);
    ang[0] = 0.0;
    ang[2] = 0.0;

    float fwd[3], right[3];
    GetAngleVectors(ang, fwd, right, NULL_VECTOR);

    origin[0] += fwd[0] * OFF_FWD;
    origin[1] += fwd[1] * OFF_FWD;
    origin[2] += OFF_UP;

    const float s             = 12.0;
    float       offsets[4][2] = {
        {-s,  -s},
        { -s, s },
        { s,  -s},
        { s,  s }
    };

    for (int i = 0; i < 4; i++)
    {
        float pos[3];
        pos[0]  = origin[0] + right[0] * offsets[i][0] + fwd[0] * offsets[i][1];
        pos[1]  = origin[1] + right[1] * offsets[i][0] + fwd[1] * offsets[i][1];
        pos[2]  = origin[2];

        int ent = CreateEntityByName(weaponClass);

        if (ent <= 0)
        {
            continue;
        }

        DispatchSpawn(ent);
        ActivateEntity(ent);
        TeleportEntity(ent, pos, NULL_VECTOR, NULL_VECTOR);
    }
}

static void ConsumeActiveIfClass(int client, const char[] expectedClass)
{
    int wep = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");

    if (wep <= MaxClients || !IsValidEdict(wep) || !IsValidEntity(wep))
    {
        return;
    }

    char cls[64];
    GetEdictClassname(wep, cls, sizeof(cls));

    if (!StrEqual(cls, expectedClass, false))
    {
        return;
    }

    RemovePlayerItem(client, wep);
    RemoveEntity(wep);
}

public Action OnPlayerRunCmd(int client, int& buttons, int& impulse, float vel[3], float angles[3],
                      int& weapon, int& subtype, int& cmdnum, int& tickcount, int& seed, int mouse[2])
{
    if (!g_hCvarEnable.BoolValue)
    {
        return Plugin_Continue;
    }

    if (client <= 0 || client > MaxClients || !IsClientInGame(client) || !IsPlayerAlive(client))
    {
        return Plugin_Continue;
    }

    int wep = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");

    if (wep <= MaxClients || !IsValidEdict(wep) || !IsValidEntity(wep))
    {
        g_bTurretMode[client] = false;
        g_bPillsMode[client]  = false;
        g_bAdrenMode[client]  = false;

        DestroyPreview(client);
        DestroyPillsPreview(client);
        DestroyAdrenPreview(client);

        return Plugin_Continue;
    }

    char wcls[64];
    GetEdictClassname(wep, wcls, sizeof(wcls));

    // Upgrade packs: turret mode
    if (StrEqual(wcls, "weapon_upgradepack_incendiary", false) || StrEqual(wcls, "weapon_upgradepack_explosive", false))
    {
        // switching item -> reset other modes
        g_bPillsMode[client] = false;
        g_bAdrenMode[client] = false;

        DestroyPillsPreview(client);
        DestroyAdrenPreview(client);

        char model[128];
        if (StrEqual(wcls, "weapon_upgradepack_incendiary", false))
        {
            strcopy(model, sizeof(model), MODEL_MINIGUN);
        }
        else
        {
            strcopy(model, sizeof(model), MODEL_50CAL);
        }

        if (buttons & IN_RELOAD)
        {
            float now = GetGameTime();

            if (now >= g_fNextToggle[client])
            {
                g_bTurretMode[client] = !g_bTurretMode[client];
                g_fNextToggle[client] = now + 0.30;

                if (g_iCvarDebug >= 1)
                {
                    PrintToChat(client, "[L4L] Turret mode: %s", g_bTurretMode[client] ? "ON" : "OFF");
                }

                if (!g_bTurretMode[client])
                {
                    DestroyPreview(client);
                }

                PlaySound(client, SOUND_SWITCH_MODE_WEP);
                buttons &= ~IN_RELOAD;

                return Plugin_Changed;
            }
        }

        if (!g_bTurretMode[client])
        {
            DestroyPreview(client);

            return Plugin_Continue;
        }

        EnsurePreview(client, model);

        int ent = EntRefToEntIndex(g_iPreviewRef[client]);

        if (ent <= 0)
        {
            return Plugin_Continue;
        }

        float origin[3];
        GetClientAbsOrigin(client, origin);

        float ang[3];
        GetClientEyeAngles(client, ang);
        ang[0] = 0.0;
        ang[2] = 0.0;

        float fwd[3];
        GetAngleVectors(ang, fwd, NULL_VECTOR, NULL_VECTOR);

        origin[0] += fwd[0] * OFF_FWD;
        origin[1] += fwd[1] * OFF_FWD;
        origin[2] += OFF_UP;

        TeleportEntity(ent, origin, ang, NULL_VECTOR);

        return Plugin_Continue;
    }

    // Medkit: pills mode
    if (StrEqual(wcls, "weapon_first_aid_kit", false))
    {
        // switching item -> reset other modes
        g_bTurretMode[client] = false;
        g_bAdrenMode[client]  = false;

        DestroyPreview(client);
        DestroyAdrenPreview(client);

        if (buttons & IN_RELOAD)
        {
            float now = GetGameTime();

            if (now >= g_fNextToggle[client])
            {
                g_bPillsMode[client]  = !g_bPillsMode[client];
                g_fNextToggle[client] = now + 0.30;

                if (g_iCvarDebug >= 1)
                {
                    PrintToChat(client, "[L4L] Pills mode: %s", g_bPillsMode[client] ? "ON" : "OFF");
                }

                if (!g_bPillsMode[client])
                {
                    DestroyPillsPreview(client);
                }

                PlaySound(client, SOUND_SWITCH_MODE_MED);
                buttons &= ~IN_RELOAD;

                return Plugin_Changed;
            }
        }

        if (!g_bPillsMode[client])
        {
            DestroyPillsPreview(client);

            return Plugin_Continue;    // native medkit
        }

        EnsurePillsPreview(client);
        UpdatePillsPreview(client);

        if (buttons & (IN_ATTACK | IN_ATTACK2))
        {
            float now = GetGameTime();

            if (now >= g_fNextUse[client])
            {
                g_fNextUse[client] = now + 0.30;

                SpawnQuadItem(client, "weapon_pain_pills");
                ConsumeActiveIfClass(client, "weapon_first_aid_kit");

                g_bPillsMode[client] = false;
                DestroyPillsPreview(client);

                PlaySound(client, SOUND_USE_MODE_MED);
            }

            buttons &= ~IN_ATTACK;
            buttons &= ~IN_ATTACK2;

            return Plugin_Changed;
        }

        return Plugin_Continue;
    }

    // Defib: adrenaline mode
    if (StrEqual(wcls, "weapon_defibrillator", false))
    {
        // switching item -> reset other modes
        g_bTurretMode[client] = false;
        g_bPillsMode[client]  = false;

        DestroyPreview(client);
        DestroyPillsPreview(client);

        if (buttons & IN_RELOAD)
        {
            float now = GetGameTime();

            if (now >= g_fNextToggle[client])
            {
                g_bAdrenMode[client]  = !g_bAdrenMode[client];
                g_fNextToggle[client] = now + 0.30;

                if (g_iCvarDebug >= 1)
                {
                    PrintToChat(client, "[L4L] Adren mode: %s", g_bAdrenMode[client] ? "ON" : "OFF");
                }

                if (!g_bAdrenMode[client])
                {
                    DestroyAdrenPreview(client);
                }

                PlaySound(client, SOUND_SWITCH_MODE_MED);
                buttons &= ~IN_RELOAD;

                return Plugin_Changed;
            }
        }

        if (!g_bAdrenMode[client])
        {
            DestroyAdrenPreview(client);

            return Plugin_Continue;    // native defib
        }

        EnsureAdrenPreview(client);
        UpdateAdrenPreview(client);

        if (buttons & (IN_ATTACK | IN_ATTACK2))
        {
            float now = GetGameTime();

            if (now >= g_fNextUse[client])
            {
                g_fNextUse[client] = now + 0.30;

                SpawnQuadItem(client, "weapon_adrenaline");
                ConsumeActiveIfClass(client, "weapon_defibrillator");

                g_bAdrenMode[client] = false;
                DestroyAdrenPreview(client);

                PlaySound(client, SOUND_USE_MODE_MED);
            }

            buttons &= ~IN_ATTACK;
            buttons &= ~IN_ATTACK2;

            return Plugin_Changed;
        }

        return Plugin_Continue;
    }

    // Other item: reset all
    g_bTurretMode[client] = false;
    g_bPillsMode[client]  = false;
    g_bAdrenMode[client]  = false;

    g_fNextToggle[client] = 0.0;
    g_fNextUse[client]    = 0.0;

    DestroyPreview(client);
    DestroyPillsPreview(client);
    DestroyAdrenPreview(client);

    return Plugin_Continue;
}

public void OnClientDisconnect(int client)
{
    g_bTurretMode[client] = false;
    g_bPillsMode[client]  = false;
    g_bAdrenMode[client]  = false;

    g_fNextToggle[client] = 0.0;
    g_fNextUse[client]    = 0.0;

    DestroyPreview(client);
    DestroyPillsPreview(client);
    DestroyAdrenPreview(client);

    for (int i = 0; i < 4; i++)
    {
        g_iPillsPrevRef[client][i] = INVALID_ENT_REFERENCE;
        g_iAdrenPrevRef[client][i] = INVALID_ENT_REFERENCE;
    }
}

void PlaySound(int client, const char sound[32])
{
    EmitSoundToClient(client, sound, SOUND_FROM_PLAYER, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
}