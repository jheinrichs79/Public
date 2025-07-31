<#
Searching for Certificates on Windows Servers is kind of a pain.
The certificates can be located in multiple locations, like the local machine or the user space.
You can use Powershell or certutil however I find that each option is a bit lacking.

This utility will:
===================
  search all spaces
  tell you where the certs are located
  Tell you when the certs are expiring
  Show the most important info you are most likely looking for 

EXAMPLES:
=================

#1
Report to screen:
  Get-Certificates.ps1 -searchString "CompanyX"

#2
Report to Screen plus CSV Report
  Get-Certificates.ps1 -searchString "CompanyX" -csvlocation "C:\somefolder\cert-report.csv"

#>

param (
        [string]$csvLocation,
        [string]$searchString
    )
function Get-Certificates {
    param (
        $searchString
    )
    $CertArray = @()
    Get-ChildItem -Path 'Cert:' -Recurse | 
    Where-Object { !$_.PsIsContainer } | 
    ForEach-Object {
        $issuer = '{0}, {1}' -f ([regex] 'O=([^,]+)').Match($_.Issuer).Groups[1].Value, 
                                ([regex] 'CN=([^,]+)').Match($_.Issuer).Groups[1].Value
        if ($_.PSParentPath -like "*LocalMachine*") {
            $Location = "LocalMachine"
            $Path = $_.PSParentPath.Substring(56)
        }
        elseif ($_.PSParentPath -like "*CurrentUser*") {
            $Location = "CurrentUser"
            $Path = $_.PSParentPath.Substring(55)
        }
        $CertArray += [PSCustomObject]@{
            Location    = $Location
            Path         = $Path
            FriendlyName = $_.FriendlyName
            Issuer       = $issuer.Trim(', "')
            Subject      = $_.Subject
            ExpiryDate   = $_.NotAfter
        }
    }
    $CertArray
}

$getCertificates = Get-Certificates  -searchString $searchString | Where-Object Issuer -like "*$searchString*"
$getCertificates

if ($csvLocation) {
    $getCertificates | Export-Csv -Path $csvLocation -NoTypeInformation -Encoding UTF8
    Write-Host "Certificates exported to $csvLocation"
}
