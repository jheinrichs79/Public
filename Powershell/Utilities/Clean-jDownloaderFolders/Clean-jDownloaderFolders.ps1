<#
    .SYNOPSIS
        Moves video files from subfolders into the root folder, handles duplicates,
        deletes empty subfolders, and deletes subfolders smaller than 600 KB.

    .PARAMETER RootPath
        The root folder path (can be a local path or SMB share, e.g. \\server\share).

    .Example
        .\Clean-jDownloaderFolders.ps1 -RootPath “C:\folder\jDownloader”
#>
param(
  [Parameter(Mandatory=$true)]
  [string]$RootPath
)

function Clean-jDownloaderFolders {
    param(
        [Parameter(Mandatory=$true)]
        [string]$RootPath
    )

    Write-Host "Root folder: $RootPath"

    # Define video file extensions to look for
    $videoExtensions = @("*.mp4","*.avi","*.mov","*.mkv","*.wmv","*.flv")

    # Loop through each subfolder
    Get-ChildItem -Path $RootPath -Directory | ForEach-Object {
        $subFolder = $_.FullName
        Write-Host "Processing folder: $subFolder"

        # Move video files
        foreach ($ext in $videoExtensions) {
            Get-ChildItem -Path $subFolder -Filter $ext -File | ForEach-Object {
                $file = $_
                $destination = Join-Path $RootPath $file.Name

                # Handle duplicates
                if (Test-Path $destination) {
                    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
                    $extension = $file.Extension
                    $counter = 1

                    do {
                        $newName = "{0}_{1}{2}" -f $baseName, $counter, $extension
                        $destination = Join-Path $RootPath $newName
                        $counter++
                    } while (Test-Path $destination)

                    Write-Host "Duplicate detected. Renaming to $newName"
                }

                Write-Host "Moving $($file.Name) to $destination"
                Move-Item -Path $file.FullName -Destination $destination
            }
        }

        # Calculate total folder size (including nested files)
        $folderSize = (Get-ChildItem -Path $subFolder -Recurse -File | Measure-Object -Property Length -Sum).Sum

        # Delete if empty OR total size < 600 KB
        if (-not (Get-ChildItem -Path $subFolder) -or $folderSize -lt 600KB) {
            Write-Host "Deleting folder: $subFolder (Size: $folderSize bytes)"
            Remove-Item -Path $subFolder -Recurse -Force
        } else {
            Write-Host "Folder retained: $subFolder (Size: $folderSize bytes)"
        }
    }

    Write-Host "All video files moved. Empty or small subfolders deleted."
}
Clean-jDownloaderFolders -RootPath $RootPath
