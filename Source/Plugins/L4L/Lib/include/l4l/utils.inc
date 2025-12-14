#include <l4l/constants>

void ExecuteCheat(int client, const char[] command, const char[] argument, int g_iCvarDebug)
{
    if (!client) return;

    if (g_iCvarDebug) PrintToChatAll("%s ExecuteCheat \x04%s \x05%s \x03%s", DEBUG_TAG, GetName(client), command, argument);

    int flags = GetCommandFlags(command);
    SetCommandFlags(command, flags & ~FCVAR_CHEAT);
    FakeClientCommand(client, "%s %s", command, argument);
    SetCommandFlags(command, flags | FCVAR_CHEAT);
}

int GetDebugMode(int arguments, int g_iCvarDebug)
{
    if (arguments == FIRST_ARGUMENT)
    {
        int mode = GetArgumentInteger();

        if (mode != g_iCvarDebug && mode >= DISABLE && mode <= DEBUG_SOUNDS) return mode;
    }

    return g_iCvarDebug ? DISABLE : ENABLE;
}

int GetSpawnCount(int arguments)
{
    if (arguments == FIRST_ARGUMENT)
    {
        int count = GetArgumentInteger();

        if (count > DEFAULT_SPAWN_COUNT && count <= MAX_SI) return count;
    }

    return DEFAULT_SPAWN_COUNT;
}

int GetEventClient(Event event)
{
    return GetClientOfUserId(event.GetInt("userid"));
}

char[] GetName(int client)
{
    char name[MAX_NAME_LENGTH];
    GetClientName(client, name, sizeof name);

    return name;
}

bool IsValidSurvivor(int client)
{
    return IsValidEntity(client) && IsClient(client) && IsSurvivor(client);
}

bool IsClient(int client)
{
    return client > CLIENT_NOT_FOUND && client <= MaxClients;
}

bool IsSurvivor(int client)
{
    return GetClientTeam(client) == TEAM_SURVIVORS;
}

int GetArgumentInteger()
{
    char argument[MAX_ARGUMENT_INTEGER_LENGTH];
    GetCmdArg(FIRST_ARGUMENT, argument, sizeof argument);

    return StringToInt(argument);
}

bool IsSurvivorBot(int client)
{
    return IsClientInGame(client) && IsFakeClient(client) && GetClientTeam(client) == 2;
}