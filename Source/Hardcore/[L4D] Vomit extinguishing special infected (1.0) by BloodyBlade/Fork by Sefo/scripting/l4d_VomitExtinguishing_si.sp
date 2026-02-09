#pragma semicolon 1
#pragma newdecls required
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

#define PLUGIN_VERSION "1.0"
#define CVAR_FLAGS FCVAR_NOTIFY
#define CLASSNAME_VOMITJAR "vomitjar_projectile"

ConVar hVomitPluginEnabled, hVomitAdvMessageType, hVomitRange, hVomitDuration;
int iVomitAdvMessageType = 0;
static int g_iVomitJarOwnerUserId[2049];
bool bHooked = false;
float g_fVomitRange = 0.0;
float g_fVomitDuration = 0.0;
float g_fSplashRadius = 200.0;
float g_fBileRadius = 150.0;
float g_fBileZFix = 70.0;
Handle g_hVomitTimer[MAXPLAYERS + 1];

public Plugin myinfo = 
{
	name = "[L4D] Vomit extinguishing special infected",
	author = "BloodyBlade",
	description = "Vomit can extinguish burning special infected",
	version = PLUGIN_VERSION,
	url = "http://bloodsiworld.ru/"
}

//Special thanks: [L4D & L4D2] Vomit extinguishing by Olj, Visual77, asto, raziEiL [disawar1]

public void OnPluginStart()
{
	CreateConVar("l4d_vomit_extinguish_si_plugin_version", PLUGIN_VERSION, "Vomit Extinguishing  special infected plugin version", CVAR_FLAGS|FCVAR_DONTRECORD);
	hVomitPluginEnabled = CreateConVar("l4d_vomit_extinguish_si_plugin_enabled", "0", " Enable/Disable plugin", CVAR_FLAGS, true, 0.0, true, 1.0);
	hVomitAdvMessageType = CreateConVar("l4d_vomit_extinguish_si_advmessage_type", "0", "Message type(0 - disable, 1 - chat, 2 - hint, 3 - instructor hint)", CVAR_FLAGS, true, 0.0, true, 3.0);

	hVomitPluginEnabled.AddChangeHook(ConVarPluginOnChanged);
	hVomitAdvMessageType.AddChangeHook(ConVarVomitMessageTypeChanged);

	hVomitRange = FindConVar("z_vomit_range");
	hVomitDuration = FindConVar("z_vomit_duration");

	if (hVomitRange != null)
	{
	    g_fVomitRange = hVomitRange.FloatValue;
	    hVomitRange.AddChangeHook(ConVarVomitRangeChanged);
	}

	if (hVomitDuration != null)
	{
	    g_fVomitDuration = hVomitDuration.FloatValue;
	    hVomitDuration.AddChangeHook(ConVarVomitDurationChanged);
	}

	LoadTranslations("l4d_vomit_extinguish_si.phrases");
	AutoExecConfig(true, "l4d_vomit_extinguishing_si");
}

public void OnConfigsExecuted()
{
    IsAllowed();
}

void ConVarPluginOnChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
    IsAllowed();
}

void ConVarVomitMessageTypeChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
    iVomitAdvMessageType = hVomitAdvMessageType.IntValue;
}

void ConVarVomitRangeChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
    g_fVomitRange = convar.FloatValue;
}

void ConVarVomitDurationChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
    g_fVomitDuration = convar.FloatValue;
}

void IsAllowed()
{
	bool bPluginOn = hVomitPluginEnabled.BoolValue;

	if(bPluginOn && !bHooked)
	{
		bHooked = true;

		for (int e = MaxClients + 1; e < 2049; e++)
    		g_iVomitJarOwnerUserId[e] = 0;

		for (int i = 1; i <= MaxClients; i++)
		{
    		g_hVomitTimer[i] = null;

			if (IsClientInGame(i))
        		HookClientDamageIfTank(i);
		}

		ConVarVomitMessageTypeChanged(null, "", "");
		HookEvent("player_spawn", EventPlayerSpawn);
		HookEvent("ability_use", EventAbilityUse);
		HookEvent("player_death", EventPlayerDeath);
		HookEvent("round_start", Event_RoundStart);
	}
	else if(!bPluginOn && bHooked)
	{
		bHooked = false;

		UnhookEvent("player_spawn", EventPlayerSpawn);
		UnhookEvent("ability_use", EventAbilityUse);
		UnhookEvent("player_death", EventPlayerDeath);
		UnhookEvent("round_start", Event_RoundStart);

		for (int i = 1; i <= MaxClients; i++)
		{
		    if (g_hVomitTimer[i] != null)
		    {
		        delete g_hVomitTimer[i];
		        g_hVomitTimer[i] = null;
		    }

		    if (IsClientInGame(i))
		        SDKUnhook(i, SDKHook_OnTakeDamageAlive, OnTakeDamageAlive);
		}
	}
}

Action EventPlayerSpawn(Event h_Event, const char[] s_Name, bool b_DontBroadcast)
{
	int iClient = GetClientOfUserId(h_Event.GetInt("userid"));

	if (iClient) HookClientDamageIfTank(iClient);

	if (IsValidInfected(iClient) && !IsFakeClient(iClient) && GetEntProp(iClient, Prop_Send, "m_zombieClass") == 2)
	{
		switch(iVomitAdvMessageType)
		{
			case 1:
			{
				PrintToChat(iClient, "\x03[%t]\x01 %t.", "Information", "Vomit players");
			}
			case 2: 
			{
				PrintHintText(iClient, "%t", "Vomit players");
			}
			case 3:
			{
				char s_Message[256];
				FormatEx(s_Message, sizeof(s_Message), "%t", "Vomit players");
				DisplayInstructorHint(iClient, s_Message, "+attack");
			}
		}
	}

	return Plugin_Continue;
}

void DisplayInstructorHint(int iClient, char sMessage[256], char[] sBind)
{
	char s_TargetName[32];
	int iEnt = CreateEntityByName("env_instructor_hint");
	FormatEx(s_TargetName, sizeof(s_TargetName), "hint%d", iClient);
	ReplaceString(sMessage, sizeof(sMessage), "\n", " ");
	DispatchKeyValue(iClient, "targetname", s_TargetName);
	DispatchKeyValue(iEnt, "hint_target", s_TargetName);
	DispatchKeyValue(iEnt, "hint_timeout", "5");
	DispatchKeyValue(iEnt, "hint_range", "0.01");
	DispatchKeyValue(iEnt, "hint_color", "255 255 255");
	DispatchKeyValue(iEnt, "hint_icon_onscreen", "use_binding");
	DispatchKeyValue(iEnt, "hint_caption", sMessage);
	DispatchKeyValue(iEnt, "hint_binding", sBind);
	DispatchSpawn(iEnt);
	AcceptEntityInput(iEnt, "ShowHint");

	DataPack hRemovePack = new DataPack();
	hRemovePack.WriteCell(iClient);
	hRemovePack.WriteCell(EntIndexToEntRef(iEnt));
	CreateDataTimer(5.0, RemoveInstructorHint, hRemovePack, TIMER_DATA_HNDL_CLOSE|TIMER_FLAG_NO_MAPCHANGE);
}

Action RemoveInstructorHint(Handle h_Timer, DataPack hPack)
{
	hPack.Reset();
	int iClient = hPack.ReadCell();
	int iEnt = EntRefToEntIndex(hPack.ReadCell());

	if (IsValidEntity(iEnt))
	{
		RemoveEntity(iEnt);
	}

	if (IsValidInfected(iClient))
	{
		DispatchKeyValue(iClient, "targetname", "");
	}

	return Plugin_Stop;
}

bool IsValidInfected(int iClient)
{
	return iClient > 0 && iClient <= MaxClients && IsClientInGame(iClient) && GetClientTeam(iClient) == 3 && IsPlayerAlive(iClient);
}

bool IsValidInfectedAnyState(int iClient)
{
    return iClient > 0 && iClient <= MaxClients
        && IsClientInGame(iClient)
        && GetClientTeam(iClient) == 3;
}

void EventAbilityUse(Event event, const char[] name, bool dontBroadcast)
{
    int client = GetClientOfUserId(event.GetInt("userid"));

    if (!IsValidInfected(client)) return;

    if (GetEntProp(client, Prop_Send, "m_zombieClass") != 2) return;

    char ability[64];
    event.GetString("ability", ability, sizeof(ability));

    if (StrContains(ability, "vomit", false) == -1)
        return;

    if (g_fVomitRange <= 0.0 || g_fVomitDuration <= 0.0)
        return;

    if (g_hVomitTimer[client] != null)
        return;

    g_hVomitTimer[client] = CreateTimer(0.1, TimerVomitThink, client,
        TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);

    CreateTimer(g_fVomitDuration, TimerStopVomit, client,
        TIMER_FLAG_NO_MAPCHANGE);
}

Action TimerVomitThink(Handle timer, any client)
{
    if (!IsValidInfected(client) || GetEntProp(client, Prop_Send, "m_zombieClass") != 2)
    {
        if (client > 0 && client <= MaxClients)
            g_hVomitTimer[client] = null;

        return Plugin_Stop;
    }

    int target = GetClientAimTarget(client, true);

    if (!IsValidInfected(target))
        return Plugin_Continue;

    float a[3], b[3];
    GetClientAbsOrigin(client, a);
    GetClientAbsOrigin(target, b);

    if (GetVectorDistance(a, b) <= g_fVomitRange)
    {
        ExtinguishEntity(target);
    }

    return Plugin_Continue;
}

Action TimerStopVomit(Handle timer, any client)
{
    if (client > 0 && client <= MaxClients)
    {
        if (g_hVomitTimer[client] != null)
        {
            delete g_hVomitTimer[client];
            g_hVomitTimer[client] = null;
        }
    }

    return Plugin_Stop;
}

void EventPlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
    int victim = GetClientOfUserId(event.GetInt("userid"));

	if (victim) SDKUnhook(victim, SDKHook_OnTakeDamageAlive, OnTakeDamageAlive);

	if (!IsValidInfectedAnyState(victim)) return;

    if (GetEntProp(victim, Prop_Send, "m_zombieClass") != 2) return;

    float boomerPos[3], targetPos[3];
    GetClientAbsOrigin(victim, boomerPos);

    for (int i = 1; i <= MaxClients; i++)
    {
        if (!IsValidInfected(i) || i == victim)
            continue;

        GetClientAbsOrigin(i, targetPos);

        if (GetVectorDistance(boomerPos, targetPos) <= g_fSplashRadius)
        {
            ExtinguishEntity(i);
        }
    }
}

bool IsTank(int client)
{
    return IsValidInfectedAnyState(client) && GetEntProp(client, Prop_Send, "m_zombieClass") == 8;
}

void HookClientDamageIfTank(int client)
{
    if (!bHooked) return;

    if (!IsTank(client)) return;

    SDKUnhook(client, SDKHook_OnTakeDamageAlive, OnTakeDamageAlive);
    SDKHook(client, SDKHook_OnTakeDamageAlive, OnTakeDamageAlive);
}

Action OnTakeDamageAlive(int victim, int &attacker, int &inflictor, float &damage, int &damagetype)
{
    if (!IsTank(victim))
        return Plugin_Continue;

    if (!(GetEntityFlags(victim) & FL_ONFIRE))
        return Plugin_Continue;

    if (inflictor > MaxClients && IsValidEntity(inflictor))
    {
        char classname[32];
        GetEdictClassname(inflictor, classname, sizeof(classname));

		if (strcmp(classname, "grenade_launcher_projectile") == 0 || strcmp(classname, "grenade_launcher") == 0)
        {
            ExtinguishEntity(victim);
        }
    }

    return Plugin_Continue;
}

public void OnEntityCreated(int entity, const char[] classname)
{
    if (!bHooked) return;

    if (entity <= MaxClients || entity >= 2049) return;

    if (strcmp(classname, CLASSNAME_VOMITJAR) == 0)
    {
        SDKHook(entity, SDKHook_SpawnPost, OnVomitJarSpawnPost);
    }
}

public void OnEntityDestroyed(int entity)
{
    if (!bHooked) return;

    if (entity <= MaxClients || entity >= 2049) return;

    if (!IsValidEdict(entity)) return;

    char classname[32];
    GetEdictClassname(entity, classname, sizeof(classname));

    if (strcmp(classname, CLASSNAME_VOMITJAR) != 0)
        return;

    float pos[3];
    GetEntPropVector(entity, Prop_Send, "m_vecOrigin", pos);
    pos[2] += g_fBileZFix;

    ExtinguishTanksInRadius(pos, g_fBileRadius);
}

void OnVomitJarSpawnPost(int entity)
{
    if (!IsValidEntity(entity)) return;

    int owner = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");

    if (owner > 0 && owner <= MaxClients && IsClientInGame(owner))
        g_iVomitJarOwnerUserId[entity] = GetClientUserId(owner);
    else
        g_iVomitJarOwnerUserId[entity] = 0;
}

void ExtinguishTanksInRadius(const float pos[3], float radius)
{
    float tpos[3];

    for (int i = 1; i <= MaxClients; i++)
    {
        if (!IsTank(i) || !IsPlayerAlive(i))
            continue;

        if (!(GetEntityFlags(i) & FL_ONFIRE))
            continue;

        GetClientAbsOrigin(i, tpos);

        if (GetVectorDistance(pos, tpos) <= radius)
        {
            ExtinguishEntity(i);
        }
    }
}

void Event_RoundStart(Event event, const char[] name, bool dontBroadcast)
{
    for (int i = 1; i <= MaxClients; i++)
    {
        if (IsClientInGame(i) && GetClientTeam(i) == 3)
        {
            SDKUnhook(i, SDKHook_OnTakeDamageAlive, OnTakeDamageAlive);
            HookClientDamageIfTank(i);
        }
    }
}