Get-EventLog -List
$expLog = Read-Host -Prompt "Please select a log to export!"
Get-EventLog -LogName $expLog -Newest 3 | Export-Csv -NoTypeInformation -Path "C:\Users\champuser\Desktop\rep.csv"
