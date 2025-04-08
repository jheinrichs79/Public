$var = nslookup myip.opendns.com resolver1.opendns.com
$var.Address.TypeNameOfValue

function Get-MyPublicIPAddress {
    [CmdletBinding()]
    param (
        $myip = "myip.opendns.com",
        $resolver = "resolver1.opendns.com"
    )
    
    begin {
        Write-Host $myip
        Write-Host $resolver
    }
    
    process {
        
    }
    
    end {
        
    }
}