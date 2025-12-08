<#
.SYNOPSIS
    Utility to toggle Windows 11 "Finish setting up your device" and related suggestions.

.DESCRIPTION
    Provides Enable/Disable functions for registry values under
    HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager.
    Includes error handling and confirmation output.

.NOTES
    Author: Jared
    Version: 1.1
#>

function Set-NotificationState {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("Enable","Disable")]
        [string]$Action
    )

    try {
        # Ensure registry path exists
        if (-not (Test-Path $RegPath)) {
            Write-Verbose "Registry path not found. Creating..."
            New-Item -Path $RegPath -Force | Out-Null
        }

        foreach ($val in $TargetValues) {
            $desired = if ($Action -eq "Enable") { 1 } else { 0 }

            try {
                Set-ItemProperty -Path $RegPath -Name $val -Value $desired -Type DWord -ErrorAction Stop
                Write-Output "[$Action] $val set to $desired"
            }
            catch {
                Write-Warning "Failed to set ${val}: $_"
            }
        }

        Write-Output "Notifications have been $Action`d successfully."
    }
    catch {
        Write-Error "Unexpected error: $_"
    }
}

function Show-NotificationState {
    try {
        foreach ($val in $TargetValues) {
            $current = Get-ItemProperty -Path $RegPath -Name $val -ErrorAction SilentlyContinue
            if ($null -ne $current) {
                Write-Output "$val = $($current.$val)"
            } else {
                Write-Output "$val not found"
            }
        }
    }
    catch {
        Write-Error "Unable to read registry values: $_"
    }
}

# Registry path -----------------------------------------------------------------------
$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"

# Values to manage  -------------------------------------------------------------------
$TargetValues = @(
    "SubscribedContent-310093Enabled", # Setup nag
    "SubscribedContent-338388Enabled", # Tips & suggestions
    "SubscribedContent-353694Enabled", # Welcome experience
    "SubscribedContent-353696Enabled", # Suggested content in Settings
    "SystemPaneSuggestionsEnabled",    # Start Menu suggestions
    "SubscribedContent-338389Enabled", # Promotional suggestions
    "ContentDeliveryAllowed",          # Master content delivery switch
    "SoftLandingEnabled"               # Onboarding prompts
)

Clear-Host

<# Show the states of the settings #>
Show-NotificationState
Write-Host ""

<# Disable settings #>
Set-NotificationState -Action Disable
Write-Host ""

<# Show the states of the settings #>
Show-NotificationState
Write-Host ""
Write-Host ""

Write-Host "Please reboot for these settings to be applied to your personal profile."
Write-Host ""
Pause
