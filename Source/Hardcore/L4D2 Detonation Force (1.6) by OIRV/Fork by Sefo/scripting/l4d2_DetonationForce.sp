#pragma semicolon 1
#pragma newdecls required

#include <sdktools>

#define PLUGIN_VERSION  "1.6"
#define TEAM_SURVIVORS  2
#define TEAM_INFECTED   3
#define CVAR_FLAGS      FCVAR_NOTIFY

#define TRACE_TOLERANCE 25.0

ConVar l4d2_detonation_force_enable;
ConVar l4d2_detonation_scale_damage;
ConVar l4d2_grenade_detonation_force;
ConVar l4d2_pipe_detonation_force;
ConVar l4d2_barrel_detonation_force;
ConVar l4d2_bomb_detonation_force;
ConVar l4d2_detonation_force_immunity;
ConVar l4d2_detonation_force_ghost_mode;
ConVar l4d2_detonation_force_disable_gamemodes;

Handle sdkCallPushPlayer = null;

bool   EnablePlugin;

public Plugin myinfo =
{
    name        = "L4D2 Detonation Force",
    author      = "OIRV",
    description = "Explosions throws survivors and SI in the air",
    version     = PLUGIN_VERSION,
    url         = "https://forums.alliedmods.net/showthread.php?p=1759636"
};

public void OnPluginStart()
{
    /* Console vars */
    CreateConVar("l4d2_detonation_force_version", PLUGIN_VERSION, "L4D2 Detonation Force Version", CVAR_FLAGS | FCVAR_SPONLY | FCVAR_DONTRECORD);

    l4d2_detonation_force_enable            = CreateConVar("l4d2_detonation_force_enable", "0", "Enable/Disable plugin", CVAR_FLAGS);
    l4d2_bomb_detonation_force              = CreateConVar("l4d2_bomb_detonation_force", "250", "Sets bomb explosion power", CVAR_FLAGS);
    l4d2_pipe_detonation_force              = CreateConVar("l4d2_pipe_detonation_force", "300", "Sets pipe bomb explosion power", CVAR_FLAGS);
    l4d2_barrel_detonation_force            = CreateConVar("l4d2_barrel_detonation_force", "250", "Sets fuel barrel explosion power", CVAR_FLAGS);
    l4d2_grenade_detonation_force           = CreateConVar("l4d2_grenade_detonation_force", "50", "Sets grenade launcher explosion power", CVAR_FLAGS);
    l4d2_detonation_scale_damage            = CreateConVar("l4d2_detonation_scale_damage", "0.0", "% force as damage", CVAR_FLAGS);
    l4d2_detonation_force_immunity          = CreateConVar("l4d2_detonation_force_immunity", "1", "Entity immune to the explosion: 0 nobody, 1 survivors, 2 infected", CVAR_FLAGS);
    l4d2_detonation_force_ghost_mode        = CreateConVar("l4d2_detonation_force_ghost_mode", "0", "Enable/Disable knock back in infected ghost", CVAR_FLAGS);
    l4d2_detonation_force_disable_gamemodes = CreateConVar("l4d2_detonation_force_disable_gamemodes", "empty", "Disable plugin in selected game modes", CVAR_FLAGS);

    l4d2_detonation_force_disable_gamemodes.AddChangeHook(VarGameModesChange);
    l4d2_detonation_force_enable.AddChangeHook(VarEnableChange);

    AutoExecConfig(true, "l4d2_detonation_force");

    /* L4D2 only: load gamedata + prepare SDKCall */
    GameData GameConf = new GameData("l4d2_detonationforce");
    if (GameConf == null)
    {
        SetFailState("Couldn't find the offsets and signatures file. Please, check that it is installed correctly.");
    }

    StartPrepSDKCall(SDKCall_Player);
    PrepSDKCall_SetFromConf(GameConf, SDKConf_Signature, "CTerrorPlayer_Fling");
    PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_ByRef);
    PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
    PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer);    // IMPORTANT: restores proper fling behavior
    PrepSDKCall_AddParameter(SDKType_Float, SDKPass_Plain);
    sdkCallPushPlayer = EndPrepSDKCall();

    if (sdkCallPushPlayer == null)
    {
        SetFailState("Unable to find the 'CTerrorPlayer_Fling' signature, check the file version!");
    }

    delete GameConf;
}

public void OnMapStart()
{
    LoadGameModes();
}

void VarGameModesChange(ConVar convar, const char[] oldValue, const char[] newValue)
{
    LoadGameModes();
}

void VarEnableChange(ConVar convar, const char[] oldValue, const char[] newValue)
{
    LoadGameModes();
}

void LoadGameModes()
{
    /* master enable */
    if (!l4d2_detonation_force_enable.BoolValue)
    {
        EnablePlugin = false;
        return;
    }

    /*Get current game mode*/
    ConVar      gamemode = FindConVar("mp_gamemode");
    static char currentGameMode[64];
    gamemode.GetString(currentGameMode, sizeof(currentGameMode));

    /* Split the string with the game modes to disable */
    static char gamemodes[32][32];
    static char buffer[512];
    l4d2_detonation_force_disable_gamemodes.GetString(buffer, sizeof(buffer));
    ExplodeString(buffer, ",", gamemodes, sizeof gamemodes, sizeof gamemodes[]);

    /* if the string contains "*" */
    if (StrEqual(buffer, "*", false))
    {
        EnablePlugin = false;
        return;
    }

    EnablePlugin = true;

    for (int i = 0; i < 32; i++)
    {
        if (StrEqual(currentGameMode, gamemodes[i], false))
        {
            EnablePlugin = false;
            break;
        }
    }
}

public void OnEntityDestroyed(int entity)
{
    if (!EnablePlugin || entity <= 0 || !IsValidEntity(entity) || !IsValidEdict(entity))
        return;

    char EntityName[128];
    if (!GetEdictClassname(entity, EntityName, sizeof(EntityName)))
        return;

    /* checks if the entity is an explosive */
    if (StrEqual(EntityName, "prop_fuel_barrel", false) || StrEqual(EntityName, "pipe_bomb_projectile", false) || StrEqual(EntityName, "grenade_launcher_projectile", false))
    {
        float force;

        if (StrEqual(EntityName, "grenade_launcher_projectile", false))
        {
            force = l4d2_grenade_detonation_force.FloatValue;
        }
        else if (StrEqual(EntityName, "prop_fuel_barrel", false))
        {
            force = l4d2_barrel_detonation_force.FloatValue;
        }
        else
        {
            if (GetEntityFlags(entity) == 1)
            {
                force = l4d2_pipe_detonation_force.FloatValue;
            }
            else
            {
                force = l4d2_bomb_detonation_force.FloatValue;
            }
        }

        for (int client = 1; client <= MaxClients; client++)
        {
            Fly(entity, client, force);
        }
    }
}

void Fly(int explosion, int target, float power)
{
    if (target <= 0 || !IsValidEntity(target) || !IsValidEdict(target))
        return;

    if (GetEntData(target, FindSendPropInfo("CTerrorPlayer", "m_isGhost"), 1) == 1)
    {
        if (!l4d2_detonation_force_ghost_mode.BoolValue)
            return;
    }

    float targetPos[3];
    float explosionPos[3];
    float traceVec[3];
    float resultingFling[3];

    GetEntPropVector(target, Prop_Data, "m_vecOrigin", targetPos);
    GetEntPropVector(explosion, Prop_Data, "m_vecOrigin", explosionPos);

    power = power - GetVectorDistance(targetPos, explosionPos);

    if (power < 1.0)
        return;

    MakeVectorFromPoints(explosionPos, targetPos, traceVec);
    if (!IsVisibleTo(explosionPos, targetPos))
        return;

    GetVectorAngles(traceVec, resultingFling);

    resultingFling[0] = Cosine(DegToRad(resultingFling[1])) * power;
    resultingFling[1] = Sine(DegToRad(resultingFling[1])) * power;
    resultingFling[2] = power + (power * 0.5);

    /* L4D2 only */
    if (GetClientTeam(target) == TEAM_SURVIVORS)
    {
        if (l4d2_detonation_force_immunity.IntValue == 0 || l4d2_detonation_force_immunity.IntValue + 1 == TEAM_INFECTED)
        {
            DamageEffect(target, RoundToNearest(power * l4d2_detonation_scale_damage.FloatValue));
            SDKCall(sdkCallPushPlayer, target, resultingFling, 76, target, 2.0);
        }
    }
    else if (GetClientTeam(target) == TEAM_INFECTED)
    {
        if (l4d2_detonation_force_immunity.IntValue == 0 || l4d2_detonation_force_immunity.IntValue + 1 == TEAM_SURVIVORS)
        {
            DamageEffect(target, RoundToNearest(power * l4d2_detonation_scale_damage.FloatValue));
            SDKCall(sdkCallPushPlayer, target, resultingFling, 2, target, 2.0);
        }
    }
}

public void DamageEffect(int target, int damage)
{
    char sDamage[12];
    IntToString(damage, sDamage, sizeof(sDamage));

    int pointHurt = CreateEntityByName("point_hurt");
    DispatchKeyValue(target, "targetname", "hurtme");
    DispatchKeyValue(pointHurt, "Damage", sDamage);
    DispatchKeyValue(pointHurt, "DamageTarget", "hurtme");
    DispatchKeyValue(pointHurt, "DamageType", "65536");
    DispatchSpawn(pointHurt);
    AcceptEntityInput(pointHurt, "Hurt");
    AcceptEntityInput(pointHurt, "Kill");
    DispatchKeyValue(target, "targetname", "cake");
}

static bool IsVisibleTo(float position[3], float targetposition[3])
{
    float vAngles[3], vLookAt[3];

    MakeVectorFromPoints(position, targetposition, vLookAt);
    GetVectorAngles(vLookAt, vAngles);

    Handle trace     = TR_TraceRayFilterEx(position, vAngles, MASK_SHOT, RayType_Infinite, _TraceFilter);

    bool   isVisible = false;
    if (TR_DidHit(trace))
    {
        float vStart[3];
        TR_GetEndPosition(vStart, trace);

        if ((GetVectorDistance(position, vStart, false) + TRACE_TOLERANCE) >= GetVectorDistance(position, targetposition))
        {
            isVisible = true;
        }
    }
    else
    {
        LogError("Tracer Bug: Player-Zombie Trace did not hit anything, WTF");
        isVisible = true;
    }

    delete trace;
    return isVisible;
}

bool _TraceFilter(int entity, int contentsMask)
{
    return entity > 0 && entity <= 2048 && IsValidEntity(entity) && IsValidEdict(entity);
}