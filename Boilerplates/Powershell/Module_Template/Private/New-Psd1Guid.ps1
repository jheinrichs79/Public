function New-Psd1Guid {
    [CmdletBinding()]
    param()

    # Generate a GUID and force lowercase
    $Guid = [guid]::NewGuid().ToString().ToLower()

    return $Guid
}
