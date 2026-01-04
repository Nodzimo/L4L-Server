function Get-Paths {
    $root = (Resolve-Path "$PSScriptRoot\..\..\..\..\..").Path

    $repos = [PSCustomObject]@{
        Server  = "$root\L4L-Server"
        Private = "$root\L4L-Private"
    }

    $platform = [PSCustomObject]@{
        Windows = "$($repos.Server)\Platform\Windows"
    }

    $servers = [PSCustomObject]@{
        Root = "$($platform.Windows)\Servers"
        L4D2 = "$($platform.Windows)\Servers\L4D2"
        Dev  = "$($platform.Windows)\Servers\Dev"
    }

    $scripts = [PSCustomObject]@{
        Root       = "$($platform.Windows)\Scripts"
        PowerShell = "$($platform.Windows)\Scripts\PowerShell"
        Batch      = "$($platform.Windows)\Scripts\Batch"
    }

    return [PSCustomObject]@{
        Root     = $root
        Repos    = $repos
        Platform = $platform
        Servers  = $servers
        Scripts  = $scripts
    }
}