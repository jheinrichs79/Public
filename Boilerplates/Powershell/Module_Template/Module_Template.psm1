$Public  = @(Get-ChildItem -Path "$PSScriptRoot/Public"  -Filter *.ps1 -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Path "$PSScriptRoot/Private" -Filter *.ps1 -ErrorAction SilentlyContinue)

# Collect private module folders
[string[]]$PrivateModules =
    Get-ChildItem -Path "$PSScriptRoot/Private" -Directory -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty FullName

# Dot‑source all function files
foreach ($import in $Public + $Private) {
    try {
        . $import.FullName
    }
    catch {
        Write-Error "Failed to import function $($import.FullName): $_"
    }
}

# Import nested private modules
foreach ($Module in $PrivateModules) {
    try {
        Import-Module $Module -ErrorAction Stop
    }
    catch {
        Write-Error "Failed to import module $Module`: $_"
    }
}

# Auto-export all functions defined in Public
$PublicFunctions = @()
if ($Public) {
    $PublicFunctions = foreach ($file in $Public) {
        Select-String -Path $file.FullName -Pattern '(?i)^function\s+([A-Za-z0-9_-]+)\s*\{' |
            ForEach-Object { $_.Matches.Groups[1].Value } |
            Select-Object -Unique
    }
}

if ($PublicFunctions.Count -gt 0) {
    Export-ModuleMember -Function $PublicFunctions
} else {
    Write-Verbose "No public functions found to export from $PSScriptRoot/Public"
}
