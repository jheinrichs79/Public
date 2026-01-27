function Set-Placeholder {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [string]$Placeholder,

        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string]$Replacement

    )

    if (-not (Test-Path $Path)) {
        throw "File not found: $Path"
    }

    $content = Get-Content -Path $Path -Raw

    if ([string]::IsNullOrEmpty($content)) {
        throw "File is empty or unreadable: $Path"
    }

    $updated = $content.Replace($Placeholder, $Replacement)

    Set-Content -Path $Path -Value $updated

    #$updated
}
