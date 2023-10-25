#Storyline: This script prompts the user to select an event log to export, retrieves the three most recent entries from the specified event log, 
# and exports those entries to a CSV file on the desktop.

Get-EventLog -List

#Prompts the user to get retrieve one of the log files
$expLog = Read-Host -Prompt "Please select a log to export!"

#retrieves the three most recent entries from the event log specified by the user and exports them to a file on the desktop
Get-EventLog -LogName $expLog -Newest 3 | Export-Csv -NoTypeInformation -Path "C:\Users\champuser\Desktop\rep.csv"
