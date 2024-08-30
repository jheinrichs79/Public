EXAMPLE INFO:

On C: make a folder called: C:\NetworkDiagram\
In that folder place both the "Get-NetworkDiagram.exe" and the "CSV-Template.csv" into the folder.
Rename "CSV-Template.csv" to "Data Flow.csv"

Open a Command prompt and run:

C:\NetworkDiagram\Get-NetworkDiagram.exe -CSVFile "C:\NetworkDiagram\Data Flow.csv" -LR

This will create the code for a Diagram with the Title "Data Flow"
The Diagram will have a Left to Right format.

Other formats you can use are:
TB = Top to Bottom
BT = Bottom to Top

You would switch -LR with one of the items list above.
