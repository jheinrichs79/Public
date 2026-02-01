# Module vars
$ModulePath = $PSScriptRoot

# Collect public and private function files
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
$PublicFunctions = foreach ($file in $Public) {
    Select-String -Path $file.FullName -Pattern 'function\s+([A-Za-z0-9_-]+)' |
        ForEach-Object { $_.Matches.Groups[1].Value }
}

Export-ModuleMember -Function $PublicFunctions
