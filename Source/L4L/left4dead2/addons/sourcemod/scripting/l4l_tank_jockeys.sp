#pragma semicolon 1
#pragma newdecls required

#include <l4l/utils>
#include <l4l/lifecycle>
#include <left4dhooks>

#define PLUGIN_VERSION "0.0.1"
#define MODEL_JOCKEY   "models/infected/jockey.mdl"

ConVar g_hCvarEnable, g_hCvarDebug;
int    g_iCvarDebug;
int    g_iJockeyPropLeft[MAXPLAYERS + 1];
int    g_iJockeyPropRight[MAXPLAYERS + 1];

public Plugin myinfo =
{
    name    = "L4L: Tank Jockeys",
    author  = "Sefo",
    version = PLUGIN_VERSION,
    url     = "Sefo.su"
};

public void OnPluginStart()
{
    CreateConVar("l4l_tank_jockeys_version", PLUGIN_VERSION, "L4L: Tank Jockeys version", CVAR_FLAGS | FCVAR_DONTRECORD);
    g_hCvarEnable = CreateConVar("l4l_tank_jockeys_enable", "0", "0 = Plugin off, 1 = Plugin on", CVAR_FLAGS, true, float(DISABLE), true, float(ENABLE));
    g_hCvarDebug  = CreateConVar("l4l_tank_jockeys_debug", "0", "0 = Debug off, 1 = Debug on, 2 = Debug events, 3 = Debug sounds", CVAR_FLAGS, true, float(DISABLE), true, float(DEBUG_SOUNDS));

    CreateDirectory("cfg/sourcemod/l4l_plugins", 511, true);
    AutoExecConfig(true, "l4l_tank_jockeys", "sourcemod/l4l_plugins");

    g_hCvarEnable.AddChangeHook(CvarChanged_Enable);
    g_hCvarDebug.AddChangeHook(CvarChanged_Cvars);
}

public void OnMapStart()
{
    PrecacheModel(MODEL_JOCKEY, true);
}

public void OnClientDisconnect(int client)
{
    if (client > 0 && client <= MaxClients)
    {
        RemoveJockeyProps(client);
    }
}

public void OnConfigsExecuted()
{
    L4L_LC_OnConfigsExecuted(g_hCvarEnable.BoolValue);

    for (int i = 1; i <= MaxClients; i++)
    {
        if (IsClient(i) && IsClientInGame(i) && IsInfected(i) && IsTank(i) && IsPlayerAlive(i))
        {
            AttachJockeyProps(i);
        }
    }
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
    HookEvent(EVENT_PLAYER_DEATH, Event_TankDeath);
    HookEvent("player_spawn", Event_PlayerSpawn);
}

void L4L_Unhook()
{
    UnhookEvent(EVENT_PLAYER_DEATH, Event_TankDeath);
    UnhookEvent("player_spawn", Event_PlayerSpawn);

    for (int i = 1; i <= MaxClients; i++)
    {
        RemoveJockeyProps(i);
    }
}

void Event_PlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
    int client = GetEventClient(event);

    if (!g_hCvarEnable.BoolValue)
    {
        return;
    }

    if (!IsClient(client) || !IsInfected(client) || !IsTank(client))
    {
        return;
    }

    if (!IsPlayerAlive(client))
    {
        return;
    }

    AttachJockeyProps(client);
}

void AttachJockeyProps(int tank)
{
    if (g_iJockeyPropLeft[tank] || g_iJockeyPropRight[tank])
    {
        return;
    }

    int leftEnt  = CreateJockeyProp(tank, true);
    int rightEnt = CreateJockeyProp(tank, false);

    if (leftEnt <= 0 || rightEnt <= 0)
    {
        if (leftEnt > 0)
        {
            int tmp = leftEnt;

            KillEntSafe(tmp);
        }

        if (rightEnt > 0)
        {
            int tmp = rightEnt;

            KillEntSafe(tmp);
        }

        return;
    }

    g_iJockeyPropLeft[tank]  = leftEnt;
    g_iJockeyPropRight[tank] = rightEnt;

    if (g_iCvarDebug)
    {
        PrintToChatAll("%s Tank %N got jockey props", DEBUG_TAG, tank);
    }
}

int CreateJockeyProp(int tank, bool left)
{
    int ent = CreateEntityByName("prop_dynamic_override");

    if (ent == -1)
    {
        return 0;
    }

    DispatchKeyValue(ent, "model", MODEL_JOCKEY);
    DispatchSpawn(ent);

    char target[64];
    EnsureTankTargetname(tank, target, sizeof(target));
    if (target[0] == '\0')
    {
        AcceptEntityInput(ent, "Kill");
        return 0;
    }

    SetVariantString(target);
    AcceptEntityInput(ent, "SetParent");

    SetVariantString(left ? "lshoulder" : "rshoulder");
    AcceptEntityInput(ent, "SetParentAttachment");

    // lshoulder position:
    const float LEFT_X      = 15.0;     // -UP/+DOWN
    const float LEFT_Y      = -10.0;    // -LEFT/+RIGHT
    const float LEFT_Z      = -15.0;    // -BACK/+FORWARD

    // lshoulder angles:
    const float LEFT_PITCH  = -90.0;    // From horizontal to vertical
    const float LEFT_YAW    = 0.0;
    const float LEFT_ROLL   = -25.0;    // Tilt +LEFT/-RIGHT

    // rshoulder position:
    const float RIGHT_X     = 15.0;     // -UP/+DOWN
    const float RIGHT_Y     = -10.0;    // -RIGHT/+LEFT
    const float RIGHT_Z     = 15.0;     // -FORWARD/+BACK

    // rshoulder angles:
    const float RIGHT_PITCH = 90.0;     // From horizontal to vertical
    const float RIGHT_YAW   = 180.0;    // From front to back
    const float RIGHT_ROLL  = 25.0;     // Tilt +LEFT/-RIGHT

    float       x           = left ? LEFT_X : RIGHT_X;
    float       y           = left ? LEFT_Y : RIGHT_Y;
    float       z           = left ? LEFT_Z : RIGHT_Z;

    float       pitch       = left ? LEFT_PITCH : RIGHT_PITCH;
    float       yaw         = left ? LEFT_YAW : RIGHT_YAW;
    float       roll        = left ? LEFT_ROLL : RIGHT_ROLL;

    float       localPos[3];
    localPos[0] = x;
    localPos[1] = y;
    localPos[2] = z;

    float localAng[3];
    localAng[0] = pitch;
    localAng[1] = yaw;
    localAng[2] = roll;

    TeleportEntity(ent, localPos, localAng, NULL_VECTOR);
    SetEntProp(ent, Prop_Send, "m_CollisionGroup", 2);
    SetEntityMoveType(ent, MOVETYPE_NONE);

    return ent;
}

void Event_TankDeath(Event event, const char[] name, bool dontBroadcast)
{
    if (!g_hCvarEnable.BoolValue)
    {
        return;
    }

    int client = GetEventClient(event);

    if (!IsClient(client) || !IsInfected(client) || !IsTank(client))
    {
        return;
    }

    float pos[3];
    GetClientAbsOrigin(client, pos);

    RemoveJockeyProps(client);
    SpawnJockeys(pos);

    if (g_iCvarDebug)
    {
        PrintToChatAll("%s Event_TankDeath %N", DEBUG_TAG, client);
    }
}

void SpawnJockeys(const float pos[3])
{
    float ang[3] = { 0.0, 0.0, 0.0 };

    L4D2_SpawnSpecial(L4D2ZombieClass_Jockey, pos, ang);
    L4D2_SpawnSpecial(L4D2ZombieClass_Jockey, pos, ang);
}

void KillEntSafe(int &ent)
{
    if (ent > 0 && IsValidEntity(ent))
    {
        AcceptEntityInput(ent, "Kill");
    }

    ent = 0;
}

void RemoveJockeyProps(int tank)
{
    KillEntSafe(g_iJockeyPropLeft[tank]);
    KillEntSafe(g_iJockeyPropRight[tank]);
}

void EnsureTankTargetname(int tank, char[] out, int outLen)
{
    if (tank <= 0 || tank > MaxClients || !IsValidEntity(tank))
    {
        out[0] = '\0';

        return;
    }

    char cur[64];
    GetEntPropString(tank, Prop_Data, "m_iName", cur, sizeof(cur));

    if (cur[0] != '\0')
    {
        strcopy(out, outLen, cur);

        return;
    }

    Format(out, outLen, "l4l_tank_%d", tank);
    DispatchKeyValue(tank, "targetname", out);
}