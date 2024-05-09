<#
========================================================================
Written by: 	Jared Heinrichs
URL:		https://github.com/jheinrichs79/Public/
========================================================================
EULA - Completely free to use as long as you keep this header
------------------------------------------------------------------------

Save as: Start-PortTest.ps1
Run it as:

Show only the tests that failed and format it as a table:
.\Start-PortTest.ps1 -NetworkHost 192.168.101.45 -TCPPorts 900,9000,1234 -UDPPorts 88,137 | Where-Object TestSucceeded -eq $false | Format-Table

Show all test info on screen and then save the output to “C:\bin\PortTest.csv
.\Start-PortTest.ps1 -NetworkHost 192.168.101.45 -TCPPorts 900,9000,1234 -UDPPorts 88,137 -LogFileFolder "C:\bin"

Show all test info on screen and then save the output to “C:\bin\PortTest.csv . Overwrite the log file with only the data from this test.
.\Start-PortTest.ps1 -NetworkHost 192.168.101.45 -TCPPorts 900,9000,1234 -UDPPorts 88,137 -LogFileFolder "C:\bin" -OverWriteLog

#>

#Global Params
param (
    $NetworkHost,
    $TCPPorts,
    $UDPPorts,
    $LogFileFolder,
    [switch]$OverWriteLog
)
#Worker Functions ================================================================
function Start-PortTestTCP {
    [CmdletBinding()]
    param (
        $NetworkHost,
        $TCPPorts
    )
    
    begin {
        $LogArray = @()
        $Result = $false
    }
    
    process {
        foreach ($p in [array]$TCPPorts) {
            #Build Custom TCP Client
            $BuildTCPClient = new-Object system.Net.Sockets.TcpClient
            
            #Run Asyncronis Test
            $Connection = $BuildTCPClient.ConnectAsync($NetworkHost,$p)
            for($i=0; $i -lt 10; $i++) {
				if ($Connection.isCompleted) { break; }
				Start-Sleep -milliseconds 100
			}

            #Close Custom TCPClient
			$BuildTCPClient.Close();
			
            #Check TCP Test
            if ($Connection.Status -eq "RanToCompletion") {
				$Result = $true
			}

            $objectPortTest = [ordered]@{
                Date                = Get-Date -UFormat "%Y/%m/%d"
                Time                = Get-Date -UFormat "%R"
                Source              = $env:computername
                Destination         = $NetworkHost
                Protocol            = "TCP"
                Port                = $p
                TestSucceeded       = $Result
            }
            $Test = New-Object -TypeName psobject -Property $objectPortTest
            $LogArray += $Test
        }
    }
    
    end {
        #RETURN
        $LogArray
    }
}
function Start-PortTestUDP {
    [CmdletBinding()]
    param (
        $NetworkHost,
        $UDPPorts
    )
    
    begin {
        $LogArray = @()
        $Result = $false
    }
    
    process {
        foreach ($p in [array]$UDPPorts) {
            #Build Custom TCP Client
            $BuildUDPClient = new-Object system.Net.Sockets.UDPClient
            $BuildUDPClient.Client.ReceiveTimeout = 500
            #Connect            
            $BuildUDPClient.Connect($NetworkHost,$p)
            #Send a single byte 0x01
			[void]$BuildUDPClient.Send(1,1)
			
            
            $l = new-object system.net.ipendpoint([system.net.ipaddress]::Any,0)
			try {
				if ($BuildUDPClient.Receive([ref]$l)) {
					# We have received some UDP data from the remote host in return
					$Result = $true
				}
			} catch {
				if ($Error[0].ToString() -match "failed to respond") {
					# We haven't received any UDP data from the remote host in return
					# Let's see if we can ICMP ping the remote host
					if ((Get-wmiobject win32_pingstatus -Filter "address = '$NetworkHost' and Timeout=1000 and ResolveAddressNames=false").StatusCode -eq 0) {
						# We can ping the remote host, so we can assume that ICMP is not
						# filtered. And because we didn't receive ICMP port-unreachable before,
						# we can assume that the remote UDP port is open
						$Result = $true
					}
				} elseif ($Error[0].ToString() -match "forcibly closed") {
					# We have received ICMP port-unreachable, the UDP port is closed
					$Result = $false
				}
			}
			$BuildUDPClient.Close()

            $objectPortTest = [ordered]@{
                Date                = Get-Date -UFormat "%Y/%m/%d"
                Time                = Get-Date -UFormat "%R"
                Source              = $env:computername
                Destination         = $NetworkHost
                Protocol            = "UDP"
                Port                = $p
                TestSucceeded       = $Result
            }
            $Test = New-Object -TypeName psobject -Property $objectPortTest
            $LogArray += $Test
        }
    }
    
    end {
        #RETURN
        $LogArray
    }
}

#[[Program Body]]====================================================================

#----------------------------------------------------------------[Check Requirements]
#
# Check and see if they entered any TCP or UDP ports. If both failed remind them
# how to use the test

if (!$TCPPorts -and !$UDPPorts) {
    Write-Host "usage: Start-PortTest -host <port|ports>"
    Write-Host ' e.g.: .\Start-PortTest.ps1 -host "192.168.1.2" -TCPPorts 445,80,443'
    return
}

#If they want to export the log data the Log Folder must exist
if ($LogFileFolder){
    if (!(Test-Path -Path $LogFileFolder)) {
        Write-Host "$LogFileFolder does not exist."
        return
    }
}
#----------------------------------------------------------------[Start the tests]

$LogArray = @()


if ($TCPPorts){
    $LogArray += Start-PortTestTCP -NetworkHost $NetworkHost -TCPPorts $TCPPorts
}
if ($UDPPorts){
    $LogArray += Start-PortTestUDP -NetworkHost $NetworkHost -UDPPorts $UDPPorts
}
if ($LogFileFolder){
    $LogArray | Format-Table
    Write-Host
    Write-Host
    $FullPath = $LogFileFolder+"/PortTest.csv"
    if ($OverWriteLog){
        $LogArray | Export-Csv $FullPath -Force
    } else {
        $LogArray | Export-Csv $FullPath -Append
    }
} else {
    $LogArray
}
