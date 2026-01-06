#define PLUGIN_VERSION  "1.0"

#pragma semicolon 1
#pragma newdecls required
#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
	name = "Common Ragdoll Fast Extinguish",
	author = "little_froy",
	description = "game play",
	version = PLUGIN_VERSION,
	url = "https://forums.alliedmods.net/showthread.php?t=351857"
};

void event_player_death(Event event, const char[] name, bool dontBroadcast)
{
    if(event.GetInt("userid") != 0)
    {
        return;
    }
    int entity = event.GetInt("entityid");
    if(entity > 0 && IsValidEntity(entity))
    {
        char class_name[64];
        GetEntityClassname(entity, class_name, sizeof(class_name));
        if(strcmp(class_name, "infected") == 0 || strcmp(class_name, "witch") == 0)
        {
            ExtinguishEntity(entity);
            int effect = GetEntPropEnt(entity, Prop_Send, "m_hEffectEntity");
            if(effect != -1)
            {
                RemoveEntity(effect);
            }
            AcceptEntityInput(entity, "BecomeRagdoll");
        }
    }
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
    if(GetEngineVersion() != Engine_Left4Dead2)
    {
        strcopy(error, err_max, "this plugin only runs in \"Left 4 Dead 2\"");
        return APLRes_SilentFailure;
    }
    return APLRes_Success;
}

public void OnPluginStart()
{
    HookEvent("player_death", event_player_death);

    CreateConVar("common_ragdoll_fast_extinguish_version", PLUGIN_VERSION, "version of Common Ragdoll Fast Extinguish", FCVAR_NOTIFY | FCVAR_DONTRECORD);
}