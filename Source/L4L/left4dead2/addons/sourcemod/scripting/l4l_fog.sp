#pragma semicolon 1
#pragma newdecls required

#include <l4l/utils>
#include <l4l/lifecycle>
#include <sdktools>

#define PLUGIN_VERSION      "0.0.1"
#define MAX_FOG_CONTROLLERS 16

ConVar g_hCvarEnable, g_hCvarDebug, g_hCvarFogEnable, g_hCvarFogStart, g_hCvarFogEnd, g_hCvarSkyEnable, g_hCvarSkyStart, g_hCvarSkyEnd;
int    g_iCvarDebug, g_iPresetFogEnable, g_iPresetSkyEnable;
float  g_fPresetFogStart, g_fPresetFogEnd, g_fPresetSkyStart, g_fPresetSkyEnd;

// Fog
int    g_iFogCount;
int    g_iFogRefs[MAX_FOG_CONTROLLERS];
int    g_iFogEnable[MAX_FOG_CONTROLLERS];
float  g_fFogStart[MAX_FOG_CONTROLLERS];
float  g_fFogEnd[MAX_FOG_CONTROLLERS];

// Skybox fog
int    g_iSkyRef = INVALID_ENT_REFERENCE;
int    g_iSkyFogEnable;
float  g_fSkyFogStart;
float  g_fSkyFogEnd;

bool   g_bBaselineCaptured = false;

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

    g_hCvarSkyEnable = CreateConVar("l4l_fog_preset_sky_enable", "1", "Skybox fog preset: 0/1 enable skybox fog.", CVAR_FLAGS, true, 0.0, true, 1.0);
    g_hCvarSkyStart  = CreateConVar("l4l_fog_preset_sky_start", "-10000", "Skybox fog preset: start distance.", CVAR_FLAGS);
    g_hCvarSkyEnd    = CreateConVar("l4l_fog_preset_sky_end", "-10000", "Skybox fog preset: end distance.", CVAR_FLAGS);

    CreateDirectory("cfg/sourcemod/l4l_plugins", 511, true);
    AutoExecConfig(true, "l4l_fog", "sourcemod/l4l_plugins");

    g_hCvarEnable.AddChangeHook(CvarChanged_Enable);
    g_hCvarDebug.AddChangeHook(CvarChanged_Cvars);

    g_hCvarFogEnable.AddChangeHook(CvarChanged_Cvars);
    g_hCvarFogStart.AddChangeHook(CvarChanged_Cvars);
    g_hCvarFogEnd.AddChangeHook(CvarChanged_Cvars);

    g_hCvarSkyEnable.AddChangeHook(CvarChanged_Cvars);
    g_hCvarSkyStart.AddChangeHook(CvarChanged_Cvars);
    g_hCvarSkyEnd.AddChangeHook(CvarChanged_Cvars);
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

    g_iPresetSkyEnable = g_hCvarSkyEnable.IntValue;
    g_fPresetSkyStart  = g_hCvarSkyStart.FloatValue;
    g_fPresetSkyEnd    = g_hCvarSkyEnd.FloatValue;
}

void L4L_Hook()
{
    if (g_bBaselineCaptured)
    {
        ApplyFog();

        return;
    }

    CaptureBaseline();
    ApplyFog();
}

void L4L_Unhook()
{
    RestoreBaseline();
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

void RestoreBaseline()
{
    if (!g_bBaselineCaptured)
        return;

    for (int i = 0; i < g_iFogCount; i++)
    {
        int ref = g_iFogRefs[i];

        if (ref == INVALID_ENT_REFERENCE)
            continue;

        int ent = EntRefToEntIndex(ref);

        if (ent <= MaxClients || !IsValidEntity(ent))
            continue;

        SetEntProp(ent, Prop_Send, "m_fog.enable", g_iFogEnable[i]);
        SetEntPropFloat(ent, Prop_Send, "m_fog.start", g_fFogStart[i]);
        SetEntPropFloat(ent, Prop_Send, "m_fog.end", g_fFogEnd[i]);
    }

    int sky = EntRefToEntIndex(g_iSkyRef);

    if (sky > 0 && IsValidEntity(sky))
    {
        SetEntProp(sky, Prop_Send, "m_skyboxData.fog.enable", g_iSkyFogEnable);
        SetEntPropFloat(sky, Prop_Send, "m_skyboxData.fog.start", g_fSkyFogStart);
        SetEntPropFloat(sky, Prop_Send, "m_skyboxData.fog.end", g_fSkyFogEnd);
    }
}

void ResetBaseline()
{
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
}

void ApplyFog()
{
    for (int i = 0; i < g_iFogCount; i++)
    {
        int ref = g_iFogRefs[i];

        if (ref == INVALID_ENT_REFERENCE)
            continue;

        int ent = EntRefToEntIndex(ref);

        if (ent <= MaxClients || !IsValidEntity(ent))
            continue;

        SetEntProp(ent, Prop_Send, "m_fog.enable", g_iPresetFogEnable);
        SetEntPropFloat(ent, Prop_Send, "m_fog.start", g_fPresetFogStart);
        SetEntPropFloat(ent, Prop_Send, "m_fog.end", g_fPresetFogEnd);
    }

    int sky = EntRefToEntIndex(g_iSkyRef);

    if (sky > 0 && IsValidEntity(sky))
    {
        SetEntProp(sky, Prop_Send, "m_skyboxData.fog.enable", g_iPresetSkyEnable);
        SetEntPropFloat(sky, Prop_Send, "m_skyboxData.fog.start", g_fPresetSkyStart);
        SetEntPropFloat(sky, Prop_Send, "m_skyboxData.fog.end", g_fPresetSkyEnd);
    }
}