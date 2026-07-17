<#
.SYNOPSIS
Prepares the Windows-side Ubuntu 24.04 WSL2 installation step for Unit 00.

.DESCRIPTION
By default this script is read-only: it validates WSL and prints the install
command required for the target Ubuntu distribution.

Use -Install to execute the WSL installation command explicitly.
#>

[CmdletBinding()]
param(
    [string]$DistroName = "Ubuntu-24.04",
    [switch]$Install
)

$ErrorActionPreference = "Continue"
$script:Failures = 0

function Write-Check {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][ValidateSet("PASS", "WARN", "FAIL", "INFO")][string]$Status,
        [Parameter(Mandatory = $true)][string]$Detail
    )

    Write-Host "[$Status] $Name - $Detail"
    if ($Status -eq "FAIL") {
        $script:Failures++
    }
}

function Test-CommandAvailable {
    param([Parameter(Mandatory = $true)][string]$Command)
    return $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

Write-Host "Unit 00 Ubuntu WSL preparation"
Write-Host "Target distribution: $DistroName"
Write-Host ""

if (-not (Test-CommandAvailable -Command "wsl.exe")) {
    Write-Check -Name "wsl.exe" -Status "FAIL" -Detail "Command not found"
} else {
    Write-Check -Name "wsl.exe" -Status "PASS" -Detail "Command available"
}

if ($script:Failures -gt 0) {
    Write-Host ""
    Write-Host "Cannot continue until blocking failures are resolved."
    exit 1
}

Write-Host ""
Write-Host "wsl --status"
& wsl.exe --status
if ($LASTEXITCODE -ne 0) {
    Write-Check -Name "wsl --status" -Status "WARN" -Detail "Command exited with $LASTEXITCODE"
}

Write-Host ""
Write-Host "wsl --list --verbose"
$installedDistros = & wsl.exe --list --verbose
$listExitCode = $LASTEXITCODE
$installedDistros | ForEach-Object { Write-Host $_ }
if ($listExitCode -ne 0) {
    Write-Check -Name "wsl --list --verbose" -Status "WARN" -Detail "Command exited with $listExitCode"
}

$distroPattern = "^\s*\*?\s*$([regex]::Escape($DistroName))\s+"
$targetInstalled = $installedDistros | Where-Object { $_ -match $distroPattern }

if ($targetInstalled) {
    if ($targetInstalled -match "\s+2\s*$") {
        Write-Check -Name "Target distribution" -Status "PASS" -Detail "$DistroName is installed as WSL2"
        exit 0
    }

    Write-Check -Name "Target distribution" -Status "WARN" -Detail "$DistroName is installed, but WSL version is not confirmed as 2"
    Write-Host "To convert an existing distribution to WSL2, run:"
    Write-Host "wsl.exe --set-version $DistroName 2"
    exit 0
}

Write-Check -Name "Target distribution" -Status "WARN" -Detail "$DistroName is not installed"

Write-Host ""
Write-Host "Recommended install command:"
Write-Host "wsl.exe --install $DistroName"

if (-not $Install) {
    Write-Host ""
    Write-Host "Dry run complete. Re-run with -Install to execute the install command."
    exit 0
}

Write-Host ""
Write-Host "Installing $DistroName through WSL. This may require elevation, user setup, or a restart."
& wsl.exe --install $DistroName
if ($LASTEXITCODE -ne 0) {
    Write-Check -Name "wsl --install $DistroName" -Status "FAIL" -Detail "Command exited with $LASTEXITCODE"
    exit 1
}

Write-Check -Name "wsl --install $DistroName" -Status "PASS" -Detail "Command completed"
Write-Host ""
Write-Host "After first launch and user creation, validate Ubuntu with:"
Write-Host "wsl.exe -d $DistroName -- cat /etc/os-release"
exit 0
