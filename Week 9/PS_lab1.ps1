#Storyline: This script will export a log of ps1 files that have been created.

# Get the IP address of the network interface with alias like "Ethernet*"
(Get-NetIPAddress -AddressFamily IPv4 | where {$_.InterfaceAlias -ilike "Ethernet*"}).IPAddress

# Get the prefix length of the network interface with alias like "Ethernet*"
(Get-NetIPAddress -AddressFamily IPv4 | where {$_.InterfaceAlias -ilike "Ethernet*"}).PrefixLength

# Get a list of WMI classes that have names like "Win32_Net*", sort them alphabetically
Get-WmiObject -List | where {$_.Name -ilike "Win32_Net*"} | Sort-Object

# Get the DHCP server address for network adapters with DHCP enabled, and format the output as a table without headers
Get-CimInstance Win32_NetworkAdapterConfiguration -Filter "DHCPEnabled=$true" | select DHCPServer | Format-Table -HideTableHeaders

# Get the first DNS server address for the network interface with alias like "Ethernet*"
(Get-DnsClientServerAddress -AddressFamily IPv4 | where {$_.InterfaceAlias -ilike "Ethernet*"}).ServerAddresses[0]

# Change the current directory to "C:\Users\champuser\CSI230-01JW\Week_9"
cd "C:\Users\champuser\CSI230-01JW\Week_9"

# Get a list of all files in the current directory and its subdirectories
$files=(dir -Recurse)

# Loop through the files
for($j=0; $j -le $files.Length; $j++){
   # Check if the file has a ".ps1" extension (case-insensitive)
   if($files[$j].Extension -ilike "*ps1"){
       # Print the file name
       $files[$j].Name
    }
}

# Define the folder path
$folderPath = "C:\Users\champuser\CSI230-01JW\Week_9\ExportFiles"

# Check if the folder already exists
if (Test-Path -Path $folderPath){
  # Print a message indicating that the folder already exists
  Write-Host "Folder Already Exists"
}
else{
  # Create a new folder with the specified name and path
  New-Item -Name "ExportFiles" -ItemType Directory -Path $folderPath
}

# Change the current directory to "C:\Users\champuser\CSI230-01JW\Week_9"
cd "C:\Users\champuser\CSI230-01JW\Week_9"

# Define the folder path
$folderPath = "C:\Users\champuser\CSI230-01JW\Week_9\ExportFiles\"

# Get a list of files in the current directory
$files=(Get-ChildItem)

# Define the file path
$filePath = Join-Path $folderPath "out.csv"

# Export the list of ".ps1" files to a CSV file
$files | Where-Object {$_.Extension -like ".ps1"} | Export-Csv -Path $filePath

# Get a list of all files in the current directory and its subdirectories
$files=(Get-ChildItem -Recurse -File)

# Get a list of all files in the current directory and its subdirectories
Get-ChildItem -Recurse -File
