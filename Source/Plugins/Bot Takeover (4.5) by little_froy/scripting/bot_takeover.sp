#define PLUGIN_VERSION	"4.5"

#pragma semicolon 1
#pragma newdecls required
#include <sourcemod>
#include <sdktools>
#include <left4dhooks>

#define TAKEOVER_REPRINT_TYPE_CENTER    1
#define TAKEOVER_REPRINT_TYPE_HINT      2

public Plugin myinfo =
{
	name = "Bot Takeover",
	author = "little_froy",
	description = "game play",
	version = PLUGIN_VERSION,
	url = "https://forums.alliedmods.net/showthread.php?t=346637"
};

ConVar C_alright;
bool O_alright;
ConVar C_print_type;
int O_print_type;
ConVar C_print_interval;
float O_print_interval;
ConVar C_button;
int O_button;
ConVar C_skip;
bool O_skip;

bool Started;

float Reprint_time_waiting[MAXPLAYERS+1] = {-1.0, ...};
float Reprint_time_can[MAXPLAYERS+1] = {-1.0, ...};
int Last_buttons[MAXPLAYERS+1];

public void OnMapStart()
{
	Started = true;
    reset_all();
}

public void OnMapEnd()
{
    Started = false;
    reset_all();
}

int get_idled_of_bot(int bot)
{
    if(!HasEntProp(bot, Prop_Send, "m_humanSpectatorUserID"))
    {
        return -1;
    }
	return GetClientOfUserId(GetEntProp(bot, Prop_Send, "m_humanSpectatorUserID"));			
}

bool is_player_alright(int client)
{
	return !GetEntProp(client, Prop_Send, "m_isIncapacitated");
}

bool is_game_about_to_end()
{
    for(int client = 1; client <= MaxClients; client++)
    {
        if(IsClientInGame(client) && GetClientTeam(client) == 2 && IsPlayerAlive(client) && (!O_alright || is_player_alright(client)))
        {
            return false;
        }
    }
    return true;
}

bool any_free_bot()
{
    for(int client = 1; client <= MaxClients; client++)
    {
        if(IsClientInGame(client) && IsFakeClient(client) && GetClientTeam(client) == 2 && IsPlayerAlive(client) && get_idled_of_bot(client) == 0)
        {
            return true;
        }
    }
    return false;
}

void reset_player(int client)
{
    Reprint_time_can[client] = -1.0;
    Reprint_time_waiting[client] = -1.0;
}

void reset_all(bool end_msg = false)
{
    for(int client = 1; client <= MaxClients; client++)
    {
        if(IsClientInGame(client))
        {
            if(end_msg && (Reprint_time_can[client] >= 0.0 || Reprint_time_waiting[client] >= 0.0) && !IsFakeClient(client) && !IsPlayerAlive(client) && GetClientTeam(client) == 2)
            {
                if(O_print_type == TAKEOVER_REPRINT_TYPE_CENTER)
                {
                    PrintCenterText(client, "%T", "game_over_can_not", client);
                }
                else if(O_print_type == TAKEOVER_REPRINT_TYPE_HINT)
                {
                    PrintHintText(client, "%T", "game_over_can_not", client);
                }
            }
            reset_player(client);
        }
    }
}

void print_takeover_msg(int client, float& time, const char[] phrases)
{
    float now = GetGameTime();
    if(now >= time)
    {
        time = now + O_print_interval;
        if(O_print_type == TAKEOVER_REPRINT_TYPE_CENTER)
        {
            PrintCenterText(client, "%T", phrases, client);
        }
        else if(O_print_type == TAKEOVER_REPRINT_TYPE_HINT)
        {
            PrintHintText(client, "%T", phrases, client);
        }
    }
}

void show_takeover(int client, int bot)
{
    char buffer[2];
    IntToString(GetEntProp(bot, Prop_Send, "m_survivorCharacter"), buffer, sizeof(buffer));
    BfWrite msg = view_as<BfWrite>(StartMessageOne("VGUIMenu", client));
    msg.WriteString("takeover_survivor_bar");
    msg.WriteByte(true);
    msg.WriteByte(1);
    msg.WriteString("character");
    msg.WriteString(buffer);
    EndMessage();
}

int get_takeover_target(int client)
{
    int obmode = GetEntProp(client, Prop_Send, "m_iObserverMode");
    if(!(obmode == 4 || obmode == 5))
    {
        return 0;
    }
    int target = GetEntPropEnt(client, Prop_Send, "m_hObserverTarget");
    if(target != client && target > 0 && target <= MaxClients && IsClientInGame(target) && GetClientTeam(target) == 2 && IsFakeClient(target) && IsPlayerAlive(target) && get_idled_of_bot(target) == 0)
    {
        return target;
    }
    return 0;
}

public void OnPlayerRunCmdPre(int client, int buttons, int impulse, const float vel[3], const float angles[3], int weapon, int subtype, int cmdnum, int tickcount, int seed, const int mouse[2])
{
    if(Started && IsClientInGame(client) && !IsFakeClient(client) && !IsPlayerAlive(client) && GetClientTeam(client) == 2 && !is_game_about_to_end())
    {
        if(any_free_bot())
        {
            int target = get_takeover_target(client);
            if(target == 0)
            {
                Reprint_time_can[client] = -1.0;
                print_takeover_msg(client, Reprint_time_waiting[client], "waiting");
            }
            else
            {      
                if(buttons & O_button == O_button && Last_buttons[client] & O_button != O_button)
                {
                    reset_player(client);
                    if(!O_skip)
                    {
                        if(O_print_type == TAKEOVER_REPRINT_TYPE_CENTER)
                        {
                            PrintCenterText(client, "%T", "done", client);
                        }
                        else if(O_print_type == TAKEOVER_REPRINT_TYPE_HINT)
                        {
                            PrintHintText(client, "%T", "done", client);
                        }
                    }
                    ChangeClientTeam(client, 1);
                    L4D_SetHumanSpec(target, client);
                    if(O_skip)
                    {
                        L4D_TakeOverBot(client);
                    }
                    else
                    {
                        show_takeover(client, target);
                    }
                }
                else
                {
                    Reprint_time_waiting[client] = -1.0;
                    print_takeover_msg(client, Reprint_time_can[client], "can_takeover");
                }
            }
        }
        else
        {
            if(Reprint_time_can[client] >= 0.0 || Reprint_time_waiting[client] >= 0.0)
            {
                reset_player(client);
                if(O_print_type == TAKEOVER_REPRINT_TYPE_CENTER)
                {
                    PrintCenterText(client, "%T", "no_free_bot", client);
                }
                else if(O_print_type == TAKEOVER_REPRINT_TYPE_HINT)
                {
                    PrintHintText(client, "%T", "no_free_bot", client);
                }
            }
        }
    }
    Last_buttons[client] = buttons;
}

public void OnClientDisconnect_Post(int client)
{
    Last_buttons[client] = 0;
    if(!Started)
    {
        return;
    }
    reset_player(client);
}

void event_player_spawn(Event event, const char[] name, bool dontBroadcast)
{
	if(!Started)
	{
		return;
	}
	int client = GetClientOfUserId(event.GetInt("userid"));
	if(client != 0 && IsClientInGame(client))
	{
		reset_player(client);
	}
}

void event_player_team(Event event, const char[] name, bool dontBroadcast)
{
	if(!Started)
	{
		return;
	}
	int client = GetClientOfUserId(event.GetInt("userid"));
	if(client != 0 && IsClientInGame(client))
	{
		reset_player(client);
	}
}

void event_player_death(Event event, const char[] name, bool dontBroadcast)
{
	if(!Started)
	{
		return;
	}
	int client = GetClientOfUserId(event.GetInt("userid"));
	if(client != 0 && IsClientInGame(client))
	{
		reset_player(client);
	}
}

void event_round_start(Event event, const char[] name, bool dontBroadcast)
{
    Started = true;
    reset_all();
}

void event_round_end(Event event, const char[] name, bool dontBroadcast)
{
    Started = false;
    reset_all(true);
}

void event_map_transition(Event event, const char[] name, bool dontBroadcast)
{
    Started = false;
    reset_all(true);
}

void event_mission_lost(Event event, const char[] name, bool dontBroadcast)
{
    Started = false;
    reset_all(true);
}

void event_finale_vehicle_leaving(Event event, const char[] name, bool dontBroadcast)
{
    Started = false;
    reset_all(true);
}

void get_all_cvars()
{
    O_alright = C_alright.BoolValue;
    O_print_interval = C_print_interval.FloatValue;
    O_print_type = C_print_type.IntValue;
    O_button = C_button.IntValue;
    O_skip = C_skip.BoolValue;
}

void get_single_cvar(ConVar convar)
{
    if(convar == C_alright)
    {
        O_alright = C_alright.BoolValue;
    }
    else if(convar == C_print_interval)
    {
        O_print_interval = C_print_interval.FloatValue;
    }
    else if(convar == C_print_type)
    {
        O_print_type = C_print_type.IntValue;
    }
    else if(convar == C_button)
    {
        O_button = C_button.IntValue;
    }
    else if(convar == C_skip)
    {
        O_skip = C_skip.BoolValue;
    }
}

void convar_changed(ConVar convar, const char[] oldValue, const char[] newValue)
{
	get_single_cvar(convar);
}

public APLRes AskPluginLoad2(Handle plugin, bool late, char[] error, int err_max)
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
    LoadTranslations("bot_takeover.phrases");

	HookEvent("player_spawn", event_player_spawn);
	HookEvent("player_team", event_player_team);
    HookEvent("player_death", event_player_death);
    HookEvent("round_start", event_round_start);
    HookEvent("round_end", event_round_end);
	HookEvent("map_transition", event_map_transition);
	HookEvent("mission_lost", event_mission_lost);
	HookEvent("finale_vehicle_leaving", event_finale_vehicle_leaving);

    C_alright = CreateConVar("bot_takeover_alright", "1", "1 = enable, 0 = disable. required at least 1 survivor still not incapacitated to try to takeover bot?");
    C_alright.AddChangeHook(convar_changed);
    C_print_type = CreateConVar("bot_takeover_print_type", "2", "print type. 1 = center text, 2 = hint text", _, true, 1.0, true, 2.0);
    C_print_type.AddChangeHook(convar_changed);
    C_print_interval = CreateConVar("bot_takeover_print_interval", "4.0", "interval to print the same text again", _, true, 0.1);
    C_print_interval.AddChangeHook(convar_changed);
    C_button = CreateConVar("bot_takeover_button", "32", "press the button to take over bot. support combine buttons");
    C_button.AddChangeHook(convar_changed);
    C_skip = CreateConVar("bot_takeover_skip", "0", "1 = enable, 0 = disable. no longer required to manually takeover the bot after selected(use old style)?");
    C_skip.AddChangeHook(convar_changed);
    CreateConVar("bot_takeover_version", PLUGIN_VERSION, "version of Bot Takeover", FCVAR_NOTIFY | FCVAR_DONTRECORD);
    AutoExecConfig(true, "bot_takeover");
    get_all_cvars();
}
