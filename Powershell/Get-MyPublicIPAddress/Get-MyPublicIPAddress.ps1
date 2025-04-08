function Get-MyPublicIPAddress {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        $myip = "myip.opendns.com"
        $resolver = "resolver1.opendns.com"
        $var = nslookup myip.opendns.com resolver1.opendns.com
        Write-Host $myip
        Write-Host $resolver
    }
    
    process {
        $var = nslookup $myip $resolver
    }
    
    end {
        $var
    }
}
Get-MyPublicIPAddress