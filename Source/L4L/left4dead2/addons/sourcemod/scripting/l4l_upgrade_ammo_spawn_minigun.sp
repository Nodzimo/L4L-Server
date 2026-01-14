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

// Upgrade packs (world entities from event)
#define PACK_INC              "upgrade_ammo_incendiary"
#define PACK_EXP              "upgrade_ammo_explosive"

// Inventory weapon classnames
#define WEP_PACK_INC          "weapon_upgradepack_incendiary"
#define WEP_PACK_EXP          "weapon_upgradepack_explosive"
#define WEP_MEDKIT            "weapon_first_aid_kit"
#define WEP_DEFIB             "weapon_defibrillator"
#define ITEM_PILLS            "weapon_pain_pills"
#define ITEM_ADREN            "weapon_adrenaline"
#define ITEM_BILE             "weapon_vomitjar"
#define ITEM_MOLOTOV          "weapon_molotov"
#define ITEM_GASCAN           "weapon_gascan"
#define ITEM_FIREWORKCRATE    "weapon_fireworkcrate"
#define ITEM_PIPEBOMB         "weapon_pipe_bomb"
#define ITEM_OXYGEN           "weapon_oxygentank"
#define ITEM_PROPANE          "weapon_propanetank"

// Models
#define MODEL_MINIGUN         "models/w_models/weapons/w_minigun.mdl"
#define MODEL_50CAL           "models/w_models/weapons/50cal.mdl"
#define MODEL_PILLS           "models/w_models/weapons/w_eq_painpills.mdl"
#define MODEL_ADREN           "models/w_models/weapons/w_eq_adrenaline.mdl"
#define MODEL_BILE            "models/w_models/weapons/w_eq_bile_flask.mdl"
#define MODEL_MOLOTOV         "models/w_models/weapons/w_eq_molotov.mdl"
#define MODEL_GASCAN          "models/props_junk/gascan001a.mdl"
#define MODEL_FIREWORKCRATE   "models/props_junk/explosive_box001.mdl"
#define MODEL_PIPEBOMB        "models/w_models/weapons/w_eq_pipebomb.mdl"
#define MODEL_OXYGEN          "models/props_equipment/oxygentank01.mdl"
#define MODEL_PROPANE         "models/props_junk/propanecanister001a.mdl"

// Turrets
#define TURRET_MINIGUN        "prop_minigun_l4d1"
#define TURRET_50CAL          "prop_mounted_machine_gun"

// Offsets
#define OFF_FWD               32.0
#define OFF_UP                0.0
#define Z_NONE                0.0
#define Z_SMALL               5.0
#define Z_MED                 10.0
#define Z_LARGE               15.0

enum
{
    MODE2_NATIVE = 0,
    MODE2_ALT1   = 1
};

enum
{
    MODE3_NATIVE = 0,
    MODE3_ALT1   = 1,
    MODE3_ALT2   = 2
};

ConVar g_hCvarEnable, g_hCvarDebug;
int    g_iCvarDebug;

// Single preview refs
int    g_iPreviewRef[MAXPLAYERS + 1]  = { INVALID_ENT_REFERENCE, ... };
int    g_iBilePrevRef[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };

// Quad preview refs
int    g_iPillsPrevRef[MAXPLAYERS + 1][4];
int    g_iAdrenPrevRef[MAXPLAYERS + 1][4];

// Triple preview refs (for upgrade packs mode 1)
int    g_iPackPrevRef[MAXPLAYERS + 1][3];

// Modes
int    g_iPackMode[MAXPLAYERS + 1];      // 0 native, 1 triple items, 2 turret
int    g_iMedkitMode[MAXPLAYERS + 1];    // 0 native, 1 pills
int    g_iDefibMode[MAXPLAYERS + 1];     // 0 native, 1 adren quad, 2 bile

float  g_fNextToggle[MAXPLAYERS + 1];
float  g_fNextUse[MAXPLAYERS + 1];

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

        for (int k = 0; k < 3; k++)
        {
            g_iPackPrevRef[i][k] = INVALID_ENT_REFERENCE;
        }
    }
}

public void OnMapStart()
{
    PrecacheSound(SOUND_SWITCH_MODE_WEP);
    PrecacheSound(SOUND_SWITCH_MODE_MED);
    PrecacheSound(SOUND_USE_MODE_MED);

    EnsureModelPrecached(MODEL_MINIGUN);
    EnsureModelPrecached(MODEL_50CAL);
    EnsureModelPrecached(MODEL_PILLS);
    EnsureModelPrecached(MODEL_ADREN);
    EnsureModelPrecached(MODEL_BILE);
    EnsureModelPrecached(MODEL_MOLOTOV);
    EnsureModelPrecached(MODEL_GASCAN);
    EnsureModelPrecached(MODEL_FIREWORKCRATE);
    EnsureModelPrecached(MODEL_PIPEBOMB);
    EnsureModelPrecached(MODEL_OXYGEN);
    EnsureModelPrecached(MODEL_PROPANE);
}

public void OnMapEnd()
{
    for (int i = 1; i <= MaxClients; i++)
    {
        ResetClientState(i);
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
            ResetClientState(i);
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

static void EnsureModelPrecached(const char[] model)
{
    if (!IsModelPrecached(model))
    {
        PrecacheModel(model, true);
    }
}

static void ResetClientState(int client)
{
    g_iPackMode[client]   = MODE3_NATIVE;
    g_iMedkitMode[client] = MODE2_NATIVE;
    g_iDefibMode[client]  = MODE3_NATIVE;

    g_fNextToggle[client] = 0.0;
    g_fNextUse[client]    = 0.0;

    DestroyPreview(client);
    DestroyBilePreview(client);
    DestroyPillsPreview(client);
    DestroyAdrenPreview(client);
    DestroyPackPreview(client);
}

public void OnClientDisconnect(int client)
{
    ResetClientState(client);

    for (int i = 0; i < 4; i++)
    {
        g_iPillsPrevRef[client][i] = INVALID_ENT_REFERENCE;
        g_iAdrenPrevRef[client][i] = INVALID_ENT_REFERENCE;
    }

    for (int k = 0; k < 3; k++)
    {
        g_iPackPrevRef[client][k] = INVALID_ENT_REFERENCE;
    }
}

public void Event_UpgradePackUsed(Event event, const char[] name, bool dontBroadcast)
{
    int client = GetClientOfUserId(event.GetInt("userid"));

    if (client <= 0 || client > MaxClients || !IsClientInGame(client))
    {
        return;
    }

    int mode = g_iPackMode[client];

    if (mode != MODE3_ALT2 && mode != MODE3_ALT1)
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

    bool isInc = false;

    if (StrEqual(cls, PACK_INC, false))
    {
        isInc = true;
    }
    else if (StrEqual(cls, PACK_EXP, false))
    {
        isInc = false;
    }
    else
    {
        return;
    }

    if (mode == MODE3_ALT2)
    {
        char turretClass[64];
        char turretModel[128];

        if (isInc)
        {
            strcopy(turretClass, sizeof(turretClass), TURRET_MINIGUN);
            strcopy(turretModel, sizeof(turretModel), MODEL_MINIGUN);
        }
        else
        {
            strcopy(turretClass, sizeof(turretClass), TURRET_50CAL);
            strcopy(turretModel, sizeof(turretModel), MODEL_50CAL);
        }

        SpawnTurretNearPack(turretClass, turretModel, client, packEnt);
        AcceptEntityInput(packEnt, "Kill");

        // cleanup
        g_iPackMode[client] = MODE3_NATIVE;
        DestroyPreview(client);

        return;
    }

    char c0[64], c1[64], c2[64], expectedWep[64];
    GetPackTripleItems(isInc, c0, c1, c2, expectedWep);

    SpawnTripleItems(client, c0, c1, c2);
    ConsumeActiveIfClass(client, expectedWep);

    AcceptEntityInput(packEnt, "Kill");

    // cleanup
    g_iPackMode[client] = MODE3_NATIVE;
    DestroyPackPreview(client);
    DestroyPreview(client);
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

static int CreatePreviewEntForModel(const char[] model)
{
    int ent = CreateEntityByName("prop_dynamic_override");

    if (ent <= 0)
    {
        ent = CreateEntityByName("prop_dynamic");
    }

    if (ent <= 0)
    {
        return -1;
    }

    DispatchKeyValue(ent, "model", model);
    DispatchKeyValue(ent, "solid", "0");
    DispatchSpawn(ent);
    ActivateEntity(ent);

    SetEntityRenderMode(ent, RENDER_TRANSCOLOR);
    SetEntityRenderColor(ent, 255, 255, 255, 200);

    return ent;
}

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

static void UpdateQuadPreview(int refs[MAXPLAYERS + 1][4], int client, const char[] model)
{
    float origin[3];
    float ang[3];
    float fwd[3], right[3];

    GetClientPreviewBasis(client, origin, ang, fwd, right);

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
        pos[2] = origin[2] + GetPreviewZOffset(model);

        TeleportEntity(ent, pos, ang, NULL_VECTOR);
    }
}

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
    UpdateQuadPreview(g_iPillsPrevRef, client, MODEL_PILLS);
}

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
    UpdateQuadPreview(g_iAdrenPrevRef, client, MODEL_ADREN);
}

static void DestroyPackPreview(int client)
{
    for (int i = 0; i < 3; i++)
    {
        int ent = EntRefToEntIndex(g_iPackPrevRef[client][i]);

        if (ent > 0 && IsValidEdict(ent) && IsValidEntity(ent))
        {
            RemoveEntity(ent);
        }

        g_iPackPrevRef[client][i] = INVALID_ENT_REFERENCE;
    }
}

static void EnsurePackPreview(int client, const char[] m0, const char[] m1, const char[] m2)
{
    for (int i = 0; i < 3; i++)
    {
        int ent = EntRefToEntIndex(g_iPackPrevRef[client][i]);

        if (ent > 0 && IsValidEdict(ent) && IsValidEntity(ent))
        {
            continue;
        }

        char model[128];

        if (i == 0)
        {
            strcopy(model, sizeof(model), m0);
        }
        else if (i == 1)
        {
            strcopy(model, sizeof(model), m1);
        }
        else
        {
            strcopy(model, sizeof(model), m2);
        }

        ent = CreatePreviewEntForModel(model);

        if (ent <= 0)
        {
            continue;
        }

        g_iPackPrevRef[client][i] = EntIndexToEntRef(ent);
    }
}

static void UpdatePackPreview(int client, const char[] m0, const char[] m1, const char[] m2)
{
    float origin[3];
    float ang[3];
    float fwd[3], right[3];

    GetClientPreviewBasis(client, origin, ang, fwd, right);

    const float s             = 14.0;
    float       offsets[3][2] = {
        {-s,   -s},
        { s,   -s},
        { 0.0, s }
    };

    for (int i = 0; i < 3; i++)
    {
        int ent = EntRefToEntIndex(g_iPackPrevRef[client][i]);

        if (ent <= 0 || !IsValidEdict(ent) || !IsValidEntity(ent))
        {
            continue;
        }

        float pos[3];
        pos[0] = origin[0] + right[0] * offsets[i][0] + fwd[0] * offsets[i][1];
        pos[1] = origin[1] + right[1] * offsets[i][0] + fwd[1] * offsets[i][1];
        pos[2] = origin[2];

        float z;

        if (i == 0)
        {
            z = GetPreviewZOffset(m0);
        }
        else if (i == 1)
        {
            z = GetPreviewZOffset(m1);
        }
        else
        {
            z = GetPreviewZOffset(m2);
        }

        pos[2] += z;

        TeleportEntity(ent, pos, ang, NULL_VECTOR);
    }
}

static void GetClientPreviewBasis(int client, float origin[3], float ang[3], float fwd[3], float right[3])
{
    GetClientAbsOrigin(client, origin);

    GetClientEyeAngles(client, ang);
    ang[0] = 0.0;
    ang[2] = 0.0;

    GetAngleVectors(ang, fwd, right, NULL_VECTOR);

    origin[0] += fwd[0] * OFF_FWD;
    origin[1] += fwd[1] * OFF_FWD;
    origin[2] += OFF_UP;
}

static void UpdateSinglePreviewEnt(int ent, int client, const char[] model)
{
    float origin[3];
    float ang[3];
    float fwd[3];

    GetClientAbsOrigin(client, origin);

    GetClientEyeAngles(client, ang);
    ang[0] = 0.0;
    ang[2] = 0.0;

    GetAngleVectors(ang, fwd, NULL_VECTOR, NULL_VECTOR);

    origin[0] += fwd[0] * OFF_FWD;
    origin[1] += fwd[1] * OFF_FWD;
    origin[2] += OFF_UP;

    origin[2] += GetPreviewZOffset(model);

    TeleportEntity(ent, origin, ang, NULL_VECTOR);
}

static void SpawnQuadItem(int client, const char[] weaponClass)
{
    float origin[3];
    float ang[3];
    float fwd[3], right[3];

    GetClientPreviewBasis(client, origin, ang, fwd, right);

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
        pos[2]  = origin[2] + GetSpawnZOffset(weaponClass);

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

static float GetSpawnZOffset(const char[] cls)
{
    if (StrEqual(cls, ITEM_PILLS, false) || StrEqual(cls, ITEM_ADREN, false) || StrEqual(cls, ITEM_OXYGEN, false) || StrEqual(cls, ITEM_FIREWORKCRATE, false))
    {
        return Z_SMALL;
    }

    if (StrEqual(cls, ITEM_MOLOTOV, false) || StrEqual(cls, ITEM_PIPEBOMB, false) || StrEqual(cls, ITEM_BILE, false))
    {
        return Z_MED;
    }

    if (StrEqual(cls, ITEM_GASCAN, false) || StrEqual(cls, ITEM_PROPANE, false))
    {
        return Z_LARGE;
    }

    return Z_NONE;
}

static void SpawnTripleItems(int client, const char[] c0, const char[] c1, const char[] c2)
{
    float origin[3];
    float ang[3];
    float fwd[3], right[3];

    GetClientPreviewBasis(client, origin, ang, fwd, right);

    const float s             = 14.0;
    float       offsets[3][2] = {
        {-s,   -s},
        { s,   -s},
        { 0.0, s }
    };

    for (int i = 0; i < 3; i++)
    {
        char cls[64];

        if (i == 0)
        {
            strcopy(cls, sizeof(cls), c0);
        }
        else if (i == 1)
        {
            strcopy(cls, sizeof(cls), c1);
        }
        else
        {
            strcopy(cls, sizeof(cls), c2);
        }

        float pos[3];
        pos[0]  = origin[0] + right[0] * offsets[i][0] + fwd[0] * offsets[i][1];
        pos[1]  = origin[1] + right[1] * offsets[i][0] + fwd[1] * offsets[i][1];
        pos[2]  = origin[2] + GetSpawnZOffset(cls);

        int ent = CreateEntityByName(cls);

        if (ent <= 0)
        {
            continue;
        }

        DispatchSpawn(ent);
        ActivateEntity(ent);
        TeleportEntity(ent, pos, NULL_VECTOR, NULL_VECTOR);
    }
}

static void SpawnSingleItem(int client, const char[] weaponClass)
{
    float origin[3];
    float ang[3];
    float fwd[3];

    GetClientAbsOrigin(client, origin);

    GetClientEyeAngles(client, ang);
    ang[0] = 0.0;
    ang[2] = 0.0;

    GetAngleVectors(ang, fwd, NULL_VECTOR, NULL_VECTOR);

    origin[0] += fwd[0] * OFF_FWD;
    origin[1] += fwd[1] * OFF_FWD;
    origin[2] += OFF_UP;
    origin[2] += GetSpawnZOffset(weaponClass);

    int ent = CreateEntityByName(weaponClass);

    if (ent <= 0)
    {
        return;
    }

    DispatchSpawn(ent);
    ActivateEntity(ent);
    TeleportEntity(ent, origin, NULL_VECTOR, NULL_VECTOR);
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

static bool CanToggleNow(int client)
{
    float now = GetGameTime();

    if (now < g_fNextToggle[client])
    {
        return false;
    }

    g_fNextToggle[client] = now + 0.30;

    return true;
}

static bool CanUseNow(int client)
{
    float now = GetGameTime();

    if (now < g_fNextUse[client])
    {
        return false;
    }

    g_fNextUse[client] = now + 0.30;

    return true;
}

void PlaySound(int client, const char sound[32])
{
    EmitSoundToClient(client, sound, SOUND_FROM_PLAYER, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
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
        ResetClientState(client);

        return Plugin_Continue;
    }

    char wcls[64];
    GetEdictClassname(wep, wcls, sizeof(wcls));

    if (StrEqual(wcls, WEP_PACK_INC, false) || StrEqual(wcls, WEP_PACK_EXP, false))
    {
        return HandleUpgradePack(client, buttons, wcls);
    }

    if (StrEqual(wcls, WEP_MEDKIT, false))
    {
        return HandleMedkit(client, buttons);
    }

    if (StrEqual(wcls, WEP_DEFIB, false))
    {
        return HandleDefib(client, buttons);
    }

    ResetClientState(client);

    return Plugin_Continue;
}

static Action HandleUpgradePack(int client, int& buttons, const char[] wcls)
{
    // switching item -> reset other modes + previews
    ClearMedkitState(client);
    ClearDefibState(client);

    bool isInc = StrEqual(wcls, WEP_PACK_INC, false);

    if (buttons & IN_RELOAD)
    {
        if (CanToggleNow(client))
        {
            g_iPackMode[client] = (g_iPackMode[client] + 1) % 3;

            if (g_iCvarDebug >= 1)
            {
                PrintToChat(client, "[L4L] Pack mode: %d", g_iPackMode[client]);
            }

            if (g_iPackMode[client] != MODE3_ALT2)
            {
                DestroyPreview(client);
            }

            if (g_iPackMode[client] != MODE3_ALT1)
            {
                DestroyPackPreview(client);
            }

            PlaySound(client, SOUND_SWITCH_MODE_WEP);
            buttons &= ~IN_RELOAD;

            return Plugin_Changed;
        }
    }

    // Mode 0: native
    if (g_iPackMode[client] == MODE3_NATIVE)
    {
        DestroyPreview(client);
        DestroyPackPreview(client);

        return Plugin_Continue;
    }

    // Mode 1: triple items (block native use, spawn items, consume pack)
    if (g_iPackMode[client] == MODE3_ALT1)
    {
        DestroyPreview(client);

        char m0[128], m1[128], m2[128];
        GetPackTripleModels(isInc, m0, m1, m2);

        EnsurePackPreview(client, m0, m1, m2);
        UpdatePackPreview(client, m0, m1, m2);

        return Plugin_Continue;
    }

    DestroyPackPreview(client);

    char model[128];

    if (isInc)
    {
        strcopy(model, sizeof(model), MODEL_MINIGUN);
    }
    else
    {
        strcopy(model, sizeof(model), MODEL_50CAL);
    }

    EnsurePreview(client, model);

    int ent = GetSinglePreviewEnt(g_iPreviewRef[client]);

    if (ent > 0)
    {
        UpdateSinglePreviewEnt(ent, client, model);
    }

    return Plugin_Continue;
}

static Action HandleMedkit(int client, int& buttons)
{
    // switching item -> reset other modes + previews
    ClearPackState(client);
    ClearDefibState(client);

    if (buttons & IN_RELOAD)
    {
        if (CanToggleNow(client))
        {
            g_iMedkitMode[client] = (g_iMedkitMode[client] + 1) % 2;

            if (g_iCvarDebug >= 1)
            {
                PrintToChat(client, "[L4L] Pills mode: %s", (g_iMedkitMode[client] == MODE2_ALT1) ? "ON" : "OFF");
            }

            if (g_iMedkitMode[client] == MODE2_NATIVE)
            {
                DestroyPillsPreview(client);
            }

            PlaySound(client, SOUND_SWITCH_MODE_MED);
            buttons &= ~IN_RELOAD;

            return Plugin_Changed;
        }
    }

    if (g_iMedkitMode[client] == MODE2_NATIVE)
    {
        DestroyPillsPreview(client);

        return Plugin_Continue;    // native medkit
    }

    EnsurePillsPreview(client);
    UpdatePillsPreview(client);

    return TryUseQuadAlt_Pills(client, buttons);
}

static Action HandleDefib(int client, int& buttons)
{
    // switching item -> reset other modes + previews
    ClearPackState(client);
    ClearMedkitState(client);

    if (buttons & IN_RELOAD)
    {
        if (CanToggleNow(client))
        {
            g_iDefibMode[client] = (g_iDefibMode[client] + 1) % 3;

            if (g_iCvarDebug >= 1)
            {
                PrintToChat(client, "[L4L] Defib mode: %d", g_iDefibMode[client]);
            }

            if (g_iDefibMode[client] != MODE3_ALT1)
            {
                DestroyAdrenPreview(client);
            }

            if (g_iDefibMode[client] != MODE3_ALT2)
            {
                DestroyBilePreview(client);
            }

            PlaySound(client, SOUND_SWITCH_MODE_MED);
            buttons &= ~IN_RELOAD;

            return Plugin_Changed;
        }
    }

    // Mode 0: native
    if (g_iDefibMode[client] == MODE3_NATIVE)
    {
        DestroyAdrenPreview(client);
        DestroyBilePreview(client);

        return Plugin_Continue;    // native defib
    }

    // Mode 1: adrenaline quad
    if (g_iDefibMode[client] == MODE3_ALT1)
    {
        DestroyBilePreview(client);

        EnsureAdrenPreview(client);
        UpdateAdrenPreview(client);

        return TryUseQuadAlt_Adren(client, buttons);
    }

    // Mode 2: bile single
    DestroyAdrenPreview(client);

    EnsureBilePreview(client);

    int ent = GetSinglePreviewEnt(g_iBilePrevRef[client]);

    if (ent > 0)
    {
        UpdateSinglePreviewEnt(ent, client, MODEL_BILE);
    }

    return TryUseSingleAlt_Bile(client, buttons);
}

static float GetPreviewZOffset(const char[] model)
{
    if (StrContains(model, "minigun", false) != -1 || StrContains(model, "50cal", false) != -1)
    {
        return Z_NONE;
    }

    if (StrContains(model, "props_junk/explosive_box", false) != -1 || StrContains(model, "props_equipment/oxygentank", false) != -1 || StrContains(model, "w_eq_painpills", false) != -1 || StrContains(model, "w_eq_adrenaline", false) != -1)
    {
        return Z_SMALL;
    }

    if (StrContains(model, "props_junk/gascan", false) != -1 || StrContains(model, "props_junk/propanecanister", false) != -1)
    {
        return Z_LARGE;
    }

    if (StrContains(model, "w_eq_bile_flask", false) != -1 || StrContains(model, "w_eq_molotov", false) != -1 || StrContains(model, "w_eq_pipebomb", false) != -1)
    {
        return Z_MED;
    }

    return Z_NONE;
}

static void DestroySinglePreviewRef(int& ref)
{
    int ent = EntRefToEntIndex(ref);

    if (ent > 0 && IsValidEdict(ent) && IsValidEntity(ent))
    {
        RemoveEntity(ent);
    }

    ref = INVALID_ENT_REFERENCE;
}

static void EnsureSinglePreviewRef(int& ref, const char[] model)
{
    int ent = EntRefToEntIndex(ref);

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

    ref = EntIndexToEntRef(ent);
}

static int GetSinglePreviewEnt(int ref)
{
    int ent = EntRefToEntIndex(ref);

    if (ent > 0 && IsValidEdict(ent) && IsValidEntity(ent))
    {
        return ent;
    }

    return -1;
}

static void DestroyPreview(int client)
{
    DestroySinglePreviewRef(g_iPreviewRef[client]);
}

static void EnsurePreview(int client, const char[] model)
{
    EnsureSinglePreviewRef(g_iPreviewRef[client], model);
}

static void DestroyBilePreview(int client)
{
    DestroySinglePreviewRef(g_iBilePrevRef[client]);
}

static void EnsureBilePreview(int client)
{
    EnsureSinglePreviewRef(g_iBilePrevRef[client], MODEL_BILE);
}

static void GetPackTripleModels(bool isInc, char m0[128], char m1[128], char m2[128])
{
    if (isInc)
    {
        strcopy(m0, sizeof(m0), MODEL_MOLOTOV);
        strcopy(m1, sizeof(m1), MODEL_GASCAN);
        strcopy(m2, sizeof(m2), MODEL_FIREWORKCRATE);
    }
    else
    {
        strcopy(m0, sizeof(m0), MODEL_PIPEBOMB);
        strcopy(m1, sizeof(m1), MODEL_OXYGEN);
        strcopy(m2, sizeof(m2), MODEL_PROPANE);
    }
}

static void GetPackTripleItems(bool isInc, char c0[64], char c1[64], char c2[64], char expectedWep[64])
{
    if (isInc)
    {
        strcopy(c0, sizeof(c0), ITEM_MOLOTOV);
        strcopy(c1, sizeof(c1), ITEM_GASCAN);
        strcopy(c2, sizeof(c2), ITEM_FIREWORKCRATE);
        strcopy(expectedWep, sizeof(expectedWep), WEP_PACK_INC);
    }
    else
    {
        strcopy(c0, sizeof(c0), ITEM_PIPEBOMB);
        strcopy(c1, sizeof(c1), ITEM_OXYGEN);
        strcopy(c2, sizeof(c2), ITEM_PROPANE);
        strcopy(expectedWep, sizeof(expectedWep), WEP_PACK_EXP);
    }
}

static void ClearPackState(int client)
{
    g_iPackMode[client] = MODE3_NATIVE;
    DestroyPreview(client);
    DestroyPackPreview(client);
}

static void ClearMedkitState(int client)
{
    g_iMedkitMode[client] = MODE2_NATIVE;
    DestroyPillsPreview(client);
}

static void ClearDefibState(int client)
{
    g_iDefibMode[client] = MODE3_NATIVE;
    DestroyAdrenPreview(client);
    DestroyBilePreview(client);
}

static Action TryUseQuadAlt_Pills(int client, int& buttons)
{
    if (!(buttons & IN_ATTACK))
    {
        return Plugin_Continue;
    }

    if (CanUseNow(client))
    {
        SpawnQuadItem(client, ITEM_PILLS);
        ConsumeActiveIfClass(client, WEP_MEDKIT);

        g_iMedkitMode[client] = MODE2_NATIVE;
        DestroyPillsPreview(client);

        PlaySound(client, SOUND_USE_MODE_MED);
    }

    buttons &= ~IN_ATTACK;

    return Plugin_Changed;
}

static Action TryUseQuadAlt_Adren(int client, int& buttons)
{
    if (!(buttons & IN_ATTACK))
    {
        return Plugin_Continue;
    }

    if (CanUseNow(client))
    {
        SpawnQuadItem(client, ITEM_ADREN);
        ConsumeActiveIfClass(client, WEP_DEFIB);

        g_iDefibMode[client] = MODE3_NATIVE;
        DestroyAdrenPreview(client);

        PlaySound(client, SOUND_USE_MODE_MED);
    }

    buttons &= ~IN_ATTACK;

    return Plugin_Changed;
}

static Action TryUseSingleAlt_Bile(int client, int& buttons)
{
    if (!(buttons & IN_ATTACK))
    {
        return Plugin_Continue;
    }

    if (CanUseNow(client))
    {
        SpawnSingleItem(client, ITEM_BILE);
        ConsumeActiveIfClass(client, WEP_DEFIB);

        g_iDefibMode[client] = MODE3_NATIVE;
        DestroyBilePreview(client);

        PlaySound(client, SOUND_USE_MODE_MED);
    }

    buttons &= ~IN_ATTACK;

    return Plugin_Changed;
}