function Test-UTF8NoBOM {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    # Read first three bytes safely
    $bytes = Get-Content -Path $Path -Encoding Byte -TotalCount 3

    # If file is shorter than 3 bytes, it cannot contain a UTF-8 BOM
    if ($bytes.Count -lt 3) {
        return $true
    }

    # Check for UTF-8 BOM (EF BB BF)
    $hasBom = ($bytes[0] -eq 0xEF -and
               $bytes[1] -eq 0xBB -and
               $bytes[2] -eq 0xBF)

    return -not $hasBom
}
