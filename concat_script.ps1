#only works in powershell version 7+

$files = Get-ChildItem -Path .\* -Include *.mp4, *.ts -Exclude "*concat*" | Select Name, BaseName | Sort-Object {[int]([regex]::Matches($_.BaseName, '(\d+)(?!\d.*)')[-1].Value)}
#$files = Get-ChildItem -Path .\* -Include *.mp4, *.ts -Exclude "*concat*" | Select Name, BaseName

$str = "" 
foreach ($file in $files) {
	$currentFileName = $file.name
	$str += "file '$currentFileName'`r`n"
}

$str | Out-File -FilePath .\files.txt -Encoding utf8NoBOM
 
$concatFileName = $files[0].BaseName + "_concat.mp4"
ffmpeg -f concat -safe 0 -i files.txt -c copy $concatFileName
