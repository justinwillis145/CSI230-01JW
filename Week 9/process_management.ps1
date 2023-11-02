#Storyline: PowerShell script that gets a list of running processes and saves each one to a file, and opens chrome to www.Champlain.edu
# Get the current date and time
$timeNow=[datetime]::Now

# Get a list of running processes and loop through each one
Get-Process | ForEach-Object{
    # Check if the process has a start time
    if($_.StartTime){
        # Check if the process has been running for less than or equal to 60 minutes
        if([int]($timeNow - $_.StartTime).TotalMinutes -le 60){
           # Create a custom object with the process name and run time in minutes
           [PSCustomObject]@{
                Process = $_.Name
                RunMinutes=[int]([datetime]::Now - $_.StartTime).TotalMinutes
           }
        }
    }
}

# Get a list of running processes and select the name and path properties
# Filter out any processes with a path that starts with "C:\Windows\System32\"
Get-Process | Select-Object Name, Path | where {$_.Path -notlike "C:\Windows\System32\*"}

# Get a list of stopped services, sort them, and export the results to a CSV file
Get-Service | Where-Object {$_.Status -eq "Stopped"} | Sort-Object | `
Export-Csv -Path "C:\Users\champuser\CSI230-01JW\Week_9\managemetStop.csv"

# Change the current directory to "C:\Users\champuser\CSI230-01JW\Week_9"
cd "C:\Users\champuser\CSI230-01JW\Week_9"

# Get a list of files in the current directory and its subdirectories, sorted by creation time
$files=(Get-ChildItem -File -Recurse| Sort CreationTime)

# Loop through the files
for($j=0; $j -le $files.Length; $j++){
   # Check if the file has a ".ps1" extension (case-insensitive)
   if($files[$j].Extension -ilike "*ps1"){
       # Print the file name
       $files[$j].Name
    }
}

# Print the list of files
Write-Host $files

# Get a list of files created on or after "10/31/2023 18:00:00", select the name and creation time properties, and export the results to a CSV file
Get-ChildItem -File -Recurse | where {$_.CreationTime -ge "10/31/2023 18:00:00"} | Select-Object Name, CreationTime | `
Export-Csv -Path "C:\Users\champuser\CSI230-01JW\Week_9\processManagemetFiles.csv" -NoTypeInformation

# Check if the "chrome" process is not running
if (!(Get-Process -ProcessName chrome -ErrorAction SilentlyContinue)) {
    # Start the "chrome" process with the specified file path and argument
    Start-Process -FilePath "C:\Program Files\Google\Chrome\Application\chrome.exe" -ArgumentList 'http://www.Champlain.edu'
}
else{
    # Stop the "chrome" process
    Stop-Process -Name chrome
}
