<#
=================================================================
Start-KeepAwake
Written By: Jared Heinrichs
=================================================================
#>

param (
        $Hours,
        [switch]$Pause
    )
function Start-KeepAwake {
    [CmdletBinding()]
    param (
        $Hours,
        [switch]$Pause
    )
    
    begin {
        $wsh = New-Object -ComObject WScript.Shell
        $EndDateTime = (Get-Date).addHours($Hours)
        $StartDateTime = Get-Date
    }
    
    process {
        while ($StartDateTime -le $EndDateTime) {
            # Send Shift+F15 - this is the least intrusive key combination
            $wsh.SendKeys('+{F15}')
            $RandomTime = Get-Random -Minimum 60 -Maximum 300
            Start-Sleep -seconds $RandomTime
            $StartDateTime = Get-Date
        }
    }
    
    end {
        $Date = Get-Date
        Write-Host "Utility Complete: $Date"
        Write-Host
        Write-Host
        if ($Pause){
            pause
        }
    }
}

<#
=================================================================
Start Keep Awake Utility
=================================================================
#>

Write-Host
Write-Host
$CurrentDateTime = Get-Date
$CurrentDateTime
Write-Host

#If there are no hours it most likely means that the person just double clicked the file to run.
#We will automatically add a pause at the end of the time.
if (!($Hours)){
    $Hours = Read-Host "In how many --hours-- would you like to stop this utility?"
    $Pause = $true
}
if ($Pause){
    Start-KeepAwake -Hours $Hours -Pause
} else {
    Start-KeepAwake -Hours $Hours
}
