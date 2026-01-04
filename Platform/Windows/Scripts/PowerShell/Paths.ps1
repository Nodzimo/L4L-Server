function Get-Paths {
    $root = (Resolve-Path "$PSScriptRoot\..\..\..\..\..").Path

    $repos = [PSCustomObject]@{
        Server  = "$root\L4L-Server"
        Private = "$root\L4L-Private"
    }

    $windowsRoot = "$($repos.Server)\Platform\Windows"
    $serversRoot = "$windowsRoot\Servers"
    $scriptsRoot = "$windowsRoot\Scripts"

    $platform = [PSCustomObject]@{
        Windows = $windowsRoot
    }

    $servers = [PSCustomObject]@{
        Root = $serversRoot
        L4D2 = "$serversRoot\L4D2"
        Dev  = "$serversRoot\Dev"
    }

    $scripts = [PSCustomObject]@{
        Root       = $scriptsRoot
        PowerShell = "$scriptsRoot\PowerShell"
        Batch      = "$scriptsRoot\Batch"
    }

    $privateRoot = $repos.Private

    $private = [PSCustomObject]@{
        Root       = $privateRoot
        All        = "$privateRoot\01. All"
        Specific   = "$privateRoot\02. Specific"
        SmBasePath = "$privateRoot\03. sm_basepath"
    }

    return [PSCustomObject]@{
        Root     = $root
        Repos    = $repos
        Platform = $platform
        Servers  = $servers
        Scripts  = $scripts
        Private  = $private
    }
}