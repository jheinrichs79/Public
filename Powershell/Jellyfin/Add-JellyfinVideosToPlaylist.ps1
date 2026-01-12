<#
This is mostly just note-taking. I plan on making a bunch of functions that I will wrap up
into a single PowerShell module that can manage Jellyfin from the command line.

    This function was tested with these versions of software
      Server: 
        Name: Jellyfin Server 
        ver:  10.11.5
      Client:
        Name: Jellyfin Media Player (Last version before Jellyfin Desktop!)
        ver:  1.12
      PowerShell:
        Name: Microsoft Powershell
        ver:  7.5.4

#>
param (
        [string]$ServerUrl  = "http://homeservarr:2351",
        [Parameter(Mandatory)]
        [string]$ApiKey,
        [string]$User       = "admin",
        [string]$SearchTerm,
        [int]$Limit         = 1, #Used to set the limit the number of search results presented
        [string]$PlaylistId
    )
#======================================================================================================
function Add-JellyfinVideosToPlaylist {
#======================================================================================================
    param (
        [string]$ServerUrl,
        [Parameter(Mandatory)]
        [string]$ApiKey,
        [string]$User,
        [string]$SearchTerm,
        [int]$Limit,
        [string]$PlaylistId
    )

    # ------------------------------------------------------------
    # 0️ - Headers
    # ------------------------------------------------------------
    $headers = @{ 'X-Emby-Token' = $ApiKey }

    # ------------------------------------------------------------
    # 1️ - Verify connection & resolve user
    # ------------------------------------------------------------
    try {
        $users = Invoke-RestMethod -Uri "$ServerUrl/Users" -Headers $headers
    } catch {
        throw "❌ Unable to connect to Jellyfin or authenticate."
    }

    $userObj = $users | Where-Object Name -eq $User

    if (-not $userObj) {
        Write-Warning "User '$User' not found. Available users:"
        $users | Format-Table Name, Id
        $User = Read-Host "Copy & paste the correct USER NAME"
        $userObj = $users | Where-Object Name -eq $User

        if (-not $userObj) {
            throw "❌ Invalid user selected."
        }
    }

    $userId = $userObj.Id
    Write-Host "✅ Using user '$($userObj.Name)' ($userId)"

    # ------------------------------------------------------------
    # 2 - Search for videos
    # ------------------------------------------------------------
    $encoded = [System.Web.HttpUtility]::UrlEncode($SearchTerm)
    $searchUri = "$ServerUrl/Items?Recursive=true&SearchTerm=$encoded&IncludeItemTypes=Video&Limit=$Limit"

    $results = Invoke-RestMethod -Uri $searchUri -Headers $headers

    if (-not $results.Items) {
        throw "❌ No videos found for '$SearchTerm'"
    }

    $videoIds = $results.Items | Select-Object -ExpandProperty Id

    Write-Host "✅ Found $($videoIds.Count) video(s):"
    $results.Items | Format-Table Name, Id

    # ------------------------------------------------------------
    # 3 - Resolve playlist
    # ------------------------------------------------------------
    if (-not $PlaylistId) {
        $playlistUri = "$ServerUrl/Users/$userId/Items?IncludeItemTypes=Playlist&Recursive=true"
        $playlists = Invoke-RestMethod -Uri $playlistUri -Headers $headers

        if (-not $playlists.Items) {
            throw "❌ No playlists found for user."
        }

        Write-Host "Available playlists:"
        $playlists.Items | Format-Table Name, Id

        $PlaylistId = Read-Host "Copy & paste the PLAYLIST ID"
    }

    # ------------------------------------------------------------
    # 4 - Add videos (THIS is the correct supported API call)
    # ------------------------------------------------------------
    $idsParam = ($videoIds -join ",")
    $addUri = "$ServerUrl/Playlists/$PlaylistId/Items?UserId=$userId&Ids=$idsParam"

    Invoke-RestMethod -Uri $addUri -Method Post -Headers $headers

    Write-Host "✅ Added $($videoIds.Count) video(s) to playlist."

    # ------------------------------------------------------------
    # 5 - Verify playlist contents
    # ------------------------------------------------------------
    Invoke-RestMethod `
        -Uri "$ServerUrl/Playlists/$PlaylistId/Items?UserId=$userId" `
        -Headers $headers |
        Select-Object -ExpandProperty Items |
        Format-Table Name, Id
}
Add-JellyfinVideosToPlaylist -ApiKey $ApiKey -Limit $Limit
