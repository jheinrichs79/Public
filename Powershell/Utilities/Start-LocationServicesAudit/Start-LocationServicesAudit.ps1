
<#
    Windows 11 — Location Services audit (stable build)
    - Device policy / user toggle
    - Geolocation service (lfsvc)
    - Recent app activity: Packaged + NonPackaged (ConsentStore)
    - Options: -Dedup, -OnlyWithTimestamps, -Csv, -BlockExe
    - NEW: -ShowBrowserSites → Edge/Chrome site-level geolocation permissions
#>

param(
    [int]$SinceHours = 168,
    [switch]$Dedup,
    [switch]$OnlyWithTimestamps,
    [string]$Csv = "",
    [string]$BlockExe = "",
    [switch]$ShowBrowserSites
)

Write-Host "=== Windows 11 Location Services Audit ===" -ForegroundColor Cyan

# --- Device-level policy ---
$policyPath  = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors'
$policy      = Get-ItemProperty -Path $policyPath -Name 'DisableLocation' -ErrorAction SilentlyContinue
$policyState = if ($null -eq $policy) { 'No policy set (user can control)' } elseif ($policy.DisableLocation -eq 1) { 'Disabled by policy' } else { 'Enabled by policy' }
Write-Host ("Device Policy (DisableLocation): {0}" -f $policyState)

# --- User-level master toggle ---
$userConsentKey = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location'
$userConsent    = Get-ItemProperty -Path $userConsentKey -ErrorAction SilentlyContinue
$userValue      = if ($null -eq $userConsent) { 'Unknown (key missing)' } else { $userConsent.Value }
Write-Host ("User Location Permission (ConsentStore\location): {0}" -f $userValue)

# --- Geolocation service (lfsvc) ---
$svc       = Get-Service -Name 'lfsvc' -ErrorAction SilentlyContinue
$svcStatus = if ($svc) { $svc.Status.ToString() } else { 'Unknown' }
$svcStart  = if ($svc) { $svc.StartType.ToString() } else { 'Unknown' }
Write-Host ("Geolocation Service (lfsvc): Status={0}, StartType={1}" -f $svcStatus, $svcStart)

# --- FILETIME converter (fixed) ---
function Convert-FileTime {
    param([Nullable[Int64]]$ft)
    if ($null -ne $ft -and [int64]$ft -ne 0) {
        return [DateTime]::FromFileTimeUtc([int64]$ft)
    } else {
        return $null
    }
}

# --- Helpers ---
function Normalize-PathFromConsentStore { param([string]$s) return ($s -replace '#','\') }
function Get-FriendlyName {
    param([string]$appKey, [string]$type)
    if ($type -eq 'Packaged') {
        if ($appKey -match '^([^_]+)') { return $Matches[1] } else { return $appKey }
    } else {
        $norm = Normalize-PathFromConsentStore $appKey
        if ($norm -match '([^\\]+\.exe)$') { return $Matches[1] } else { return $appKey }
    }
}

# --- Packaged activity ---
function Get-PackagedActivity {
    $base = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location\Packaged'
    $out  = @()
    if (-not (Test-Path $base)) { return $out }
    foreach ($app in Get-ChildItem -Path $base -ErrorAction SilentlyContinue) {
        $p = Get-ItemProperty -Path $app.PSPath -ErrorAction SilentlyContinue
        $out += [PSCustomObject]@{
            Type            = 'Packaged'
            AppKey          = $app.PSChildName
            AppName         = Get-FriendlyName -appKey $app.PSChildName -type 'Packaged'
            FullPath        = $null
            ConsentValue    = $p.Value
            LastUsedUTC     = Convert-FileTime $p.LastUsedTime
            SessionStartUTC = Convert-FileTime $p.LastUsedTimeStart
            SessionStopUTC  = Convert-FileTime $p.LastUsedTimeStop
        }
    }
    return $out
}

# --- NonPackaged activity (incl. Executables subtree) ---
function Get-NonPackagedActivity {
    $base = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location\NonPackaged'
    $out  = @()
    if (-not (Test-Path $base)) { return $out }

    foreach ($k in Get-ChildItem -Path $base -ErrorAction SilentlyContinue) {
        if ($k.PSChildName -ieq 'Executables') {
            foreach ($exeKey in Get-ChildItem -Path $k.PSPath -ErrorAction SilentlyContinue) {
                $p       = Get-ItemProperty -Path $exeKey.PSPath -ErrorAction SilentlyContinue
                $appKey  = $exeKey.PSChildName
                $normKey = Normalize-PathFromConsentStore $appKey
                $out += [PSCustomObject]@{
                    Type            = 'NonPackaged'
                    AppKey          = "Executables\$appKey"
                    AppName         = Get-FriendlyName -appKey $appKey -type 'NonPackaged'
                    FullPath        = $normKey
                    ConsentValue    = $p.Value
                    LastUsedUTC     = Convert-FileTime $p.LastUsedTime
                    SessionStartUTC = Convert-FileTime $p.LastUsedTimeStart
                    SessionStopUTC  = Convert-FileTime $p.LastUsedTimeStop
                }
            }
        } else {
            $p       = Get-ItemProperty -Path $k.PSPath -ErrorAction SilentlyContinue
            $appKey  = $k.PSChildName
            $normKey = Normalize-PathFromConsentStore $appKey
            $out += [PSCustomObject]@{
                Type            = 'NonPackaged'
                AppKey          = $appKey
                AppName         = Get-FriendlyName -appKey $appKey -type 'NonPackaged'
                FullPath        = $normKey
                ConsentValue    = $p.Value
                LastUsedUTC     = Convert-FileTime $p.LastUsedTime
                SessionStartUTC = Convert-FileTime $p.LastUsedTimeStart
                SessionStopUTC  = Convert-FileTime $p.LastUsedTimeStop
            }
        }
    }
    return $out
}

# --- Gather + filter ---
$cutoff      = (Get-Date).ToUniversalTime().AddHours(-1 * $SinceHours)
$packaged    = Get-PackagedActivity
$nonPackaged = Get-NonPackagedActivity
$all         = $packaged + $nonPackaged

$all = $all | Where-Object {
    if ($OnlyWithTimestamps) {
        ($null -ne $_.LastUsedUTC -and $_.LastUsedUTC -ge $cutoff) -or
        ($null -ne $_.SessionStartUTC -and $_.SessionStartUTC -ge $cutoff)
    } else {
        ($null -ne $_.LastUsedUTC -and $_.LastUsedUTC -ge $cutoff) -or
        ($null -ne $_.SessionStartUTC -and $_.SessionStartUTC -ge $cutoff) -or
        ($null -eq $_.LastUsedUTC -and $null -eq $_.SessionStartUTC)
    }
}

if ($Dedup) {
    $all = $all |
        Sort-Object -Property @{Expression='LastUsedUTC';Descending=$true}, @{Expression='SessionStartUTC';Descending=$true} |
        Group-Object -Property AppName |
        ForEach-Object { $_.Group | Select-Object -First 1 }
}

$all = $all | Sort-Object -Property @{Expression='LastUsedUTC';Descending=$true}, @{Expression='AppName';Descending=$false}

Write-Host ("`n=== Recent App Activity (last {0} hours){1} ===" -f $SinceHours, ($OnlyWithTimestamps ? " [timestamps only]" : "")) -ForegroundColor Cyan
if ($all.Count -eq 0) {
    Write-Host "No app entries found within the selected window." -ForegroundColor Yellow
} else {
    $all | Format-Table -AutoSize Type, AppName, ConsentValue, LastUsedUTC, FullPath
}

# --- CSV export (optional) ---
if ($Csv -and $Csv.Trim().Length -gt 0) {
    $all | Export-Csv -Path $Csv -NoTypeInformation
    Write-Host ("Exported CSV: {0}" -f $Csv)
}

# --- Optional: Block a NonPackaged EXE (set Consent=Deny) ---
if ($BlockExe -and $BlockExe.Trim().Length -gt 0) {
    $targetKey = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location\NonPackaged\Executables\$BlockExe"
    if (Test-Path $targetKey) {
        Set-ItemProperty -Path $targetKey -Name 'Value' -Value 'Deny' -ErrorAction SilentlyContinue
        Write-Host ("Blocked location access for: {0}" -f $BlockExe) -ForegroundColor Green
    } else {
        Write-Host ("Not found under NonPackaged\Executables: {0}" -f $BlockExe) -ForegroundColor Yellow
    }
}

# ==============================
# Browser site permissions (Edge/Chrome)
# ==============================
function Get-ManagedDefaultGeoPolicy {
    param([string]$Browser)
    $keys = if ($Browser -eq 'Edge') {
        @('HKLM:\SOFTWARE\Policies\Microsoft\Edge','HKCU:\SOFTWARE\Policies\Microsoft\Edge')
    } else {
        @('HKLM:\SOFTWARE\Policies\Google\Chrome','HKCU:\SOFTWARE\Policies\Google\Chrome')
    }
    $vals = @()
    foreach ($k in $keys) {
        if (Test-Path $k) {
            $p = Get-ItemProperty -Path $k -ErrorAction SilentlyContinue
            if ($p.PSObject.Properties.Name -contains 'DefaultGeolocationSetting') {
                $v = $p.DefaultGeolocationSetting
                $text = switch ($v) { 1 { 'Allow' } 2 { 'Block' } default { 'Ask' } }
                $vals += [PSCustomObject]@{
                    Browser = $Browser
                    Scope   = ($k -replace '^HK.+\\SOFTWARE\\Policies\\','')
                    Policy  = 'DefaultGeolocationSetting'
                    Value   = $v
                    Meaning = $text
                }
            }
        }
    }
    return $vals
}

function Get-ChromiumGeoPermissions {
    param([string]$UserDataPath, [string]$BrowserName)

    $out = @()
    if (-not (Test-Path $UserDataPath)) { return $out }

    $profiles = Get-ChildItem -Path $UserDataPath -Directory -ErrorAction SilentlyContinue |
                Where-Object { $_.Name -match '^(Default|Profile \d+)$' }

    foreach ($prof in $profiles) {
        $prefPath = Join-Path $prof.FullName 'Preferences'
        if (-not (Test-Path $prefPath)) { continue }

        try {
            $json = Get-Content -Path $prefPath -Raw | ConvertFrom-Json -ErrorAction Stop
        } catch {
            Write-Verbose "Skipping unreadable Preferences: $prefPath ($_)"
            continue
        }

        # content_settings → exceptions → geolocation (common)
        $geoExceptions = $json.profile.content_settings.exceptions.geolocation
        if ($null -ne $geoExceptions) {
            foreach ($prop in $geoExceptions.PSObject.Properties) {
                $pattern  = $prop.Name
                $setting  = $prop.Value.setting
                $decision = switch ($setting) { 1 { 'Allow' } 2 { 'Block' } default { 'Ask' } }
                $out += [PSCustomObject]@{
                    Browser  = $BrowserName
                    Profile  = $prof.Name
                    Pattern  = $pattern
                    Decision = $decision
                    RawValue = $setting
                }
            }
        }

        # some builds: profile.site_settings.geolocation
        if ($json.profile.site_settings -and $json.profile.site_settings.geolocation) {
            foreach ($prop in $json.profile.site_settings.geolocation.PSObject.Properties) {
                $pattern  = $prop.Name
                $setting  = $prop.Value.setting
                $decision = switch ($setting) { 1 { 'Allow' } 2 { 'Block' } default { 'Ask' } }
                $out += [PSCustomObject]@{
                    Browser  = $BrowserName
                    Profile  = $prof.Name
                    Pattern  = $pattern
                    Decision = $decision
                    RawValue = $setting
                }
            }
        }
    }

    return $out | Sort-Object Browser, Profile, Pattern
}

if ($ShowBrowserSites) {
    Write-Host "`n=== Browser Site Geolocation Permissions (Edge/Chrome) ===" -ForegroundColor Cyan

    $edgePath   = Join-Path $env:LOCALAPPDATA 'Microsoft\Edge\User Data'
    $chromePath = Join-Path $env:LOCALAPPDATA 'Google\Chrome\User Data'

    $edgeSites     = Get-ChromiumGeoPermissions -UserDataPath $edgePath   -BrowserName 'Edge'
    $chromeSites   = Get-ChromiumGeoPermissions -UserDataPath $chromePath -BrowserName 'Chrome'
    $managedEdge   = Get-ManagedDefaultGeoPolicy -Browser 'Edge'
    $managedChrome = Get-ManagedDefaultGeoPolicy -Browser 'Chrome'

    if ($managedEdge.Count -gt 0 -or $managedChrome.Count -gt 0) {
        Write-Host "`n-- Managed default policies --"
        ($managedEdge + $managedChrome) | Format-Table -AutoSize Browser, Scope, Policy, Meaning, Value
    } else {
        Write-Host "(No managed default geolocation policy found in registry.)"
    }

    if ($edgeSites.Count -eq 0 -and $chromeSites.Count -eq 0) {
        Write-Host "No explicit per-site geolocation permissions found in Edge/Chrome Preferences." -ForegroundColor Yellow
        Write-Host "Tip: In each browser, check Settings → Site permissions → Location."
    } else {
        Write-Host "`n-- Per-site permissions --"
        ($edgeSites + $chromeSites) | Format-Table -AutoSize Browser, Profile, Pattern, Decision
    }
}

# --- Summary ---
Write-Host "`n=== Summary ===" -ForegroundColor Cyan
Write-Host ("Device Policy: {0}" -f $policyState)
Write-Host ("User Permission: {0}" -f $userValue)
Write-Host ("Geolocation Service: {0}, StartType={1}" -f $svcStatus, $svcStart)
