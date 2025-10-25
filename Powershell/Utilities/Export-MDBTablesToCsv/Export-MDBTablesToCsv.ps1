<#
  Created By: Jared Heinrichs

  To run this conversion utility, you will need to run this script like this:
      .\Export-MDBTablesToCSV.ps1 -RootPath $rootPath

#>

function Export-MDBTablesToCsv {
    param (
        [string]$RootPath
    )

    # Get all .mdb files recursively
    $mdbFiles = Get-ChildItem -Path $RootPath -Recurse -File -Filter *.mdb

    foreach ($mdbFile in $mdbFiles) {
        $mdbPath = $mdbFile.FullName
        $exportFolder = $mdbFile.DirectoryName
        $mdbName = $mdbFile.BaseName

        Write-Host "`nProcessing: $mdbPath"

        # Create Access COM object
        $accessApp = New-Object -ComObject Access.Application
        try {
            $accessApp.OpenCurrentDatabase($mdbPath)

            # Get non-system tables
            $tables = $accessApp.CurrentData.AllTables | Where-Object { $_.Name -notlike "MSys*" }

            foreach ($table in $tables) {
                $tableName = $table.Name
                $csvFileName = "$mdbName-$tableName.csv"
                $csvPath = Join-Path $exportFolder $csvFileName

                # Export table to CSV
                $accessApp.DoCmd.TransferText(
                    2,        # acExportDelim
                    $null,    # SpecificationName
                    $tableName,
                    $csvPath,
                    $true     # HasFieldNames
                )

                Write-Host "Exported: $tableName → $csvFileName"
            }

            $accessApp.CloseCurrentDatabase()
        } catch {
            Write-Warning "Failed to process $mdbPath - $_"
        } finally {
            $accessApp.Quit()
            [System.Runtime.Interopservices.Marshal]::ReleaseComObject($accessApp) | Out-Null
        }
    }
}

Export-MDBTablesToCsv -RootPath $RootPath
