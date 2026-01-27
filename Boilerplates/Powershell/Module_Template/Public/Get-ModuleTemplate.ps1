function Get-ModuleTemplate {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ModuleName='Module_Template',

        [string]$BaseLocalFolder='C:\TEMP\ModDev',

        #By Default it will pull my Template for Powershell Module Design
        [string]$Url='https://github.com/jheinrichs79/Public/tree/main/Boilerplates/Powershell/Module_Template'

    )
    Clear-Host

    # -------------------------------
    # Validate Git is installed
    # -------------------------------
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        throw "Git is not installed or not in PATH. Install Git before using Get-GitFolder."
    }

    #Set Local Module Template Folder based off the Base Folder and the name you have given the module.
    $LocalFolder = Join-Path $BaseLocalFolder $ModuleName
    $psd1File = Join-Path $LocalFolder ($ModuleName+'.psd1')
    $psm1File = Join-Path $LocalFolder ($ModuleName+'.psm1')

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

    # -------------------------------
    # Rename files
    # -------------------------------
    $newName = "$ModuleName"

    $file = Get-ChildItem -Path $LocalFolder -File | Where-Object Name -EQ 'Module_Template.psm1'
    if ($file) {
        $newFullNamePsm1 = Join-Path $LocalFolder ($ModuleName + $file.Extension)
        Rename-Item -Path $file.FullName -NewName $newFullNamePsm1
    }
    $file = Get-ChildItem -Path $LocalFolder -File | Where-Object Name -EQ 'Module_Template.psd1'
    if ($file) {
        $newFullNamePsd1 = Join-Path $LocalFolder ($ModuleName + $file.Extension)
        Rename-Item -Path $file.FullName -NewName $newFullNamePsd1
    }


    # -------------------------------
    # Update Variables in .psd1
    # -------------------------------

    Write-Host "------------------------------------------------------------------------------------------"
    Write-Host " Now that the Module Template has been downloaded... Let's fill in the psd1 file info."
    Write-Host "    NOTE - If you enter nothing to the question, option will be blank in the file. "
    Write-Host "------------------------------------------------------------------------------------------"
    Write-Host

    $FullName = Read-Host "Please Enter Your First and Last Name"
    $CompanyName = Read-Host "Please Enter Your Company Name"
    $HelpInfoURI = Read-Host "Please Enter The Website for the Module Help or Your Own Website"
    $Description = Read-Host "Please Enter Brief Description of Module"
    $Version = Read-Host "Please Enter either 5.1 or 7 for Powershell version"
    $LICENSEURI = Read-Host "Please Enter License URI"
    $GITPROJECTURI = Read-Host "Please Enter Git Project URI"
    $ICONURI = Read-Host "Please Enter Icon URI "
    $RELEASENOTES = Read-Host "Please Enter Release Notes"

    Set-Placeholder -Path $newFullNamePsd1 -Placeholder 'VAR_ROOTMODULE' -Replacement $ModuleName
    Set-Placeholder -Path $newFullNamePsd1 -Placeholder 'VAR_PSD1GUID' -Replacement (New-Psd1Guid)
    Set-Placeholder -Path $newFullNamePsd1 -Placeholder 'VAR_AUTHOR' -Replacement $FullName
    Set-Placeholder -Path $newFullNamePsd1 -Placeholder 'VAR_COMPANYNAME' -Replacement $CompanyName
    Set-Placeholder -Path $newFullNamePsd1 -Placeholder 'VAR_HELPINFOURI' -Replacement $HelpInfoURI
    Set-Placeholder -Path $newFullNamePsd1 -Placeholder 'VAR_DESCRIPTION' -Replacement $Description
    Set-Placeholder -Path $newFullNamePsd1 -Placeholder 'VAR_PSVERSION' -Replacement $Version
    Set-Placeholder -Path $newFullNamePsd1 -Placeholder 'VAR_LICENSEURI' -Replacement $LICENSEURI
    Set-Placeholder -Path $newFullNamePsd1 -Placeholder 'VAR_GITPROJECTURI' -Replacement $GITPROJECTURI
    Set-Placeholder -Path $newFullNamePsd1 -Placeholder 'VAR_ICONURI' -Replacement $ICONURI
    Set-Placeholder -Path $newFullNamePsd1 -Placeholder 'VAR_RELEASENOTES' -Replacement $RELEASENOTES

    Write-Host
    Write-Host


}
