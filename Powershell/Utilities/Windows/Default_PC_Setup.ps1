<#
-------------------------------------------------------------------------------
 New PC Setup Script
-------------------------------------------------------------------------------
 
 Creator: Jared Heinrichs
 Website: https://jaredheinrichs.substack.com/

 Use at your own Risk. If you don't recognize an application you can remove
 it from the list.
 
 Right click and run PowerShell as Administror. This will reduce the prompts
 during the installs and is needed for the last section "Setup Windows 
 Settings"
 
-------------------------------------------------------------------------------
#>

#=================================================
# Apps To Remove List
#=================================================

$RemoveApps = @(
	"Outlook for Windows",
	'Windows Notepad',
	'Microsoft 365 Copilot'
	)


#=================================================
# Apps To Install List (Both Winget and MSStore
#=================================================	

$WinGetApps = @(
	'7zip.7zip',
	'Adobe.Acrobat.Reader.64-bit',
	'Blizzard.BattleNet',
	'Bitwarden.Bitwarden',
	'Bitwarden.CLI',
	'DominikReichl.KeePass',
	'EpicGames.EpicGamesLauncher',
	'Fastfetch-cli.Fastfetch',
	'FxSound.FxSound',
	'Git.Git',
	'JanDeDobbeleer.OhMyPosh',
	'Jellyfin.JellyfinMediaPlayer',
	'Microsoft.Sysinternals.Suite',
	'Microsoft.PowerShell',
	'Microsoft.PowerToys',
	'Microsoft.VisualStudioCode',
	'NordSecurity.NordVPN',
	'Notepad++.Notepad++',
	'Plex.Plex',
	'Plex.Plexamp',
	'Valve.Steam',
	'VideoLAN.VLC'
	)

$MSStoreApps = @(
	'"Microsoft PC Manager"',
	'"Microsoft Copilot"'
	)


#=================================================
# Merge Winget and MSStore Apps  
#=================================================

$InstallApps = $WinGetApps + $MSStoreApps


#=================================================
# Remove Apps 
#=================================================

foreach ($app in $RemoveApps) {
  winget uninstall $app
}

#=================================================
# Install Apps
#=================================================

foreach ($app in $InstallApps) {
  winget install $app --accept-package-agreements --accept-source-agreements
}


#=================================================
# Setup Windows settings
# ================================================

sudo config --enable normal

#=================================================
# Install Nerd Fonts
# ================================================


$urls = @(
"https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip",
"https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraMono.zip"
)

$temp = Join-Path $env:TEMP "nerdfonts"
$fontDir = "$env:WINDIR\Fonts"

New-Item -ItemType Directory -Path $temp -Force | Out-Null

Add-Type @"
using System;
using System.Runtime.InteropServices;

public class FontUtil {
    [DllImport("gdi32.dll")]
    public static extern int AddFontResourceEx(string lpszFilename, uint fl, IntPtr pdv);
}
"@

foreach ($url in $urls) {

    $zip = Join-Path $temp (Split-Path $url -Leaf)
    $extract = Join-Path $temp ([System.IO.Path]::GetFileNameWithoutExtension($zip))

    Invoke-WebRequest $url -OutFile $zip
    Expand-Archive $zip $extract -Force

    Get-ChildItem $extract -Recurse -Include *.ttf, *.otf | ForEach-Object {

        $dest = Join-Path $fontDir $_.Name
        Copy-Item $_.FullName $dest -Force

        [FontUtil]::AddFontResourceEx($dest, 0x10, [IntPtr]::Zero) | Out-Null
    }
}

Remove-Item $temp -Recurse -Force
Write-Host "Fonts installed."

#=================================================
# Install Atomic Oh My Posh Theme
# ================================================

# Define paths
$themeDir = Join-Path $HOME ".OhMyPoshThemes"
$themeUrl = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/refs/heads/main/themes/atomic.omp.json"
$themePath = Join-Path $themeDir "atomic.omp.json"

# Create directory if missing
if (-not (Test-Path $themeDir)) {
    New-Item -ItemType Directory -Path $themeDir | Out-Null
}

# Download the theme file
Invoke-WebRequest -Uri $themeUrl -OutFile $themePath

# Mark the directory as hidden
(Get-Item $themeDir).Attributes = 'Hidden'
