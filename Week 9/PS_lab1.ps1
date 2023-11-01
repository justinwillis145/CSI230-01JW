(Get-NetIPAddress -AddressFamily IPv4 | where {$_.InterfaceAlias -ilike "Ethernet*"}).IPAddress
(Get-NetIPAddress -AddressFamily IPv4 | where {$_.InterfaceAlias -ilike "Ethernet*"}).PrefixLength

Get-WmiObject -List | where {$_.Name -ilike "Win32_[n][e][t]*"} | Sort-Object

Get-CimInstance Win32_NetworkAdapterConfiguration -Filter "DHCPEnabled=$true" | select DHCPServer | Format-Table -HideTableHeaders

(Get-DnsClientServerAddress -AddressFamily IPv4 | `
where {$_.InterfaceAlias -ilike "Ethernet*"}).ServerAddresses[0]


cd "C:\Users\champuser\CSI230-01JW\Week_9"

$files=(dir -Recurse)
for($j=0; $j -le $files.Length; $j++){
   if($files[$j].Extension -ilike "*ps1"){
       $files[$j].Name
    }
}

$folderPath = "C:\Users\champuser\CSI230-01JW\Week_9\outfolder"
if (Test-Path -Path $folderPath){
  Write-Host "Folder Already Exists"
}
else{
  New-Item -Name "outfolder" -ItemType Directory -Path $folderPath
}

cd "C:\Users\champuser\CSI230-01JW\Week_9"
$folderPath = "C:\Users\champuser\CSI230-01JW\Week_9\outfolder\"
$files=(Get-ChildItem)
$filePath = Join-Path $folderPath "out.csv"
$files | Where-Object {$_.Extension -like ".ps1"} | Export-Csv -Path $filePath

$files=(Get-ChildItem -Recurse -File)
Get-ChildItem -Recurse -File
