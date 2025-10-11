# PowerShell Script to Remove "Recommended" Section from Windows 11 Start Menu
# This script modifies the registry to disable the recommended items in Start menu

# Check if running as Administrator (recommended but not required for HKCU changes)
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Warning "Running without administrator privileges. This should still work for current user settings."
}

Write-Host "Disabling 'Recommended' section in Windows 11 Start Menu..." -ForegroundColor Green

try {
    # Registry path for Start menu settings
    $registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    
    # Check if the registry path exists, create if it doesn't
    if (-not (Test-Path $registryPath)) {
        Write-Host "Creating registry path..." -ForegroundColor Yellow
        New-Item -Path $registryPath -Force | Out-Null
    }
    
    # Set the registry value to disable recommendations
    # Start_IrisRecommendations = 0 disables the recommended section
    Set-ItemProperty -Path $registryPath -Name "Start_IrisRecommendations" -Value 0 -Type DWORD
    
    Write-Host "Registry setting applied successfully!" -ForegroundColor Green
    
    # Also disable "Show recently opened items in Start, Jump Lists, and File Explorer"
    # This further reduces recommendations
    Set-ItemProperty -Path $registryPath -Name "Start_TrackDocs" -Value 0 -Type DWORD
    
    Write-Host "Additional privacy setting applied (disabled recent items tracking)." -ForegroundColor Green
    
    # Check current values to confirm
    $irisValue = Get-ItemProperty -Path $registryPath -Name "Start_IrisRecommendations" -ErrorAction SilentlyContinue
    $trackValue = Get-ItemProperty -Path $registryPath -Name "Start_TrackDocs" -ErrorAction SilentlyContinue
    
    Write-Host "`nCurrent Settings:" -ForegroundColor Cyan
    Write-Host "Start_IrisRecommendations: $($irisValue.Start_IrisRecommendations)" -ForegroundColor White
    Write-Host "Start_TrackDocs: $($trackValue.Start_TrackDocs)" -ForegroundColor White
    
    Write-Host "`n" -NoNewline
    Write-Host "SUCCESS: " -ForegroundColor Green -NoNewline
    Write-Host "The 'Recommended' section has been disabled in the Start menu."
    
    Write-Host "`nTo see the changes:" -ForegroundColor Yellow
    Write-Host "1. Sign out and sign back in, OR" -ForegroundColor White
    Write-Host "2. Restart Windows Explorer (restart your computer), OR" -ForegroundColor White
    Write-Host "3. Run the following command to restart Explorer:" -ForegroundColor White
    Write-Host "   Stop-Process -Name explorer -Force" -ForegroundColor Gray
    
    # Ask user if they want to restart Explorer now
    $restart = Read-Host "`nWould you like to restart Windows Explorer now to apply changes? (y/n)"
    
    if ($restart -eq 'y' -or $restart -eq 'Y' -or $restart -eq 'yes') {
        Write-Host "Restarting Windows Explorer..." -ForegroundColor Yellow
        Stop-Process -Name explorer -Force
        Write-Host "Windows Explorer restarted. Changes should now be visible." -ForegroundColor Green
    }
    
} catch {
    Write-Error "An error occurred while modifying the registry: $($_.Exception.Message)"
    Write-Host "Please ensure you have the necessary permissions to modify the registry." -ForegroundColor Red
}

Write-Host "`nScript completed." -ForegroundColor Cyan
