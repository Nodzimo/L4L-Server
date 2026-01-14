#pragma semicolon 1
#pragma newdecls required

#include <l4l/utils>
#include <multicolors>
#include <sdktools>

#define PLUGIN_VERSION "0.0.1"

public Plugin myinfo =
{
    name    = "L4L: Tools",
    author  = "Sefo",
    version = PLUGIN_VERSION,
    url     = "Sefo.su"
};

public void OnPluginStart()
{
    LoadTranslations("l4l_tools.phrases");

    RegConsoleCmd("l4l_stats", CommandPrintStats, "Show campaign stats in chat");
    RegConsoleCmd("l4l_time", CommandPrintStats, "Show campaign stats in chat");
    RegConsoleCmd("l4l_restarts", CommandPrintStats, "Show campaign stats in chat");

    RegAdminCmd("l4l_crash", CommandCrashServer, ADMFLAG_ROOT, "Crash server for test (example: check uploading Accelerator crash reports)");

    RegAdminCmd("l4l_restart", CommandRestart, ADMFLAG_ROOT, "Kill all alive survivors (players and bots)");
    RegAdminCmd("l4l_wipe", CommandRestart, ADMFLAG_ROOT, "Kill all alive survivors (players and bots)");
    RegAdminCmd("l4l_slay", CommandRestart, ADMFLAG_ROOT, "Kill all alive survivors (players and bots)");
    RegAdminCmd("l4l_kill", CommandRestart, ADMFLAG_ROOT, "Kill all alive survivors (players and bots)");
}

Action CommandPrintStats(int client, int arguments)
{
    PrintStats();

    return Plugin_Handled;
}

void PrintStats()
{
    int ent = -1, maxents = GetMaxEntities();

    for (int i = MaxClients + 1; i <= maxents; i++)
    {
        if (IsValidEntity(i))
        {
            char netclass[64];
            GetEntityNetClass(i, netclass, sizeof(netclass));

            if (StrEqual(netclass, "CTerrorPlayerResource"))
            {
                ent = i;

                break;
            }
        }
    }

    if (ent > -1)
    {
        int  duration = GetEntProp(ent, Prop_Send, "m_missionDuration");

        char timeStr[32];
        FormatMissionTime(duration, timeStr, sizeof(timeStr));

        CPrintToChatAll("%t%s", "Mission duration", timeStr);
        CPrintToChatAll("%t%d", "Mission wipes", GetEntProp(ent, Prop_Send, "m_missionWipes"));
    }
}

Action CommandCrashServer(int client, int arguments)
{
    PrintToChatAll("%s CommandCrashServer \x04%s", DEBUG_TAG, GetName(client));
    LogError("CommandCrashServer %s", GetName(client));
    SetCommandFlags(CRASH_COMMAND, GetCommandFlags(CRASH_COMMAND) & ~FCVAR_CHEAT);
    ServerCommand(CRASH_COMMAND);

    return Plugin_Handled;
}

Action CommandRestart(int client, int arguments)
{
    for (int i = 1; i <= MaxClients; i++)
    {
        if (!IsClientInGame(i) || !IsPlayerAlive(i))
        {
            continue;
        }

        if (!IsSurvivor)
        {
            continue;
        }

        ForcePlayerSuicide(i);
    }

    return Plugin_Handled;
}

// seconds -> "M:SS" if < 1h, else "H:MM:SS"
void FormatMissionTime(int totalSeconds, char[] buffer, int maxlen)
{
    if (totalSeconds < 0)
    {
        totalSeconds = 0;
    }

    int hours = totalSeconds / 3600;
    int mins  = (totalSeconds % 3600) / 60;
    int secs  = totalSeconds % 60;

    if (hours > 0)
    {
        // H:MM:SS
        Format(buffer, maxlen, "%d:%02d:%02d", hours, mins, secs);
    }
    else
    {
        // M:SS
        int totalMins = totalSeconds / 60;
        Format(buffer, maxlen, "%d:%02d", totalMins, secs);
    }
}