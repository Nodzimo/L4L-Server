#pragma semicolon 1
#pragma newdecls required

#include <l4l/utils>
#include <l4l/lifecycle>
#include <sdktools>

#define PLUGIN_VERSION      "0.0.1"
#define ABILITY_DURATION    10.0
#define GLOBAL_COOLDOWN     60.0
#define SLOT_PILLS          4
#define GLOW_COLOR          38655    // Glow Mode color: GetColor("255 150 0");

// Sounds
// #define SOUND_ABILITY_DENY  "Buttons/Button11.wav"
#define SOUND_ABILITY_END   "UI/Menu_Horror01.wav"
#define SOUND_ABILITY_PILLS "Player/Laser_On.wav"
#define SOUND_ABILITY_ADREN "Plats/ChurchBell_End.wav"

ConVar g_hCvarEnable, g_hCvarDebug, cTimescale, cTriggerSilence, cTriggerSilenceFading;
int    g_iCvarDebug;
float  flTimescale, flTriggerSilence, flTriggerSilenceFading;
Handle zeding;

Handle g_hTmrAbility       = null;
Handle g_hTmrCooldown      = null;
Handle g_hTmrGlowScan      = null;
float  g_flCooldownEndTime = 0.0;
bool   g_bAbilityActive    = false;
bool   g_bCooldownActive   = false;

enum AbilityItemType
{
    Ability_None = 0,
    Ability_Pills,
    Ability_Adrenaline
};

public Plugin myinfo =
{
    name    = "L4L: Survivor Abilities",
    author  = "Sefo",
    version = PLUGIN_VERSION,
    url     = "Sefo.su"
};

public void OnPluginStart()
{
    LoadTranslations("l4l_survivor_abilities.phrases");

    CreateConVar("l4l_survivor_abilities_version", PLUGIN_VERSION, "L4L: Survivor Abilities version", CVAR_FLAGS | FCVAR_DONTRECORD);
    g_hCvarEnable         = CreateConVar("l4l_survivor_abilities_enable", "0", "0 = Plugin off, 1 = Plugin on", CVAR_FLAGS, true, float(DISABLE), true, float(ENABLE));
    g_hCvarDebug          = CreateConVar("l4l_survivor_abilities_debug", "0", "0 = Debug off, 1 = Debug on, 2 = Debug events, 3 = Debug sounds", CVAR_FLAGS, true, float(DISABLE), true, float(DEBUG_SOUNDS));
    cTimescale            = CreateConVar("l4l_survivor_abilities_timescale", "0.5", "zed time scale of game time", FCVAR_NOTIFY, true, 0.1, true, 1.0);
    cTriggerSilence       = CreateConVar("l4l_survivor_abilities_trigger_silence", "50", "percent of silence volume, 0: do not silence, 100: completely silence", FCVAR_NOTIFY, true, 0.0, true, 100.0);
    cTriggerSilenceFading = CreateConVar("l4l_survivor_abilities_trigger_silence_fading", "0.2", "silence fading time, 0: instantly silence", FCVAR_NOTIFY, true, 0.0);

    CreateDirectory("cfg/sourcemod/l4l_plugins", 511, true);
    AutoExecConfig(true, "l4l_survivor_abilities", "sourcemod/l4l_plugins");

    g_hCvarEnable.AddChangeHook(CvarChanged_Enable);
    g_hCvarDebug.AddChangeHook(CvarChanged_Cvars);
    cTimescale.AddChangeHook(CvarChanged_Cvars);
    cTriggerSilence.AddChangeHook(CvarChanged_Cvars);
    cTriggerSilenceFading.AddChangeHook(CvarChanged_Cvars);

    RegConsoleCmd("l4l_ability", Cmd_SurvivorAbility);
    RegConsoleCmd("l4l_ultimate", Cmd_SurvivorAbility);
    RegConsoleCmd("l4l_ult", Cmd_SurvivorAbility);
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
    g_iCvarDebug           = g_hCvarDebug.IntValue;
    flTimescale            = cTimescale.FloatValue;
    flTriggerSilence       = cTriggerSilence.FloatValue;
    flTriggerSilenceFading = cTriggerSilenceFading.FloatValue;
}

void L4L_Hook()
{
    // Ensure a clean state on enable
    ResetGlobalState();

    HookEvent("player_death", Event_PlayerDeath);
}

void L4L_Unhook()
{
    // Kill timers + reset state on disable (bulletproof)
    ResetGlobalState();

    UnhookEvent("player_death", Event_PlayerDeath);
}

public void OnMapStart()
{
    // PrecacheSound(SOUND_ABILITY_DENY);
    PrecacheSound(SOUND_ABILITY_END);
    PrecacheSound(SOUND_ABILITY_PILLS);
    PrecacheSound(SOUND_ABILITY_ADREN);
}

void PlaySound(int client, const char sound[32])
{
    EmitSoundToClient(client, sound, SOUND_FROM_PLAYER, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
}

static void PlaySoundForCurrentPlayers(const char[] sound)
{
    for (int client = 1; client <= MaxClients; client++)
    {
        if (IsClientInGame(client) && !IsFakeClient(client))
        {
            PlaySound(client, sound);
        }
    }
}

Action Cmd_SurvivorAbility(int client, int args)
{
    if (!g_hCvarEnable.BoolValue)
    {
        return Plugin_Handled;
    }

    // Client validation: must be a real, in-game survivor, alive (incap allowed)
    if (client <= 0 || !IsClientInGame(client))
    {
        return Plugin_Handled;
    }

    if (IsFakeClient(client))
    {
        return Plugin_Handled;
    }

    if (GetClientTeam(client) != 2)
    {
        return Plugin_Handled;
    }

    // Dead spectators etc...
    if (!IsPlayerAlive(client))
    {
        return Plugin_Handled;
    }

    if (g_bAbilityActive)
    {
        // PlaySound(client, SOUND_ABILITY_DENY);
        PrintHintText(client, "%T", "Already active", client);

        DebugLog(client, "Denied: ability active");

        return Plugin_Handled;
    }

    if (g_bCooldownActive)
    {
        // PlaySound(client, SOUND_ABILITY_DENY);

        float left = g_flCooldownEndTime - GetEngineTime();

        if (left < 0.0)
        {
            left = 0.0;
        }

        PrintHintText(client, "%T%.0f", "Cooldown", client, left);

        DebugLog(client, "Denied: cooldown active");

        return Plugin_Handled;
    }

    int             ent      = GetPlayerWeaponSlot(client, SLOT_PILLS);
    AbilityItemType itemType = GetAbilityItemType(ent);

    if (itemType == Ability_None)
    {
        // PlaySound(client, SOUND_ABILITY_DENY);
        PrintHintText(client, "%T", "No item", client);

        DebugLog(client, "Denied: no item in slot");

        return Plugin_Handled;
    }

    if (!ConsumeAbilityItem(client, ent))
    {
        DebugLog(client, "Denied: failed to consume item");

        return Plugin_Handled;
    }

    StartAbilityPhase(client, itemType);

    return Plugin_Handled;
}

void StartAbilityPhase(int client, AbilityItemType itemType)
{
    g_bAbilityActive = true;

    KillTimerSafe(g_hTmrAbility);
    KillTimerSafe(g_hTmrCooldown);
    OnAbilityStart(itemType);

    DebugLog(client, "Ability started");

    float abilityRealDuration = (itemType == Ability_Adrenaline) ? (ABILITY_DURATION * flTimescale) : ABILITY_DURATION;
    g_hTmrAbility             = CreateTimer(abilityRealDuration, Timer_AbilityEnd, _, TIMER_FLAG_NO_MAPCHANGE);
}

public Action Timer_AbilityEnd(Handle timer)
{
    g_hTmrAbility    = null;
    g_bAbilityActive = false;

    PlaySoundForCurrentPlayers(SOUND_ABILITY_END);
    OnAbilityEnd();

    g_bCooldownActive = true;

    DebugLog(0, "Ability ended, cooldown started");

    g_flCooldownEndTime = GetEngineTime() + GLOBAL_COOLDOWN;
    g_hTmrCooldown      = CreateTimer(GLOBAL_COOLDOWN, Timer_CooldownEnd, _, TIMER_FLAG_NO_MAPCHANGE);

    return Plugin_Stop;
}

public Action Timer_CooldownEnd(Handle timer)
{
    g_hTmrCooldown      = null;
    g_bCooldownActive   = false;
    g_flCooldownEndTime = 0.0;

    PlaySoundForCurrentPlayers(SOUND_ABILITY_END);

    DebugLog(0, "Cooldown ended");

    return Plugin_Stop;
}

AbilityItemType GetAbilityItemType(int ent)
{
    if (ent <= 0 || !IsValidEntity(ent))
    {
        return Ability_None;
    }

    char cls[64];
    GetEntityClassname(ent, cls, sizeof(cls));

    if (StrEqual(cls, "weapon_pain_pills", false))
    {
        return Ability_Pills;
    }

    if (StrEqual(cls, "weapon_adrenaline", false))
    {
        return Ability_Adrenaline;
    }

    return Ability_None;
}

bool ConsumeAbilityItem(int client, int ent)
{
    if (ent <= 0 || !IsValidEntity(ent))
    {
        return false;
    }

    RemovePlayerItem(client, ent);

    if (IsValidEntity(ent))
    {
        AcceptEntityInput(ent, "Kill");
    }

    return true;
}

void OnAbilityStart(AbilityItemType itemType)
{
    switch (itemType)
    {
        case Ability_Pills:
        {
            PlaySoundForCurrentPlayers(SOUND_ABILITY_PILLS);
            ApplyPillsGlow();

            KillTimerSafe(g_hTmrGlowScan);
            g_hTmrGlowScan = CreateTimer(0.2, Timer_PillsGlowScan, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);

            return;
        }
        case Ability_Adrenaline:
        {
            float zedTimeDuration = ABILITY_DURATION * flTimescale;
            ZedTime(zedTimeDuration, flTimescale);

            return;
        }
    }
}

void OnAbilityEnd()
{
    KillTimerSafe(g_hTmrGlowScan);
    RemovePillsGlow();
}

void ResetGlobalState()
{
    KillTimerSafe(g_hTmrAbility);
    KillTimerSafe(g_hTmrCooldown);
    KillTimerSafe(g_hTmrGlowScan);
    KillTimerSafe(zeding);
    ZedBack(null, -1);

    g_bAbilityActive    = false;
    g_bCooldownActive   = false;
    g_flCooldownEndTime = 0.0;
}

void KillTimerSafe(Handle &tmr)
{
    if (tmr != null)
    {
        KillTimer(tmr);

        tmr = null;
    }
}

void DebugLog(int client, const char[] msg)
{
    if (g_iCvarDebug <= 0)
    {
        return;
    }

    if (client > 0)
    {
        PrintToServer("[L4L] Ability: (client %d) %s", client, msg);
    }
    else
    {
        PrintToServer("[L4L] Ability: %s", msg);
    }
}

// Slowmo
void ZedTime(float duration, float scale)
{
    if (zeding)
    {
        TriggerTimer(zeding);
    }

    for (int client = 1; client <= MaxClients; client++)
    {
        if (IsClientInGame(client) && !IsFakeClient(client))
        {
            PlaySound(client, SOUND_ABILITY_ADREN);

            if (flTriggerSilence)
            {
                float hold = duration - flTriggerSilenceFading;
                if (hold < 0.0)
                {
                    hold = 0.0;
                }

                FadeClientVolume(client, flTriggerSilence, flTriggerSilenceFading, hold, flTriggerSilenceFading);
            }
        }
    }

    int         entity = CreateEntityByName("func_timescale");

    static char sScale[8];
    FloatToString(scale, sScale, sizeof(sScale));
    DispatchKeyValue(entity, "desiredTimescale", sScale);
    DispatchKeyValue(entity, "acceleration", "2.0");
    DispatchKeyValue(entity, "minBlendRate", "1.0");
    DispatchKeyValue(entity, "blendDeltaMultiplier", "2.0");
    DispatchSpawn(entity);
    AcceptEntityInput(entity, "Start");

    zeding = CreateTimer(duration, ZedBack, EntIndexToEntRef(entity));
}

Action ZedBack(Handle Timer, int entity)
{
    entity = EntRefToEntIndex(entity);

    if (entity != INVALID_ENT_REFERENCE && IsValidEdict(entity))
    {
        StopTimescaler(entity);
    }
    else
    {
        int found = -1;

        while ((found = FindEntityByClassname(found, "func_timescale")) != -1)
        {
            if (IsValidEdict(found))
            {
                StopTimescaler(found);
            }
        }
    }

    zeding = null;

    return Plugin_Continue;
}

void StopTimescaler(int entity)
{
    AcceptEntityInput(entity, "Stop");
    SetVariantString("OnUser1 !self:Kill::3.0:-1");
    AcceptEntityInput(entity, "AddOutput");
    AcceptEntityInput(entity, "FireUser1");
}

// Glow
void ApplyGlow(int ent)
{
    if (ent <= 0 || !IsValidEntity(ent))
    {
        return;
    }

    if (GetEntProp(ent, Prop_Send, "m_glowColorOverride") == GLOW_COLOR)
    {
        return;
    }

    SetEntProp(ent, Prop_Send, "m_nGlowRange", 99999);
    SetEntProp(ent, Prop_Send, "m_iGlowType", 3);
    SetEntProp(ent, Prop_Send, "m_glowColorOverride", GLOW_COLOR);
}

void RemoveGlow(int ent)
{
    if (ent <= 0 || !IsValidEntity(ent))
    {
        return;
    }

    if (GetEntProp(ent, Prop_Send, "m_glowColorOverride") != GLOW_COLOR)
    {
        return;
    }

    SetEntProp(ent, Prop_Send, "m_nGlowRange", 0);
    SetEntProp(ent, Prop_Send, "m_iGlowType", 0);
    SetEntProp(ent, Prop_Send, "m_glowColorOverride", 0);
}

void ApplyPillsGlow()
{
    for (int i = 1; i <= MaxClients; i++)
    {
        if (!IsClientInGame(i) || !IsPlayerAlive(i))
        {
            continue;
        }

        if (GetClientTeam(i) == 3)
        {
            ApplyGlow(i);
        }
    }

    int ent = -1;

    while ((ent = FindEntityByClassname(ent, "witch")) != -1)
    {
        ApplyGlow(ent);
    }
}

void RemovePillsGlow()
{
    for (int i = 1; i <= MaxClients; i++)
    {
        if (IsClientInGame(i) && GetClientTeam(i) == 3)
        {
            RemoveGlow(i);
        }
    }

    int ent = -1;

    while ((ent = FindEntityByClassname(ent, "witch")) != -1)
    {
        RemoveGlow(ent);
    }
}

void Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
    int client = GetClientOfUserId(event.GetInt("userid"));

    if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == 3)
    {
        RemoveGlow(client);
    }
}

public Action Timer_PillsGlowScan(Handle timer)
{
    if (!g_bAbilityActive)
    {
        g_hTmrGlowScan = null;

        return Plugin_Stop;
    }

    ApplyPillsGlow();

    return Plugin_Continue;
}