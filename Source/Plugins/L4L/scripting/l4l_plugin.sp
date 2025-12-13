#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>

ConVar g_Instance;

public Plugin myinfo =
{
    name        = "Left 4 Legend Plugin",
    author      = "Sefo",
    description = "L4L Plugin",
    version     = "0.1",
    url         = "L4L.su"
};

public void OnPluginStart()
{
    g_Instance = CreateConVar(
        "sm_l4l_server",
        "",
        "Server name");
}

public void OnConfigsExecuted()
{
    char id[64];
    GetConVarString(g_Instance, id, sizeof(id));
    ServerCommand("exec \"sourcemod/l4l/%s.cfg\"", id);
}