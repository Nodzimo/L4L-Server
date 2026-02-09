#pragma semicolon 1
#pragma newdecls required

#include <l4l/utils>
#include <l4l/lifecycle>
#include <sdktools>

#define PLUGIN_VERSION             "0.0.1"
#define MAX_FOG_CONTROLLERS        16
#define FOG_NAME_LEN               64
#define WORLD_BOUNDS_CENTER_FACTOR 0.5

ConVar g_hCvarEnable, g_hCvarDebug, g_hCvarFogEnable, g_hCvarFogStart, g_hCvarFogEnd, g_hCvarSkyEnable, g_hCvarSkyStart, g_hCvarSkyEnd, g_hCvarFadeTime, g_hCvarAshEnable;
int    g_iCvarDebug, g_iPresetFogEnable, g_iPresetSkyEnable, g_iPresetAshEnable;
float  g_fPresetFogStart, g_fPresetFogEnd, g_fPresetSkyStart, g_fPresetSkyEnd, g_fPresetFadeTime;

bool   g_bRoundStartHooked = false;
bool   g_bBaselineCaptured = false;
int    g_iAshRef           = INVALID_ENT_REFERENCE;

// Fog
int    g_iFogCount;
int    g_iFogRefs[MAX_FOG_CONTROLLERS];
int    g_iFogEnable[MAX_FOG_CONTROLLERS];
float  g_fFogStart[MAX_FOG_CONTROLLERS];
float  g_fFogEnd[MAX_FOG_CONTROLLERS];
char   g_sFogName[MAX_FOG_CONTROLLERS][FOG_NAME_LEN];

// Skybox fog
int    g_iSkyRef = INVALID_ENT_REFERENCE;
int    g_iSkyFogEnable;
float  g_fSkyFogStart;
float  g_fSkyFogEnd;

// Fade
bool   g_bFading        = false;
bool   g_bFadeToPreset  = false;
float  g_fFadeStartTime = 0.0;
float  g_fFadeDuration  = 0.0;

float  g_fFadeFromStart[MAX_FOG_CONTROLLERS];
float  g_fFadeFromEnd[MAX_FOG_CONTROLLERS];
float  g_fFadeToStart[MAX_FOG_CONTROLLERS];
float  g_fFadeToEnd[MAX_FOG_CONTROLLERS];
int    g_iFadeFinalEnable[MAX_FOG_CONTROLLERS];

public Plugin myinfo =
{
    name    = "L4L: Fog",
    author  = "Sefo",
    version = PLUGIN_VERSION,
    url     = "Sefo.su"
};

public void OnPluginStart()
{
    CreateConVar("l4l_fog_version", PLUGIN_VERSION, "L4L: Fog version", CVAR_FLAGS | FCVAR_DONTRECORD);
    g_hCvarEnable    = CreateConVar("l4l_fog_enable", "0", "0 = Plugin off, 1 = Plugin on", CVAR_FLAGS, true, float(DISABLE), true, float(ENABLE));
    g_hCvarDebug     = CreateConVar("l4l_fog_debug", "0", "0 = Debug off, 1 = Debug on, 2 = Debug events, 3 = Debug sounds", CVAR_FLAGS, true, float(DISABLE), true, float(DEBUG_SOUNDS));

    g_hCvarFogEnable = CreateConVar("l4l_fog_preset_enable", "1", "Fog preset: 0/1 enable env_fog_controller fog.", CVAR_FLAGS, true, 0.0, true, 1.0);
    g_hCvarFogStart  = CreateConVar("l4l_fog_preset_start", "242", "Fog preset: fog start distance.", CVAR_FLAGS);
    g_hCvarFogEnd    = CreateConVar("l4l_fog_preset_end", "730", "Fog preset: fog end distance.", CVAR_FLAGS);
    g_hCvarFadeTime  = CreateConVar("l4l_fog_fade_time", "3.0", "Fog transition duration (seconds). Used for fade in/out.", CVAR_FLAGS, true, 0.01, true, 30.0);

    g_hCvarSkyEnable = CreateConVar("l4l_fog_preset_sky_enable", "1", "Skybox fog preset: 0/1 enable skybox fog.", CVAR_FLAGS, true, 0.0, true, 1.0);
    g_hCvarSkyStart  = CreateConVar("l4l_fog_preset_sky_start", "-10000", "Skybox fog preset: start distance.", CVAR_FLAGS);
    g_hCvarSkyEnd    = CreateConVar("l4l_fog_preset_sky_end", "-10000", "Skybox fog preset: end distance.", CVAR_FLAGS);
    g_hCvarAshEnable = CreateConVar("l4l_fog_ash_enable", "1", "0 = off, 1 = spawn ash precipitation when fog preset is active", CVAR_FLAGS, true, 0.0, true, 1.0);

    CreateDirectory("cfg/sourcemod/l4l_plugins", 511, true);
    AutoExecConfig(true, "l4l_fog", "sourcemod/l4l_plugins");

    g_hCvarEnable.AddChangeHook(CvarChanged_Enable);
    g_hCvarDebug.AddChangeHook(CvarChanged_Cvars);

    g_hCvarFogEnable.AddChangeHook(CvarChanged_Cvars);
    g_hCvarFogStart.AddChangeHook(CvarChanged_Cvars);
    g_hCvarFogEnd.AddChangeHook(CvarChanged_Cvars);
    g_hCvarFadeTime.AddChangeHook(CvarChanged_Cvars);

    g_hCvarSkyEnable.AddChangeHook(CvarChanged_Cvars);
    g_hCvarSkyStart.AddChangeHook(CvarChanged_Cvars);
    g_hCvarSkyEnd.AddChangeHook(CvarChanged_Cvars);
    g_hCvarAshEnable.AddChangeHook(CvarChanged_Cvars);
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
    g_iCvarDebug       = g_hCvarDebug.IntValue;

    g_iPresetFogEnable = g_hCvarFogEnable.IntValue;
    g_fPresetFogStart  = g_hCvarFogStart.FloatValue;
    g_fPresetFogEnd    = g_hCvarFogEnd.FloatValue;
    g_fPresetFadeTime  = g_hCvarFadeTime.FloatValue;

    g_iPresetSkyEnable = g_hCvarSkyEnable.IntValue;
    g_fPresetSkyStart  = g_hCvarSkyStart.FloatValue;
    g_fPresetSkyEnd    = g_hCvarSkyEnd.FloatValue;
    g_iPresetAshEnable = g_hCvarAshEnable.IntValue;
}

void L4L_Hook()
{
    if (!g_bRoundStartHooked)
    {
        HookEvent("round_start", Event_RoundStart, EventHookMode_PostNoCopy);

        g_bRoundStartHooked = true;
    }

    if (g_bBaselineCaptured)
    {
        StartFogFade(true);

        return;
    }

    CaptureBaseline();
    StartFogFade(true);
}

public void Event_RoundStart(Event event, const char[] name, bool dontBroadcast)
{
    CreateTimer(1.0, Timer_RoundReapply, _, TIMER_FLAG_NO_MAPCHANGE);
}

public Action Timer_RoundReapply(Handle timer)
{
    if (!g_bBaselineCaptured)
        return Plugin_Stop;

    RefreshRefsOnly();

    if (!g_hCvarEnable.BoolValue)
    {
        KillAsh();

        return Plugin_Stop;
    }

    StartFogFade(true);

    if (g_iPresetAshEnable)
        CreateAsh();
    else
        KillAsh();

    return Plugin_Stop;
}

void L4L_Unhook()
{
    if (!g_bBaselineCaptured)
        return;

    StartFogFade(false);
}

public void OnMapStart()
{
    ResetBaseline();

    if (g_hCvarEnable.BoolValue)
    {
        L4L_Hook();
    }
}

public void OnMapEnd()
{
    ResetBaseline();
}

void CaptureBaseline()
{
    if (g_bBaselineCaptured)
        return;

    g_iFogCount = 0;
    int ent     = -1;

    while ((ent = FindEntityByClassname(ent, "env_fog_controller")) != -1)
    {
        if (g_iFogCount >= MAX_FOG_CONTROLLERS)
            break;

        if (ent <= MaxClients || !IsValidEntity(ent))
            continue;

        GetEntPropString(ent, Prop_Data, "m_iName", g_sFogName[g_iFogCount], FOG_NAME_LEN);

        g_iFogRefs[g_iFogCount]   = EntIndexToEntRef(ent);
        g_iFogEnable[g_iFogCount] = GetEntProp(ent, Prop_Send, "m_fog.enable");
        g_fFogStart[g_iFogCount]  = GetEntPropFloat(ent, Prop_Send, "m_fog.start");
        g_fFogEnd[g_iFogCount]    = GetEntPropFloat(ent, Prop_Send, "m_fog.end");

        g_iFogCount++;
    }

    int sky = FindEntityByClassname(-1, "sky_camera");

    if (sky > 0 && IsValidEntity(sky))
    {
        g_iSkyRef       = EntIndexToEntRef(sky);
        g_iSkyFogEnable = GetEntProp(sky, Prop_Send, "m_skyboxData.fog.enable");
        g_fSkyFogStart  = GetEntPropFloat(sky, Prop_Send, "m_skyboxData.fog.start");
        g_fSkyFogEnd    = GetEntPropFloat(sky, Prop_Send, "m_skyboxData.fog.end");
    }

    g_bBaselineCaptured = true;
}

void ResetBaseline()
{
    KillAsh();
    CancelFogFade();

    g_bBaselineCaptured = false;
    g_iFogCount         = 0;

    for (int i = 0; i < MAX_FOG_CONTROLLERS; i++)
    {
        g_iFogRefs[i]   = INVALID_ENT_REFERENCE;
        g_iFogEnable[i] = 0;
        g_fFogStart[i]  = 0.0;
        g_fFogEnd[i]    = 0.0;
    }

    g_iSkyRef       = INVALID_ENT_REFERENCE;
    g_iSkyFogEnable = 0;
    g_fSkyFogStart  = 0.0;
    g_fSkyFogEnd    = 0.0;

    for (int i = 0; i < MAX_FOG_CONTROLLERS; i++)
    {
        g_sFogName[i][0] = '\0';
    }
}

void CancelFogFade()
{
    g_bFading = false;
}

void StartFogFade(bool toPreset)
{
    if (!g_bBaselineCaptured)
        CaptureBaseline();

    if (g_iFogCount <= 0)
        return;

    CancelFogFade();

    g_bFadeToPreset  = toPreset;
    g_fFadeStartTime = GetGameTime();
    g_fFadeDuration  = g_fPresetFadeTime;

    if (g_fFadeDuration < 0.01)
        g_fFadeDuration = 0.01;

    for (int i = 0; i < g_iFogCount; i++)
    {
        int ref = g_iFogRefs[i];

        if (ref == INVALID_ENT_REFERENCE)
            continue;

        int ent = EntRefToEntIndex(ref);

        if (ent <= MaxClients || !IsValidEntity(ent))
            continue;

        g_fFadeFromStart[i] = GetEntPropFloat(ent, Prop_Send, "m_fog.start");
        g_fFadeFromEnd[i]   = GetEntPropFloat(ent, Prop_Send, "m_fog.end");

        if (toPreset)
        {
            g_fFadeToStart[i] = g_fPresetFogStart;
            g_fFadeToEnd[i]   = g_fPresetFogEnd;

            SetEntProp(ent, Prop_Send, "m_fog.enable", g_iPresetFogEnable);
            g_iFadeFinalEnable[i] = g_iPresetFogEnable;
        }
        else
        {
            g_fFadeToStart[i] = g_fFogStart[i];
            g_fFadeToEnd[i]   = g_fFogEnd[i];

            SetEntProp(ent, Prop_Send, "m_fog.enable", 1);
            g_iFadeFinalEnable[i] = g_iFogEnable[i];
        }
    }

    g_bFading = true;
}

public void OnGameFrame()
{
    if (!g_bBaselineCaptured)
    {
        g_bFading = false;

        return;
    }

    if (!g_bFading)
        return;

    float now  = GetGameTime();
    float time = (now - g_fFadeStartTime) / g_fFadeDuration;

    if (time < 0.0) time = 0.0;

    if (time > 1.0) time = 1.0;

    for (int i = 0; i < g_iFogCount; i++)
    {
        int ref = g_iFogRefs[i];

        if (ref == INVALID_ENT_REFERENCE)
            continue;

        int ent = EntRefToEntIndex(ref);

        if (ent <= MaxClients || !IsValidEntity(ent))
            continue;

        float start = g_fFadeFromStart[i] + (g_fFadeToStart[i] - g_fFadeFromStart[i]) * time;
        float end   = g_fFadeFromEnd[i] + (g_fFadeToEnd[i] - g_fFadeFromEnd[i]) * time;

        SetEntPropFloat(ent, Prop_Send, "m_fog.start", start);
        SetEntPropFloat(ent, Prop_Send, "m_fog.end", end);

        if (time >= 1.0)
        {
            SetEntPropFloat(ent, Prop_Send, "m_fog.start", g_fFadeToStart[i]);
            SetEntPropFloat(ent, Prop_Send, "m_fog.end", g_fFadeToEnd[i]);
            SetEntProp(ent, Prop_Send, "m_fog.enable", g_iFadeFinalEnable[i]);
        }
    }

    if (time >= 1.0)
    {
        int sky = EntRefToEntIndex(g_iSkyRef);

        if (sky > 0 && IsValidEntity(sky))
        {
            if (g_bFadeToPreset)
            {
                SetEntProp(sky, Prop_Send, "m_skyboxData.fog.enable", g_iPresetSkyEnable);
                SetEntPropFloat(sky, Prop_Send, "m_skyboxData.fog.start", g_fPresetSkyStart);
                SetEntPropFloat(sky, Prop_Send, "m_skyboxData.fog.end", g_fPresetSkyEnd);
            }
            else
            {
                SetEntProp(sky, Prop_Send, "m_skyboxData.fog.enable", g_iSkyFogEnable);
                SetEntPropFloat(sky, Prop_Send, "m_skyboxData.fog.start", g_fSkyFogStart);
                SetEntPropFloat(sky, Prop_Send, "m_skyboxData.fog.end", g_fSkyFogEnd);
            }
        }

        if (g_bFadeToPreset)
        {
            if (g_iPresetAshEnable)
                CreateAsh();
            else
                KillAsh();
        }
        else
        {
            KillAsh();
        }

        g_bFading = false;
    }
}

void KillAsh()
{
    int ent = EntRefToEntIndex(g_iAshRef);

    if (ent > 0 && IsValidEntity(ent))
    {
        AcceptEntityInput(ent, "Kill");
    }

    g_iAshRef = INVALID_ENT_REFERENCE;
}

void CreateAsh()
{
    int existing = EntRefToEntIndex(g_iAshRef);

    if (existing > 0 && IsValidEntity(existing))
        return;

    int ent = CreateEntityByName("func_precipitation");

    if (ent == -1)
        return;

    char map[64];
    GetCurrentMap(map, sizeof(map));
    Format(map, sizeof(map), "maps/%s.bsp", map);
    PrecacheModel(map, true);

    DispatchKeyValue(ent, "model", map);
    DispatchKeyValue(ent, "preciptype", "3");

    float vMins[3], vMax[3], vCenter[3];
    GetEntPropVector(0, Prop_Data, "m_WorldMins", vMins);
    GetEntPropVector(0, Prop_Data, "m_WorldMaxs", vMax);

    SetEntPropVector(ent, Prop_Send, "m_vecMins", vMins);
    SetEntPropVector(ent, Prop_Send, "m_vecMaxs", vMax);

    vCenter[0] = (vMins[0] + vMax[0]) * WORLD_BOUNDS_CENTER_FACTOR;
    vCenter[1] = (vMins[1] + vMax[1]) * WORLD_BOUNDS_CENTER_FACTOR;
    vCenter[2] = (vMins[2] + vMax[2]) * WORLD_BOUNDS_CENTER_FACTOR;

    TeleportEntity(ent, vCenter, NULL_VECTOR, NULL_VECTOR);
    DispatchSpawn(ent);

    if (!IsValidEntity(ent))
        return;

    ActivateEntity(ent);

    g_iAshRef = EntIndexToEntRef(ent);
}

void RefreshRefsOnly()
{
    for (int i = 0; i < g_iFogCount; i++)
        g_iFogRefs[i] = INVALID_ENT_REFERENCE;

    bool usedSlot[MAX_FOG_CONTROLLERS];

    for (int i = 0; i < MAX_FOG_CONTROLLERS; i++)
        usedSlot[i] = false;

    int ent = -1;

    while ((ent = FindEntityByClassname(ent, "env_fog_controller")) != -1)
    {
        if (ent <= MaxClients || !IsValidEntity(ent))
            continue;

        char name[FOG_NAME_LEN];
        GetEntPropString(ent, Prop_Data, "m_iName", name, sizeof(name));

        int slot = -1;

        if (name[0] != '\0')
        {
            for (int i = 0; i < g_iFogCount; i++)
            {
                if (!usedSlot[i] && StrEqual(name, g_sFogName[i], false))
                {
                    slot = i;

                    break;
                }
            }
        }

        if (slot == -1)
        {
            for (int i = 0; i < g_iFogCount; i++)
            {
                if (!usedSlot[i] && g_sFogName[i][0] == '\0')
                {
                    slot = i;

                    break;
                }
            }
        }

        if (slot == -1)
        {
            for (int i = 0; i < g_iFogCount; i++)
            {
                if (!usedSlot[i])
                {
                    slot = i;

                    break;
                }
            }
        }

        if (slot != -1)
        {
            usedSlot[slot]   = true;
            g_iFogRefs[slot] = EntIndexToEntRef(ent);
        }
    }

    int sky   = FindEntityByClassname(-1, "sky_camera");
    g_iSkyRef = (sky > 0 && IsValidEntity(sky)) ? EntIndexToEntRef(sky) : INVALID_ENT_REFERENCE;
}