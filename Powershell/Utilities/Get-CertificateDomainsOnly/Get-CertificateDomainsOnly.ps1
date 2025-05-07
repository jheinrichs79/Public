function Get-CertificateDomainsOnly {
    param (
        [string[]]$stores = @("LocalMachine\My", "LocalMachine\Root", "LocalMachine\CA", "CurrentUser\My", "CurrentUser\Root", "CurrentUser\CA"),
        [string]$outputPath
    )
 
    $domainList = @()
 
    foreach ($store in $stores) {
        Write-Output "Scanning Certificate Store: Cert:\$store"
        $certs = Get-ChildItem -Path "Cert:\$store"
 
        foreach ($cert in $certs) {
            foreach ($extension in $cert.Extensions) {
                if ($extension.Oid.FriendlyName -in @("CRL Distribution Points", "Authority Information Access")) {
                    # Extract and clean URLs
                    $rawData = $extension.Format($true)
                    $urls = $rawData | Select-String "http[s]?://[^\s]+" | ForEach-Object { $_.Matches.Value }
 
                    foreach ($url in $urls) {
                        # Extract domain and apply wildcard for subdomains
                        $uri = [System.Uri]$url
                        $domain = $uri.Host
 
                        if ($domain -match "^[^.]+\.[^.]+$") {  # If it's a root domain (example.com)
                            $cleanDomain = $domain
                        } else {  # If it contains subdomains
                            $cleanDomain = "*." + ($domain -replace "^[^.]+\.")
                        }
                        $domainList += $cleanDomain
                    }
                }
            }
        }
    }
 
    # Remove duplicates and sort
    $uniqueDomains = $domainList | Sort-Object -Unique
 
    # Format and export to CSV
    $formattedDomains = $uniqueDomains | ForEach-Object { [PSCustomObject]@{Domain = $_} }
 
    if ($formattedDomains.Count -gt 0) {
        $formattedDomains | Export-Csv -Path $outputPath -NoTypeInformation -Encoding UTF8
        Write-Output "CSV saved to $outputPath"
    } else {
        Write-Output "No valid domains found!"
    }
}
 
# Run the function (** CHANGE OUTPUT PATH! **)
Get-CertificateDomainsOnly -outputPath "C:\folder\certUrls.csv"
