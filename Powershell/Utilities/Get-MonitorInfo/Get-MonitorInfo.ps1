<#
.SYNOPSIS
    This utility will display all the monitors connected to the system.
    This does not work in a virtual environment or RDP.

.DESCRIPTION
    DisplaysMonitor Number
    Primary Display
    Manufacturer
    Serial Number
    Hardware ID
    Width (Current)
    Height (Current)
    Orientation
    Cable Connection

.EXAMPLE
    ===============================================================
    $MonitorInfo = .\Get-MonitorInfo.ps1
    ===============================================================
    $MonitorInfo            #Displays all Monitors
    $MonitorInfo[0]         #Displays only the first monitor
    $MonitorInfo.count      #Shows the number of Monitors


.NOTES
    Written by: Jared Heinrichs
    Blog: https://jaredheinrichs.substack.com/
    Public GitHub: https://github.com/jheinrichs79/Public

#>
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
    $primary.remove(0, ($primary.length - 1))
}
function Get-MonitorInfo {

    begin {
        [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
        [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
        $Monitors = @()
    }
    
    process {
        $MonitorNum = 0
        ForEach ($Monitor in Get-CimInstance WmiMonitorID -Namespace root\wmi) {
            
            [int]$MonitorNum += 1
            $FormsInfo = [System.Windows.Forms.Screen]::AllScreens | Sort-Object DeviceName
            [string]$HardwareID = ($Monitor.InstanceName).split("\")[1]
            [string]$FullName = Start-Decode $Monitor.UserFriendlyName -notmatch 0
            $pos = $FullName.IndexOf(" ")[0]
            [string]$Manufacturer = $FullName.Substring(0, $pos)
            [string]$Model = $FullName.Substring($pos + 1)
            [string]$SerialNum = Start-Decode $Monitor.SerialNumberID -notmatch 0
            if (($FormsInfo[$MonitorNum-1].Bounds.Width) -gt ($FormsInfo[$MonitorNum-1].Bounds.Height)){
                $Orientation = "Horizontal"
            } else {
                $Orientation = "Vertical"
            }
            $CableTypeNum = ((Get-WmiObject WmiMonitorConnectionParams -Namespace root\wmi) | Where-Object InstanceName -like "*$HardwareID*" | Select-Object VideoOutputTechnology).VideoOutputTechnology
            if ($CableTypeNum -eq 10){
                $CableType = "Display Port"
            } elseif ($CableTypeNum -eq 5){
                $CableType = "HDMI"
            } elseif ($CableTypeNum -eq 4){
                $CableType = "DVI"
            } else {
                $CableType = "Unknown - $CableTypeNum"
            }
            $MonitorProperty = [ordered]@{
                "Monitor Number"  = $MonitorNum
                "Primary Display" = $FormsInfo[$MonitorNum-1].Primary
                "Manufacturer"    = $Manufacturer.toupper()
                "Model Name"      = $Model
                "Serial Number"   = $SerialNum
                "Hardware ID"     = $HardwareID
                "Width (Current)" = $FormsInfo[$MonitorNum-1].Bounds.Width
                "Height (Current)"= $FormsInfo[$MonitorNum-1].Bounds.Height
                "Orientation"     = $Orientation
                "Cable Connection"= $CableType
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
