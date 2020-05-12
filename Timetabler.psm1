Function Merge-Tdf9{
    param(
        $file1,
        $file2,
        $file3,
        $output
    )
    if($file3){
        [xml]$tdf91 = Get-Content $file1
        [xml]$tdf92 = Get-Content $file2
        [xml]$tdf93 = Get-Content $file3

        Foreach ($Node in $tdf93.DocumentElement.ChildNodes) {
            $tdf91.DocumentElement.AppendChild($tdf91.ImportNode($Node, $true))
        }
        Foreach ($Node in $tdf92.DocumentElement.ChildNodes) {
            $tdf91.DocumentElement.AppendChild($tdf91.ImportNode($Node, $true))
        }

        $tdf91.Save("$output")
    }
    elseif (-Not ($file3) -and $file2) {
        [xml]$tdf91 = Get-Content $file1
        [xml]$tdf92 = Get-Content $file2

        Foreach ($Node in $tdf92.DocumentElement.ChildNodes) {
            $tdf91.DocumentElement.AppendChild($tdf91.ImportNode($Node, $true))
        }

        $tdf91.Save("$output")
    }
}
