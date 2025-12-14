#if defined _L4L_LIFECYCLE_INCLUDED
    #endinput
#endif

#define _L4L_LIFECYCLE_INCLUDED

bool g_l4l_lc_enabled;

void L4L_LC_OnConfigsExecuted(bool wantEnable)
{
    L4L_ReadCvars();
    L4L_LC_ApplyEnable(wantEnable, false);
}

void L4L_LC_OnEnableChanged(bool wantEnable)
{
    L4L_LC_ApplyEnable(wantEnable, true);
}

void L4L_LC_OnCvarsChanged()
{
    L4L_ReadCvars();
}

void L4L_LC_ApplyEnable(bool wantEnable, bool reread)
{
    if (wantEnable == g_l4l_lc_enabled)
        return;

    g_l4l_lc_enabled = wantEnable;

    if (reread)
        L4L_ReadCvars();

    if (g_l4l_lc_enabled)
        L4L_Hook();
    else
        L4L_Unhook();
}
