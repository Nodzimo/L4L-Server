. "$PSScriptRoot\Paths.ps1"
$P = Get-Paths

Write-Host "Reset-Dev-Server: '$($P.Servers.L4D2)' -> '$($P.Servers.Dev)'"

if (-not (Test-Path -LiteralPath $P.Servers.L4D2)) {
    throw "Source folder not found: $($P.Servers.L4D2)"
}

if (Test-Path -LiteralPath $P.Servers.Dev) {
    Remove-Item -LiteralPath $P.Servers.Dev -Recurse -Force
}

New-Item -ItemType Directory -Path $P.Servers.Dev -Force | Out-Null
Copy-Item -Path "$($P.Servers.L4D2)\*" -Destination $P.Servers.Dev -Recurse -Force

Write-Host "Done: $($P.Servers.Dev)"