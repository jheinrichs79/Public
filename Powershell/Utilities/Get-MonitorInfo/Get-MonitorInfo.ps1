function Start-Decode {
    If ($args[0] -is [System.Array]) {
        [System.Text.Encoding]::ASCII.GetString($args[0])
    }
    Else {
        "Not Found"
    }
}
function Get-Primary {
    [string]$primary = ([System.Windows.Forms.Screen]::PrimaryScreen).DeviceName
    $PrimaryMonitorNum = $primary.remove(0,($primary.length -1))
}
function Get-MonitorInfo {

    begin {
        $Monitors = @()
    }
    
    process {
        $MonitorNum = 0
        ForEach ($Monitor in Get-CimInstance WmiMonitorID -Namespace root\wmi) {
            $PrimaryMonitorNum = Get-Primary
            [int]$MonitorNum += 1
            [string]$HardwareID = ($Monitor.InstanceName).split("\")[1]
            [string]$FullName = Start-Decode $Monitor.UserFriendlyName -notmatch 0
            $pos = $FullName.IndexOf(" ")[0]
            [string]$Manufacturer = $FullName.Substring(0, $pos)
            [string]$Model = $FullName.Substring($pos+1)
            [string]$SerialNum = Start-Decode $Monitor.SerialNumberID -notmatch 0

            if ($PrimaryMonitorNum -eq $MonitorNum){
                $MonitorProperty = [ordered]@{
                    "Monitor Number" = $MonitorNum
                    "Primary Display" = $true
                    Manufacturer = $Manufacturer.toupper()
                    "Model Name" = $Model
                    "Serial Number" = $SerialNum
                    "Hardware ID" = $HardwareID
                }
            } else {
                $MonitorProperty = [ordered]@{
                    "Monitor Number" = $MonitorNum
                    "Primary Display" = $false
                    Manufacturer = $Manufacturer.toupper()
                    "Model Name" = $Model
                    "Serial Number" = $SerialNum
                    "Hardware ID" = $HardwareID
                }
            }
            
            $MonitorObj = New-Object -TypeName psobject -Property $MonitorProperty
            $Monitors += $MonitorObj
        }
    }
    
    end {
        $Monitors
    }
}
Get-MonitorInfo
