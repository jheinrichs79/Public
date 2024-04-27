param (
        $CSVFile
    )
function Start-LlamaQAPairsCSVConversion {
    [CmdletBinding()]
    param (
        $CSVFile
    )
    
    begin {
        $CSV = Import-Csv $CSVFile
        $Folder = (Get-Item $CSVFile).DirectoryName
        $File = "/"+((Get-Item $CSVFile).Basename)+".txt" #Linux version
        $TrainingFile = $Folder+$File
    }
    
    process {
        foreach ($x in $CSV){
            $question = $x.question
            $answer = $x.answer
            "<SFT>### Human: $question ### Assistant: $answer" | Out-File $TrainingFile -Append
        }
    }
    
    end {
        Get-Content $TrainingFile
    }
}
Start-LlamaQAPairsCSVConversion -CSVFile $CSVFile