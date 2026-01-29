#pragma semicolon 1
#pragma newdecls required

#include <l4l/utils>
#include <l4l/lifecycle>
#include <left4dhooks>

#define PLUGIN_VERSION    "0.0.1"
#define LOOTBOX_MODEL     "models/props_collectables/backpack.mdl"
#define LOOTBOX_SOUND     "Items/ItemPickup.wav"
#define LOOTBOX_MASS      "10"
#define LOOTBOX_TAG_TANK  "l4l_lootbox_tank"
#define LOOTBOX_TAG_WITCH "l4l_lootbox_witch"

ConVar g_hCvarEnable, g_hCvarDebug, g_hCvarTankLoot, g_hCvarLootMed, g_hCvarLootSight, g_hCvarLootAdren, g_hCvarWitchLoot, g_hCvarLootDefib, g_hCvarLootJar;
int    g_iCvarDebug, g_iCvarLootMed, g_iCvarLootSight, g_iCvarLootAdren, g_iCvarLootDefib, g_iCvarLootJar;
bool   g_bCvarTankLoot, g_bCvarWitchLoot;

public Plugin myinfo =
{
    name    = "L4L: Infected Drop Loot",
    author  = "Sefo",
    version = PLUGIN_VERSION,
    url     = "Sefo.su"
};

public void OnPluginStart()
{
    CreateConVar("l4l_infected_drop_loot_version", PLUGIN_VERSION, "L4L: Infected Drop Loot version", CVAR_FLAGS | FCVAR_DONTRECORD);
    g_hCvarEnable    = CreateConVar("l4l_infected_drop_loot_enable", "0", "0 = Plugin off, 1 = Plugin on", CVAR_FLAGS, true, float(DISABLE), true, float(ENABLE));
    g_hCvarDebug     = CreateConVar("l4l_infected_drop_loot_debug", "0", "0 = Debug off, 1 = Debug on, 2 = Debug events, 3 = Debug sounds", CVAR_FLAGS, true, float(DISABLE), true, float(DEBUG_SOUNDS));
    g_hCvarTankLoot  = CreateConVar("l4l_infected_drop_loot_tank", "1", "0 = Off, 1 = Killed tank drops loot", CVAR_FLAGS, true, float(DISABLE), true, float(ENABLE));
    g_hCvarLootMed   = CreateConVar("l4l_infected_drop_loot_med", "100", "0 = Off, Medical chance", CVAR_FLAGS, true, float(DISABLE), true, float(MAX_CHANCE));
    g_hCvarLootSight = CreateConVar("l4l_infected_drop_loot_sight", "50", "0 = Off, Laser sight chance", CVAR_FLAGS, true, float(DISABLE), true, float(MAX_CHANCE));
    g_hCvarLootAdren = CreateConVar("l4l_infected_drop_loot_adren", "70", "0 = Off, Adrenaline chance", CVAR_FLAGS, true, float(DISABLE), true, float(MAX_CHANCE));
    g_hCvarWitchLoot = CreateConVar("l4l_infected_drop_loot_witch", "1", "0 = Off, 1 = Killed witch drops loot", CVAR_FLAGS, true, float(DISABLE), true, float(ENABLE));
    g_hCvarLootDefib = CreateConVar("l4l_infected_drop_loot_defib", "100", "0 = Off, Defibrillator chance", CVAR_FLAGS, true, float(DISABLE), true, float(MAX_CHANCE));
    g_hCvarLootJar   = CreateConVar("l4l_infected_drop_loot_jar", "50", "0 = Off, Vomit jar chance", CVAR_FLAGS, true, float(DISABLE), true, float(MAX_CHANCE));

    CreateDirectory("cfg/sourcemod/l4l_plugins", 511, true);
    AutoExecConfig(true, "l4l_infected_drop_loot", "sourcemod/l4l_plugins");

    g_hCvarEnable.AddChangeHook(CvarChanged_Enable);
    g_hCvarDebug.AddChangeHook(CvarChanged_Cvars);
    g_hCvarTankLoot.AddChangeHook(CvarChanged_Cvars);
    g_hCvarLootMed.AddChangeHook(CvarChanged_Cvars);
    g_hCvarLootSight.AddChangeHook(CvarChanged_Cvars);
    g_hCvarLootAdren.AddChangeHook(CvarChanged_Cvars);
    g_hCvarWitchLoot.AddChangeHook(CvarChanged_Cvars);
    g_hCvarLootDefib.AddChangeHook(CvarChanged_Cvars);
    g_hCvarLootJar.AddChangeHook(CvarChanged_Cvars);
}

public void OnMapStart()
{
    PrecacheModel(LOOTBOX_MODEL, true);
    PrecacheSound(LOOTBOX_SOUND, true);
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
    g_iCvarDebug     = g_hCvarDebug.IntValue;
    g_iCvarLootMed   = g_hCvarLootMed.IntValue;
    g_iCvarLootSight = g_hCvarLootSight.IntValue;
    g_iCvarLootAdren = g_hCvarLootAdren.IntValue;
    g_iCvarLootDefib = g_hCvarLootDefib.IntValue;
    g_iCvarLootJar   = g_hCvarLootJar.IntValue;
    g_bCvarTankLoot  = g_hCvarTankLoot.BoolValue;
    g_bCvarWitchLoot = g_hCvarWitchLoot.BoolValue;
}

void L4L_Hook()
{
    HookEvent(EVENT_PLAYER_DEATH, Event_TankDeath);
    HookEvent(EVENT_WITCH_KILLED, Event_WitchDeath);
}

void L4L_Unhook()
{
    UnhookEvent(EVENT_PLAYER_DEATH, Event_TankDeath);
    UnhookEvent(EVENT_WITCH_KILLED, Event_WitchDeath);
}

void Event_TankDeath(Event event, const char[] name, bool dontBroadcast)
{
    if (!g_bCvarTankLoot) return;

    int client = GetEventClient(event);

    if (!IsClient(client) || !IsInfected(client) || !IsTank(client)) return;

    int attacker = GetEventAttacker(event);

    if (g_iCvarDebug) PrintToChatAll("%s Event_TankDeath \x04%s \x05%s \x03%s", DEBUG_TAG, GetName(client), name, GetName(attacker));

    if (IsClientAttacker(client, attacker) || !IsClientConnected(client) || !IsClientInGame(client)) return;

    float origin[AXES_XYZ];
    GetEntPropVector(client, PROP_SEND, VECTOR_ORIGIN, origin);
    SpawnLootBox(origin, LOOTBOX_TAG_TANK);
}

void Event_WitchDeath(Event event, const char[] name, bool dontBroadcast)
{
    if (!g_bCvarWitchLoot) return;

    int client = event.GetInt("witchid");

    if (!IsValidEntity(client))
        return;

    if (g_iCvarDebug) PrintToChatAll("%s Event_WitchDeath \x04%d \x05%s", DEBUG_TAG, client, name);

    float origin[AXES_XYZ];
    GetEntPropVector(client, PROP_SEND, VECTOR_ORIGIN, origin);
    SpawnLootBox(origin, LOOTBOX_TAG_WITCH);
}

int CreateEntity(const char[] name, const float origin[AXES_XYZ], int ammo = DISABLE)
{
    int entity = CreateEntityByName(name);

    if (entity == ENTITY_CREATION_FAILED) return ENTITY_CREATION_FAILED;

    DispatchKeyValueVector(entity, ENTITY_ORIGIN, origin);
    DispatchSpawn(entity);

    if (ammo) SetEntProp(entity, PROP_SEND, "m_iExtraPrimaryAmmo", ammo);

    if (g_iCvarDebug) PrintToChatAll("%s CreateEntity \x04%s \x05%d \x03%d", DEBUG_TAG, name, entity, ammo);

    return entity;
}

int CreateSight(const float origin[AXES_XYZ])
{
    int entity = CreateEntityByName("upgrade_spawn");

    if (entity == ENTITY_CREATION_FAILED) return ENTITY_CREATION_FAILED;

    DispatchKeyValueVector(entity, ENTITY_ORIGIN, origin);
    DispatchKeyValue(entity, "spawnflags", ENTITY_MUST_EXIST);
    DispatchKeyValue(entity, "laser_sight", ENTITY_ENABLE);
    DispatchKeyValue(entity, "upgradepack_incendiary", ENTITY_DISABLE);
    DispatchKeyValue(entity, "upgradepack_explosive", ENTITY_DISABLE);
    DispatchSpawn(entity);

    if (g_iCvarDebug) PrintToChatAll("%s CreateSight \x04%d", DEBUG_TAG, entity);

    return entity;
}

void GetRandomOffset(const float origin[AXES_XYZ], float offset[AXES_XYZ])
{
    offset[AXIS_X] = origin[AXIS_X] + GetRandomFloat(-ENTITY_OFFSET, ENTITY_OFFSET);
    offset[AXIS_Y] = origin[AXIS_Y] + GetRandomFloat(-ENTITY_OFFSET, ENTITY_OFFSET);
    offset[AXIS_Z] = origin[AXIS_Z] + GetRandomFloat(ENTITY_OFFSET_Z_MIN, ENTITY_OFFSET);
}

bool GetGroundPos(const float vector[AXES_XYZ], float ground[AXES_XYZ])
{
    Handle trace = TR_TraceRayFilterEx(vector, view_as<float>({ ANGLE_UP, ANGLE_HORIZONTAL, ANGLE_HORIZONTAL }), CONTENTS_SOLID, RayType_Infinite, TR_FilterWorld);

    if (TR_DidHit(trace))
    {
        TR_GetEndPosition(ground, trace);
        trace.Close();

        return true;
    }

    trace.Close();

    return false;
}

bool TR_FilterWorld(int entity, int mask)
{
    return entity == ENTITY_WORLD;
}

int SpawnLootBox(const float origin[AXES_XYZ], const char[] targetname)
{
    int box = CreateEntityByName("prop_physics_override");

    if (box == ENTITY_CREATION_FAILED)
        return ENTITY_CREATION_FAILED;

    DispatchKeyValue(box, "model", LOOTBOX_MODEL);
    DispatchKeyValue(box, "targetname", targetname);
    DispatchKeyValue(box, "massScale", LOOTBOX_MASS);

    // Glow
    DispatchKeyValue(box, "glowstate", "3");
    DispatchKeyValue(box, "glowcolor", "195 195 0");
    DispatchKeyValue(box, "glowrange", "600");

    // To floor
    float pos[AXES_XYZ];
    pos[AXIS_X] = origin[AXIS_X];
    pos[AXIS_Y] = origin[AXIS_Y];
    pos[AXIS_Z] = origin[AXIS_Z] + 30.0;

    float ground[AXES_XYZ];

    if (GetGroundPos(pos, ground))
        pos[AXIS_Z] = ground[AXIS_Z] + 30.0;

    // Random angle
    float ang[3];
    ang[0] = 0.0;
    ang[1] = GetRandomFloat(0.0, 359.0);
    ang[2] = 0.0;

    TeleportEntity(box, pos, ang, NULL_VECTOR);
    DispatchSpawn(box);
    ActivateEntity(box);
    SDKHook(box, SDKHook_Use, LootBox_OnUse);

    if (g_iCvarDebug)
    {
        float p[AXES_XYZ];
        GetEntPropVector(box, Prop_Data, VECTOR_ORIGIN, p);
        PrintToChatAll("%s SpawnLootBox %s -> ent=%d pos=%.1f %.1f %.1f",
                       DEBUG_TAG, targetname, box, p[0], p[1], p[2]);
    }

    return box;
}

Action LootBox_OnUse(int box, int caller, int activator, UseType type, float value)
{
    if (!IsClient(activator) || !IsClientInGame(activator))
        return Plugin_Continue;

    char name[64];
    GetEntPropString(box, Prop_Data, "m_iName", name, sizeof(name));

    if (StrEqual(name, LOOTBOX_TAG_TANK))
    {
        OpenTankLootBox(box);
    }
    else if (StrEqual(name, LOOTBOX_TAG_WITCH))
    {
        OpenWitchLootBox(box);
    }
    else
    {
        return Plugin_Continue;
    }

    float vPos[AXES_XYZ];
    GetEntPropVector(box, PROP_SEND, VECTOR_ORIGIN, vPos);
    EmitAmbientSound(LOOTBOX_SOUND, vPos, SOUND_FROM_WORLD, SNDLEVEL_GUNFIRE, SND_NOFLAGS, SNDATTN_IDLE);

    RemoveEntity(box);

    return Plugin_Handled;
}

void DropLoot(const float origin[AXES_XYZ], int entity)
{
    if (!entity) return;

    float offset[AXES_XYZ];
    GetRandomOffset(origin, offset);

    if (g_iCvarDebug) PrintToChatAll("%s DropLoot \x04%d", DEBUG_TAG, entity);

    switch (entity)
    {
        case ENTITY_MEDKIT: CreateEntity("weapon_first_aid_kit", offset);
        case ENTITY_DEFIB: CreateEntity("weapon_defibrillator", offset);
        case ENTITY_ADREN: CreateEntity("weapon_adrenaline", offset);
        case ENTITY_JAR: CreateEntity("weapon_vomitjar", offset);
        case ENTITY_UPGRADE_INCENDIARY: CreateEntity("weapon_upgradepack_incendiary", offset);
        case ENTITY_UPGRADE_EXPLOSIVE: CreateEntity("weapon_upgradepack_explosive", offset);
        case ENTITY_SIGHT:
            if (GetGroundPos(offset, offset)) CreateSight(offset);
    }
}

void OpenTankLootBox(int box)
{
    float origin[AXES_XYZ];
    GetEntPropVector(box, PROP_SEND, VECTOR_ORIGIN, origin);

    if (IsLucky(g_iCvarLootMed))
        DropLoot(origin, GetRandomInt(0, 1) ? ENTITY_MEDKIT : ENTITY_DEFIB);

    if (IsLucky(g_iCvarLootSight))
    {
        int roll = GetRandomInt(0, 2);

        switch (roll)
        {
            case 0: DropLoot(origin, ENTITY_SIGHT);
            case 1: DropLoot(origin, ENTITY_UPGRADE_INCENDIARY);
            case 2: DropLoot(origin, ENTITY_UPGRADE_EXPLOSIVE);
        }
    }
}

void OpenWitchLootBox(int box)
{
    float origin[AXES_XYZ];
    GetEntPropVector(box, PROP_SEND, VECTOR_ORIGIN, origin);

    if (IsLucky(g_iCvarLootDefib)) DropLoot(origin, ENTITY_DEFIB);
    if (IsLucky(g_iCvarLootJar)) DropLoot(origin, ENTITY_JAR);
    if (IsLucky(g_iCvarLootAdren)) DropLoot(origin, ENTITY_ADREN);
}