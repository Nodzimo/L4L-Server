$ErrorActionPreference = "Stop"

. "$PSScriptRoot\Paths.ps1"
. "$PSScriptRoot\Resolve-PlatformSource.ps1"
. "$PSScriptRoot\Copy-DirectoryContents.ps1"

function Build-ServerBase {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet("Windows", "Linux")]
        [string]$Platform,

        [Parameter(Mandatory)]
        [string]$BuildName, # Для Specific-слоёв

        [Parameter(Mandatory)]
        [string]$ServerFolderName
    )

    $paths = Get-Paths
    $server = Get-ServerPaths -ServerFolderName $ServerFolderName

    Write-Host "[Build-ServerBase] Platform=$Platform BuildName=$BuildName ServerFolder=$ServerFolderName"

    $modsSource = Resolve-PlatformSource -Source $paths.Setup.Core.Mods -Platform $Platform

    $setupSpecific = Get-SetupSpecificPath   -BuildName $BuildName
    $privateSpecific = Get-PrivateSpecificPath -BuildName $BuildName

    $copyPlan = @(
        @{ Source = $paths.Setup.Core.ServerConfigs; Destination = $server.Root }
        @{ Source = $modsSource; Destination = $server.Root }

        @{ Source = $paths.Setup.Core.PluginsConfigs; Destination = $server.Root }
        @{ Source = $paths.Setup.Core.Addons; Destination = $server.Root }
        @{ Source = $paths.Setup.Core.AddonsConfigs; Destination = $server.Root }
        @{ Source = $setupSpecific; Destination = $server.Root }

        @{ Source = $paths.Private.Setup.All; Destination = $server.Root }
        @{ Source = $privateSpecific; Destination = $server.Root }
    )

    foreach ($step in $copyPlan) {
        Write-Host ("[Build-ServerBase] Copy: {0} -> {1}" -f $step.Source, $step.Destination)
        Copy-DirectoryContents -Source $step.Source -Destination $step.Destination
    }

    Write-Host "[Build-ServerBase] Done"
}

function Build-ServerInstance {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet("Windows", "Linux")]
        [string]$Platform,

        [Parameter(Mandatory)]
        [string]$ServerFolderName,

        [Parameter(Mandatory)]
        [string]$InstanceTag,

        [switch]$IncludeHardcore,
        [switch]$IncludeXmas
    )

    $paths = Get-Paths
    $server = Get-ServerPaths -ServerFolderName $ServerFolderName
    $instance = Get-ServerInstancePaths -ServerFolderName $ServerFolderName -InstanceTag $InstanceTag

    Write-Host "[Build-ServerInstance] Platform=$Platform ServerFolder=$ServerFolderName InstanceTag=$InstanceTag Hardcore=$IncludeHardcore Xmas=$IncludeXmas"

    $sourceModSource = Resolve-PlatformSource -Source $paths.Setup.Core.SourceMod -Platform $Platform
    $extsSource = Resolve-PlatformSource -Source $paths.Setup.Core.Exts     -Platform $Platform

    $copyPlan = @(
        @{ Source = $sourceModSource; Destination = $instance.SourceModInstanceRoot }
        @{ Source = $extsSource; Destination = $instance.SourceModInstanceRoot }
        @{ Source = $paths.Setup.Core.Plugins; Destination = $instance.SourceModInstanceRoot }

        @{ Source = $paths.Private.Setup.SmBasePath; Destination = $instance.SourceModInstanceRoot }
    )

    foreach ($step in $copyPlan) {
        Write-Host ("[Build-ServerInstance] Copy: {0} -> {1}" -f $step.Source, $step.Destination)
        Copy-DirectoryContents -Source $step.Source -Destination $step.Destination
    }

    if ($Platform -eq "Windows") {
        Write-Host ("[Build-ServerInstance] Windows-only GeoIP: {0} -> {1}" -f $paths.Setup.Shared.GeoIP, $instance.GeoIP)
        Copy-DirectoryContents -Source $paths.Setup.Shared.GeoIP -Destination $instance.GeoIP
    }

    if ($IncludeHardcore) {
        Write-Host ("[Build-ServerInstance] Hardcore L4D2: {0} -> {1}" -f $paths.Setup.Hardcore.Left4Dead2, $server.Left4Dead2)
        Copy-DirectoryContents -Source $paths.Setup.Hardcore.Left4Dead2 -Destination $server.Left4Dead2

        Write-Host ("[Build-ServerInstance] Hardcore SmBasePath: {0} -> {1}" -f $paths.Setup.Hardcore.SmBasePath, $instance.SourceModInstanceRoot)
        Copy-DirectoryContents -Source $paths.Setup.Hardcore.SmBasePath -Destination $instance.SourceModInstanceRoot
    }

    if ($IncludeXmas) {
        Write-Host ("[Build-ServerInstance] Xmas L4D2: {0} -> {1}" -f $paths.Setup.Season.Xmas.Left4Dead2, $server.Left4Dead2)
        Copy-DirectoryContents -Source $paths.Setup.Season.Xmas.Left4Dead2 -Destination $server.Left4Dead2

        Write-Host ("[Build-ServerInstance] Xmas SmBasePath: {0} -> {1}" -f $paths.Setup.Season.Xmas.SmBasePath, $instance.SourceModInstanceRoot)
        Copy-DirectoryContents -Source $paths.Setup.Season.Xmas.SmBasePath -Destination $instance.SourceModInstanceRoot
    }

    Write-Host "[Build-ServerInstance] Done"
}

function Build-Server {
    [CmdletBinding(DefaultParameterSetName = "Tags")]
    param(
        [Parameter(Mandatory)]
        [ValidateSet("Windows", "Linux")]
        [string]$Platform,

        [Parameter(Mandatory)]
        [string]$BuildName,

        [Parameter(Mandatory)]
        [string]$ServerFolderName,

        # Режим 1: явно переданные теги (точечно/гибко)
        [Parameter(Mandatory, ParameterSetName = "Tags")]
        [string[]]$InstanceTags,

        # Режим 2: базовый тег + номера (универсальное инстанцирование для ЛЮБОЙ сборки)
        [Parameter(Mandatory, ParameterSetName = "BaseAndNumbers")]
        [string]$InstanceBaseTag,

        [Parameter(Mandatory, ParameterSetName = "BaseAndNumbers")]
        [ValidateRange(1, 999)]
        [int[]]$InstanceNumbers,

        [switch]$IncludeHardcore,
        [switch]$IncludeXmas
    )

    if ($PSCmdlet.ParameterSetName -eq "BaseAndNumbers") {
        $InstanceTags = $InstanceNumbers | ForEach-Object { "$InstanceBaseTag$_" }
    }

    Build-ServerBase -Platform $Platform -BuildName $BuildName -ServerFolderName $ServerFolderName

    foreach ($tag in $InstanceTags) {
        Build-ServerInstance `
            -Platform $Platform `
            -ServerFolderName $ServerFolderName `
            -InstanceTag $tag `
            -IncludeHardcore:$IncludeHardcore `
            -IncludeXmas:$IncludeXmas
    }
}