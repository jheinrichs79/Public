function Get-MyPublicIPAddress {
    [CmdletBinding()]
    param (
        
    )
    <#
        This script will get your public IP address. If the ipify service is down or you don't have internet 
        it will display "0.0.0.0" for your address
    #>
    process {
        # PowerShell script to display public IP address
        try {
            $ip = (Invoke-RestMethod -Uri "https://api.ipify.org?format=json").ip
        } catch {
            $ip = 0.0.0.0
        }
    }
    
    end {
        $ip
    }
}
Get-MyPublicIPAddress
