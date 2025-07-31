param (
    [Parameter(Mandatory=$true)]
    [string]$MACAddress,
    [string]$csvFileLocation
)
function Send-WakeOnLan {
    param (
        [Parameter(Mandatory=$true)]
        [string]$MACAddress,
        [string]$csvFileLocation,
        [string]$BroadcastAddress = "255.255.255.255",
        [int]$Port = 9
    )

    $macBytes = $MACAddress -replace "[:-]", "" -split "(?<=\G..)(?=.)" | ForEach-Object { [byte]("0x$_") }
    $packet = [byte[]](,0xFF * 6 + ($macBytes * 16))
    
    $udpClient = New-Object System.Net.Sockets.UdpClient
    $udpClient.Connect($BroadcastAddress, $Port)
    $udpClient.Send($packet, $packet.Length)
    $udpClient.Close()

    Write-Host "Magic packet sent to $MACAddress via $BroadcastAddress on port $Port"
}

if ($csvFileLocation) {
    if (Test-Path $csvFileLocation) {
        $csvData = Import-Csv -Path $csvFileLocation
        foreach ($row in $csvData) {
            if ($row.MACAddress) {
                Send-WakeOnLan -MACAddress $row.MACAddress -BroadcastAddress $row.BroadcastAddress -Port $row.Port
            }
        }
    } else {
        Write-Host "CSV file not found at $csvFileLocation"
    }
} elseif ($MACAddress){
    # If only MACAddress is provided, send the magic packet directly
    Send-WakeOnLan -MACAddress $MACAddress
}
Send-WakeOnLan -MACAddress $MACAddress -csvFileLocation $csvFileLocation
# Example usage:
# Send-WakeOnLan -MACAddress "00:11:22:33:44:55"