function Get-ModuleTemplate {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ModuleName='Module_Template',

        [string]$BaseLocalFolder='C:\TEMP\ModDev',

        #By Default it will pull my Template for Powershell Module Design
        [string]$Url='https://github.com/jheinrichs79/Public/tree/main/Boilerplates/Powershell/Module_Template'

    )

    # -------------------------------
    # Validate Git is installed
    # -------------------------------
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        throw "Git is not installed or not in PATH. Install Git before using Get-GitFolder."
    }

    #Set Local Module Template Folder based off the Base Folder and the name you have given the module.
    $LocalFolder = Join-Path $BaseLocalFolder $ModuleName

    # -------------------------------
    # Parse GitHub URL
    # Expected format:
    # https://github.com/<user>/<repo>/tree/<branch>/<folder>
    # -------------------------------
    if ($Url -notmatch "github\.com\/([^\/]+)\/([^\/]+)\/tree\/([^\/]+)\/(.+)$") {
        throw "Invalid GitHub folder URL. Expected format: https://github.com/<user>/<repo>/tree/<branch>/<folder>"
    }

    $User   = $Matches[1]
    $Repo   = $Matches[2]
    $Branch = $Matches[3]
    $Folder = $Matches[4]

    Write-Host
    Write-Host "---------------------------------------------------------------------------------------"
    Write-Host "User:        $User"
    Write-Host "Repo:        $Repo"
    Write-Host "Branch:      $Branch"
    Write-Host "Folder:      $Folder"
    Write-Host "LocalFolder: $LocalFolder"
    Write-Host "---------------------------------------------------------------------------------------"
    Write-Host
    Write-Host

    # -------------------------------
    # Prepare temp paths
    # -------------------------------
    $TempRoot = Join-Path $env:TEMP ("GitFolder_" + [guid]::NewGuid().ToString())
    $ClonePath = Join-Path $TempRoot $Repo

    New-Item -ItemType Directory -Path $TempRoot | Out-Null

    # -------------------------------
    # Clone repo without checkout
    # -------------------------------
    Write-Host "Cloning repository (no checkout)..." -ForegroundColor Yellow
    git clone --no-checkout "https://github.com/$User/$Repo.git" $ClonePath | Out-Null

    # -------------------------------
    # Perform sparse checkout
    # -------------------------------
    Write-Host
    Write-Host "Configuring sparse checkout..." -ForegroundColor Yellow
    Push-Location $ClonePath

    git sparse-checkout init --cone | Out-Null
    git sparse-checkout set $Folder | Out-Null

    Write-Host "Checking out branch '$Branch'..."
    git checkout $Branch | Out-Null

    Pop-Location

    # -------------------------------
    # Copy folder to destination
    # -------------------------------
    $SourcePath = Join-Path $ClonePath $Folder

    if (-not (Test-Path $SourcePath)) {
        Remove-Item $TempRoot -Recurse -Force
        throw "Folder '$Folder' not found in repository."
    }

    if (-not (Test-Path $LocalFolder)) {
        New-Item -ItemType Directory -Path $LocalFolder | Out-Null
    }

    Write-Host
    Write-Host "Created Module Folder" -ForegroundColor Green
    Write-Host "   $LocalFolder"
    Copy-Item -Path $SourcePath\* -Destination $LocalFolder -Recurse -Force

    # -------------------------------
    # Cleanup
    # -------------------------------
    Write-Host
    Write-Host "Cleaning up temporary files..." -ForegroundColor Green
    Write-Host "   TEMP_ROOT_PATH = $TempRoot"
    Remove-Item $TempRoot -Recurse -Force

    Write-Host
    Write-Host "Module Template Can Be Found here:" -ForegroundColor Green
    Write-Host "   $LocalFolder"
    Write-Host
    Write-Host
}
