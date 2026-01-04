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

    $setupRoot = "$($repos.Server)\Setup"
    
    $coreRoot = "$setupRoot\01. Core"
    $sharedRoot = "$setupRoot\02. Shared"
    $hardcoreRoot = "$setupRoot\03. Hardcore"
    $seasonRoot = "$setupRoot\04. Season"

    $mapsRoot = "$sharedRoot\maps"
    $xmasRoot = "$seasonRoot\Xmas"

    $setup = [PSCustomObject]@{
        Root     = $setupRoot

        Core     = [PSCustomObject]@{
            Root           = $coreRoot
            ServerConfigs  = "$coreRoot\01. Server configs"
            Mods           = "$coreRoot\02. Mods"
            SourceMod      = "$coreRoot\03. SourceMod"
            Exts           = "$coreRoot\04. Exts"
            Plugins        = "$coreRoot\05. Plugins"
            PluginsConfigs = "$coreRoot\06. Plugins configs"
            Addons         = "$coreRoot\07. Addons"
            AddonsConfigs  = "$coreRoot\08. Addons configs"
            Specific       = "$coreRoot\09. Specific"
        }

        Shared   = [PSCustomObject]@{
            Root       = $sharedRoot
            GeoIP      = "$sharedRoot\geoip"
            Maps       = $mapsRoot
            MapsLab    = "$mapsRoot\lab"
            MapsMain   = "$mapsRoot\main"
            MapsSecond = "$mapsRoot\second"
            MapsWinter = "$mapsRoot\winter"
            MapsXmas   = "$mapsRoot\xmas"
        }

        Hardcore = [PSCustomObject]@{
            Root       = $hardcoreRoot
            Left4Dead2 = "$hardcoreRoot\left4dead2"
            SmBasePath = "$hardcoreRoot\sm_basepath"
        }

        Season   = [PSCustomObject]@{
            Root = $seasonRoot

            Xmas = [PSCustomObject]@{
                Root       = $xmasRoot
                Left4Dead2 = "$xmasRoot\left4dead2"
                SmBasePath = "$xmasRoot\sm_basepath"
            }
        }
    }

    return [PSCustomObject]@{
        Root     = $root
        Repos    = $repos
        Platform = $platform
        Servers  = $servers
        Scripts  = $scripts
        Private  = $private
        Setup    = $setup
    }
}