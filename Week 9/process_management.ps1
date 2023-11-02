$timeNow=[datetime]::Now
Get-Process | ForEach-Object{
    if($_.StartTime){
        if([int]($timeNow - $_.StartTime).TotalMinutes -le 60){
           [PSCustomObject]@{
                Process = $_.Name
                RunMinutes=[int]([datetime]::Now - $_.StartTime).TotalMinutes
           }
        }
    }
}

Get-Process | Select-Object Name, Path | where {$_.Path -notlike "C:\Windows\System32\*"}

Get-Service | Where-Object {$_.Status -eq "Stopped"} | Sort-Object | `
Export-Csv -Path "C:\Users\champuser\CSI230-01JW\Week_9\managemetStop.csv"

cd "C:\Users\champuser\CSI230-01JW\Week_9"

$files=(Get-ChildItem -File -Recurse| Sort CreationTime)
for($j=0; $j -le $files.Length; $j++){
   if($files[$j].Extension -ilike "*ps1"){
       $files[$j].Name
    }
}

Write-Host $files

Get-ChildItem -File -Recurse | where {$_.CreationTime -ge "10/24/2023 00:00:00"} | Select-Object Name, CreationTime | `
Export-Csv -Path "C:\Users\champuser\CSI230-01JW\Week_9\processManagemetFiles.csv" -NoTypeInformation

if (!(Get-Process -ProcessName chrome -ErrorAction SilentlyContinue)) {
    Start-Process -FilePath "C:\Program Files\Google\Chrome\Application\chrome.exe" -ArgumentList 'http://www.Champlain.edu'
}
else{Stop-Process -Name chrome}
