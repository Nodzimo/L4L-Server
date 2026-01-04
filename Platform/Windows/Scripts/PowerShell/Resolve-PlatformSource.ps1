function Resolve-PlatformSource {
    param(
        [Parameter(Mandatory)][string]$Source,
        [Parameter(Mandatory)]
        [ValidateSet("Windows", "Linux")]
        [string]$Platform
    )

    if (-not (Test-Path -LiteralPath $Source)) {
        throw "Source not found: $Source"
    }

    $windowsCandidate = "$Source\Windows"
    $linuxCandidate = "$Source\Linux"

    $hasWindows = Test-Path -LiteralPath $windowsCandidate
    $hasLinux = Test-Path -LiteralPath $linuxCandidate

    if ($hasWindows -or $hasLinux) {
        $platformSource = "$Source\$Platform"

        if (-not (Test-Path -LiteralPath $platformSource)) {
            throw "Platform folder '$Platform' not found under: $Source"
        }
        
        return $platformSource
    }

    return $Source
}