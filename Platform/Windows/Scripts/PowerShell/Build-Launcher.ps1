$ErrorActionPreference = "Stop"

function Menu([string]$title, [string[]]$items, [int]$default = 1) {
    Write-Host ""
    Write-Host $title
    for ($i = 0; $i -lt $items.Count; $i++) {
        $n = $i + 1
        Write-Host ("  {0}) {1}" -f $n, $items[$i])
    }
    $raw = Read-Host ("Select [{0}]" -f $default)
    if ([string]::IsNullOrWhiteSpace($raw)) { return $default }
    return [int]$raw
}

function Ask([string]$prompt, [string]$default) {
    $raw = Read-Host ("{0} [{1}]" -f $prompt, $default)
    if ([string]::IsNullOrWhiteSpace($raw)) { return $default }
    return $raw
}

function AskYN([string]$prompt, [bool]$defaultYes) {
    $def = if ($defaultYes) { "Y" } else { "N" }
    $raw = Read-Host ("{0} (Y/N) [{1}]" -f $prompt, $def)
    if ([string]::IsNullOrWhiteSpace($raw)) { return $defaultYes }
    return $raw.Trim().ToLowerInvariant().StartsWith("y")
}

function Run([hashtable]$p) {
    Write-Host ""
    Write-Host "Summary"
    Write-Host ("Platform:         {0}" -f $p.Platform)
    Write-Host ("BuildName:         {0}" -f $p.BuildName)
    Write-Host ("ServerFolderName:  {0}" -f $p.ServerFolderName)

    if ($p.ContainsKey("InstanceTags")) {
        Write-Host ("InstanceTags:      {0}" -f ($p.InstanceTags -join ", "))
    }
    else {
        Write-Host ("InstanceBaseTag:   {0}" -f $p.InstanceBaseTag)
        Write-Host ("InstanceNumbers:   {0}" -f ($p.InstanceNumbers -join ", "))
    }

    Write-Host ("Hardcore:          {0}" -f $p.IncludeHardcore)
    Write-Host ("Xmas:              {0}" -f $p.IncludeXmas)
    Write-Host ""

    if (-not (AskYN "Run now?" $true)) {
        Write-Host "Canceled."
        return
    }

    Build-Server @p
    Write-Host ""
    Write-Host "[OK] Build completed."
}

$exitCode = 0

try {
    $buildServerScript = Join-Path $PSScriptRoot "Build-Server.ps1"
    . $buildServerScript

    Write-Host ""
    Write-Host "L4L: Build Server"
    Write-Host "Enter = default"
    Write-Host "Tags are WITHOUT 'sourcemod_' prefix"
    Write-Host ""

    $mode = Menu "Build menu" @(
        "Presets",
        "Custom wizard"
    ) 1

    if ($mode -eq 1) {
        $p = Menu "Presets" @(
            "Dev     | Windows | Instances: dev         | Hardcore | Season: Xmas",
            "Test    | Linux   | Instances: test        | Hardcore | Season: Xmas",
            "Vanilla | Linux   | Instances: vanilla1..5 | Hardcore",
            "LMBX    | Linux   | Instances: lmbx"
        ) 1

        switch ($p) {
            1 {
                Run @{
                    Platform         = "Windows"
                    BuildName        = "dev"
                    ServerFolderName = "dev"
                    InstanceTags     = @("dev")
                    IncludeHardcore  = $true
                    IncludeXmas      = $true
                }
            }
            2 {
                Run @{
                    Platform         = "Linux"
                    BuildName        = "test"
                    ServerFolderName = "test"
                    InstanceTags     = @("test")
                    IncludeHardcore  = $true
                    IncludeXmas      = $true
                }
            }
            3 {
                Run @{
                    Platform         = "Linux"
                    BuildName        = "vanilla"
                    ServerFolderName = "vanilla"
                    InstanceBaseTag  = "vanilla"
                    InstanceNumbers  = @(1..5)
                    IncludeHardcore  = $true
                    IncludeXmas      = $false
                }
            }
            4 {
                Run @{
                    Platform         = "Linux"
                    BuildName        = "lmbx"
                    ServerFolderName = "lmbx"
                    InstanceTags     = @("lmbx")
                    IncludeHardcore  = $false
                    IncludeXmas      = $false
                }
            }
        }

        return
    }

    # Wizard
    $plat = Menu "Platform" @("Windows", "Linux") 1
    $Platform = if ($plat -eq 2) { "Linux" } else { "Windows" }

    $BuildName = Ask "BuildName" "dev"
    $ServerFolderName = Ask "ServerFolderName" $BuildName

    $inst = Menu "Instance mode" @(
        "Single (one instance tag)",
        "Multi (base tag + count)"
    ) 1

    $IncludeHardcore = AskYN "Include Hardcore?" $true
    $IncludeXmas = AskYN "Include season Xmas?" $false

    if ($inst -eq 1) {
        $tag = Ask "InstanceTag (suffix)" $BuildName

        Run @{
            Platform         = $Platform
            BuildName        = $BuildName
            ServerFolderName = $ServerFolderName
            InstanceTags     = @($tag)
            IncludeHardcore  = $IncludeHardcore
            IncludeXmas      = $IncludeXmas
        }

        return
    }

    # Multi: base + count -> generate 1..count
    $base = Ask "InstanceBaseTag (suffix)" $BuildName
    $count = [int](Ask "InstanceCount" "1")
    $nums = @(1..$count)

    Run @{
        Platform         = $Platform
        BuildName        = $BuildName
        ServerFolderName = $ServerFolderName
        InstanceBaseTag  = $base
        InstanceNumbers  = $nums
        IncludeHardcore  = $IncludeHardcore
        IncludeXmas      = $IncludeXmas
    }
}
catch {
    $exitCode = 1
    Write-Host ""
    Write-Host ("[ERROR] " + $_.Exception.Message) -ForegroundColor Red
    Write-Host ""
}
finally {
    Read-Host "Press Enter to exit" | Out-Null
    exit $exitCode
}