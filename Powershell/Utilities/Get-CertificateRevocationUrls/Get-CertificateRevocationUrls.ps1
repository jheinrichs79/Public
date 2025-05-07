function Get-CertificateRevocationUrls {
    param (
        [string[]]$stores = @("LocalMachine\My", "LocalMachine\Root", "LocalMachine\CA", "CurrentUser\My", "CurrentUser\Root", "CurrentUser\CA")
    )

    $results = @()

    foreach ($store in $stores) {
        Write-Output "Scanning Certificate Store: Cert:\$store"
        $certs = Get-ChildItem -Path "Cert:\$store"

        foreach ($cert in $certs) {
            $crlUrls = @()
            $aiaUrls = @()

            foreach ($extension in $cert.Extensions) {
                if ($extension.Oid.FriendlyName -eq "CRL Distribution Points") {
                    $crlUrls += ($extension.Format($true) | Select-String "http[s]?://[^\s]+" | ForEach-Object { $_.Matches.Value })
                }
                if ($extension.Oid.FriendlyName -eq "Authority Information Access") {
                    $aiaUrls += ($extension.Format($true) | Select-String "http[s]?://[^\s]+" | ForEach-Object { $_.Matches.Value })
                }
            }

            # Only add certificates with CRL or AIA URLs
            if ($crlUrls.Count -gt 0 -or $aiaUrls.Count -gt 0) {
                $results += [PSCustomObject]@{
                    Subject = $cert.Subject
                    Store = $store
                    CRL_URLs = $crlUrls
                    AIA_URLs = $aiaUrls
                }
            }
        }
    }

    return $results
}


$certUrls = Get-CertificateRevocationUrls

$csvOutput = "C:\bin\certUrls.csv"

$certUrls | Where-Object { $_."CRL_URLs" -ne "" -or $_."AIA_URLs" -ne "" } | 
    Select-Object Subject, Store, 
    @{Name="CRL_URLs"; Expression={$_."CRL_URLs" -join ", "}}, 
    @{Name="AIA_URLs"; Expression={$_."AIA_URLs" -join ", "}} | 
    Export-Csv -Path $csvOutput -NoTypeInformation
