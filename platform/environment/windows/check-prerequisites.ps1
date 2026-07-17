<#
.SYNOPSIS
Validates Windows-side prerequisites for Unit 00.

.DESCRIPTION
This script is read-only. It reports Windows, virtualization, WSL and disk
signals needed before preparing Ubuntu, MicroK8s and kubectl.
#>

[CmdletBinding()]
param()

$ErrorActionPreference = "Continue"

$script:Failures = 0

function Write-Check {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][ValidateSet("PASS", "WARN", "FAIL", "INFO")][string]$Status,
        [Parameter(Mandatory = $true)][string]$Detail
    )

    $prefix = "[$Status]"
    Write-Host "$prefix $Name - $Detail"
    if ($Status -eq "FAIL") {
        $script:Failures++
    }
}

function Test-CommandAvailable {
    param([Parameter(Mandatory = $true)][string]$Command)
    return $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

Write-Host "Unit 00 Windows prerequisite check"
Write-Host "This script is read-only and does not modify the host."
Write-Host ""

try {
    $os = Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop
    $caption = $os.Caption
    $version = $os.Version
    $build = [int]$os.BuildNumber

    if ($caption -like "*Windows 11*") {
        Write-Check -Name "Windows edition" -Status "PASS" -Detail "$caption build $build ($version)"
    } else {
        Write-Check -Name "Windows edition" -Status "WARN" -Detail "$caption build $build ($version); Unit 00 targets Windows 11"
    }
} catch {
    Write-Check -Name "Windows edition" -Status "WARN" -Detail "Unable to query Win32_OperatingSystem: $($_.Exception.Message)"
}

try {
    $computer = Get-CimInstance -ClassName Win32_ComputerSystem -ErrorAction Stop
    if ($computer.HypervisorPresent) {
        Write-Check -Name "Hypervisor" -Status "PASS" -Detail "Hypervisor is present"
    } else {
        Write-Check -Name "Hypervisor" -Status "WARN" -Detail "Hypervisor not reported; WSL2 may require virtualization to be enabled"
    }
} catch {
    Write-Check -Name "Hypervisor" -Status "WARN" -Detail "Unable to query hypervisor state: $($_.Exception.Message)"
}

foreach ($featureName in @("Microsoft-Windows-Subsystem-Linux", "VirtualMachinePlatform")) {
    try {
        $feature = Get-WindowsOptionalFeature -Online -FeatureName $featureName -ErrorAction Stop
        if ($feature.State -eq "Enabled") {
            Write-Check -Name "Windows feature $featureName" -Status "PASS" -Detail "Enabled"
        } else {
            Write-Check -Name "Windows feature $featureName" -Status "WARN" -Detail "State is $($feature.State)"
        }
    } catch {
        Write-Check -Name "Windows feature $featureName" -Status "WARN" -Detail "Unable to query feature: $($_.Exception.Message)"
    }
}

if (Test-CommandAvailable -Command "wsl.exe") {
    Write-Check -Name "wsl.exe" -Status "PASS" -Detail "Command available"

    Write-Host ""
    Write-Host "wsl --status"
    & wsl.exe --status
    if ($LASTEXITCODE -ne 0) {
        Write-Check -Name "wsl --status" -Status "WARN" -Detail "Command exited with $LASTEXITCODE"
    }

    Write-Host ""
    Write-Host "wsl --list --verbose"
    & wsl.exe --list --verbose
    if ($LASTEXITCODE -ne 0) {
        Write-Check -Name "wsl --list --verbose" -Status "WARN" -Detail "Command exited with $LASTEXITCODE"
    }
} else {
    Write-Check -Name "wsl.exe" -Status "FAIL" -Detail "Command not found"
}

try {
    $systemDriveName = if ($env:SystemDrive) {
        $env:SystemDrive.TrimEnd(":")
    } else {
        (Get-Location).Drive.Name
    }

    $systemDrive = Get-PSDrive -Name $systemDriveName -ErrorAction Stop
    $freeGb = [math]::Round($systemDrive.Free / 1GB, 2)
    if ($freeGb -ge 30) {
        Write-Check -Name "System drive free space" -Status "PASS" -Detail "$freeGb GB free"
    } else {
        Write-Check -Name "System drive free space" -Status "WARN" -Detail "$freeGb GB free; review before installing WSL and MicroK8s"
    }
} catch {
    Write-Check -Name "System drive free space" -Status "WARN" -Detail "Unable to check free space: $($_.Exception.Message)"
}

Write-Host ""
if ($script:Failures -gt 0) {
    Write-Host "Completed with $script:Failures blocking failure(s)."
    exit 1
}

Write-Host "Completed without blocking failures. Review WARN entries before continuing."
exit 0
