param (
        $Hours
    )
function Start-KeepAwake {
    [CmdletBinding()]
    param (
        $Hours
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
        pause
    }
}

if (!($Hours)){
    $Hours = Read-Host "In how many --hours-- would you like to stop this utility?"
}
Start-KeepAwake -Hours $Hours