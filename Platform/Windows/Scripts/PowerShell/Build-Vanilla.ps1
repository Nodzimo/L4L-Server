$ErrorActionPreference = "Stop"

. "$PSScriptRoot\Paths.ps1"
. "$PSScriptRoot\Resolve-PlatformSource.ps1"
. "$PSScriptRoot\Copy-DirectoryContents.ps1"

function Build-VanillaBase {
    param(
        [Parameter(Mandatory)]
        [ValidateSet("Windows", "Linux")]
        [string]$Platform,

        [string]$ServerFolderName = "vanilla"
    )

    $paths = Get-Paths

    $serverRoot = "$($paths.Servers.Root)\$ServerFolderName"
    $serverLeft4Dead2 = "$serverRoot\left4dead2"
    $addonsRoot = "$serverLeft4Dead2\addons"

    Write-Host "[Build-VanillaBase] Platform=$Platform Server=$ServerFolderName"

    $modsSource = Resolve-PlatformSource -Source $paths.Setup.Core.Mods -Platform $Platform

    $copyPlan = @(
        @{ Source = $paths.Setup.Core.ServerConfigs; Destination = $serverRoot }
        @{ Source = $modsSource; Destination = $serverRoot }

        @{ Source = $paths.Setup.Core.PluginsConfigs; Destination = $serverRoot }
        @{ Source = $paths.Setup.Core.Addons; Destination = $serverRoot }
        @{ Source = $paths.Setup.Core.AddonsConfigs; Destination = $serverRoot }
        @{ Source = "$($paths.Setup.Core.Specific)\vanilla"; Destination = $serverRoot }

        @{ Source = $paths.Setup.Hardcore.Left4Dead2; Destination = $serverLeft4Dead2 }

        @{ Source = $paths.Private.All; Destination = $serverRoot }
        @{ Source = "$($paths.Private.Specific)\vanilla"; Destination = $serverRoot }
    )

    foreach ($step in $copyPlan) {
        Write-Host ("[Build-VanillaBase] Copy: {0} -> {1}" -f $step.Source, $step.Destination)
        Copy-DirectoryContents -Source $step.Source -Destination $step.Destination
    }

    if ($Platform -eq "Windows") {
        $windowsOnlyBasePlan = @(
            @{ Source = $paths.Setup.Shared.MapsMain; Destination = $addonsRoot }
            @{ Source = $paths.Setup.Shared.MapsWinter; Destination = $addonsRoot }
            @{ Source = $paths.Setup.Shared.MapsXmas; Destination = $addonsRoot }
        )

        foreach ($step in $windowsOnlyBasePlan) {
            Write-Host ("[Build-VanillaBase] Windows-only copy: {0} -> {1}" -f $step.Source, $step.Destination)
            Copy-DirectoryContents -Source $step.Source -Destination $step.Destination
        }
    }

    Write-Host "[Build-VanillaBase] Done"
}

function Build-VanillaInstance {
    param(
        [Parameter(Mandatory)]
        [ValidateSet("Windows", "Linux")]
        [string]$Platform,

        [Parameter(Mandatory)]
        [ValidateRange(1, 999)]
        [int]$InstanceNumber,

        [string]$ServerFolderName = "vanilla"
    )

    $paths = Get-Paths

    $serverRoot = "$($paths.Servers.Root)\$ServerFolderName"
    $addonsRoot = "$serverRoot\left4dead2\addons"

    $instanceTag = "vanilla$InstanceNumber"
    $sourceModInstanceRoot = "$addonsRoot\sourcemod_$instanceTag"

    Write-Host "[Build-VanillaInstance] Platform=$Platform Server=$ServerFolderName Instance=$instanceTag"

    $sourceModSource = Resolve-PlatformSource -Source $paths.Setup.Core.SourceMod -Platform $Platform
    $extsSource = Resolve-PlatformSource -Source $paths.Setup.Core.Exts     -Platform $Platform

    $copyPlan = @(
        @{ Source = $sourceModSource; Destination = $sourceModInstanceRoot }
        @{ Source = $extsSource; Destination = $sourceModInstanceRoot }
        @{ Source = $paths.Setup.Core.Plugins; Destination = $sourceModInstanceRoot }

        @{ Source = $paths.Setup.Hardcore.SmBasePath; Destination = $sourceModInstanceRoot }
        @{ Source = $paths.Private.SmBasePath; Destination = $sourceModInstanceRoot }
    )

    foreach ($step in $copyPlan) {
        Write-Host ("[Build-VanillaInstance] Copy: {0} -> {1}" -f $step.Source, $step.Destination)
        Copy-DirectoryContents -Source $step.Source -Destination $step.Destination
    }

    if ($Platform -eq "Windows") {
        $geoIpDestination = "$sourceModInstanceRoot\configs\geoip"
        Write-Host ("[Build-VanillaInstance] Windows-only copy: {0} -> {1}" -f $paths.Setup.Shared.GeoIP, $geoIpDestination)
        Copy-DirectoryContents -Source $paths.Setup.Shared.GeoIP -Destination $geoIpDestination
    }

    Write-Host "[Build-VanillaInstance] Done"
}

function Build-VanillaInstances {
    param(
        [Parameter(Mandatory)]
        [ValidateSet("Windows", "Linux")]
        [string]$Platform,

        [Parameter(Mandatory)]
        [ValidateRange(1, 999)]
        [int]$Count,

        [string]$ServerFolderName = "vanilla"
    )

    Build-VanillaBase -Platform $Platform -ServerFolderName $ServerFolderName

    for ($i = 1; $i -le $Count; $i++) {
        Build-VanillaInstance -Platform $Platform -ServerFolderName $ServerFolderName -InstanceNumber $i
    }
}