function Test-Folders {
    [CmdletBinding()]
    param (
        $ArrayTeamsFolders
    )
    
    begin {
        $FoldersThatExist = @()
    }
    
    process {
        foreach ($Folder in $ArrayTeamsFolders) {
            if (Test-Path -Path $Folder -PathType Container) {
                $FoldersThatExist += $Folder
            }
        } 
    }
    
    end {
        return $FoldersThatExist
    }
}
function Start-TeamsLoginReset {
    [CmdletBinding()]
   
    begin {
        $RoamingProfile = $env:APPDATA
        $LocalProfile = $env:LOCALAPPDATA
        $ArrayTeamsFolders = @(
            "$RoamingProfile\Microsoft\Teams", 
            "$LocalProfile\Microsoft\Teams",
            "$LocalProfile\Packages\MSTeams_8wekyb3d8bbwe",
            "$LocalProfile\Packages\Microsoft.AAD.BrokerPlugin_cw5n1h2txyewy",
            "$LocalProfile\Microsoft\OneAuth",
            "$LocalProfile\Microsoft\TokenBroker",
            "$LocalProfile\Microsoft\IdentityCache"
        )
        $FoldersThatExist = Test-Folders -ArrayTeamsFolders $ArrayTeamsFolders
    }
    
    process {
        clear-host
        Write-Output "Teams Login Reset"
        Write-Output "------------------"    
        Write-Output "Here are the folders that exist:"
        foreach ($Folder in $FoldersThatExist) {
            Write-Output $Folder
        }
        Write-Output "Teams needs to be closed before removing these folders."
        Write-Output ""
        $answer = Read-Host "Would you like to remove these folders?(yes/no)"
        if ($answer -like "y*") {
            foreach ($Folder in $FoldersThatExist) {
                Remove-Item -Path $Folder -Recurse -Force
            }
        }
        else {
            Write-Output "No folders were removed."
        } 
    }
    
    end {
        Write-Output "Your machine needs to be restarted for the changes to take effect."
        pause
    }
}

Start-TeamsLoginReset
