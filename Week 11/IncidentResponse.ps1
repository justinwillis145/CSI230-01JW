#Storyline: Script that returns the results of retrieved information from different logs.
function Get-Processes {
    Get-Process | Select-Object ProcessName, Path | Export-Csv -Path "$ResultDirectory\processes.csv" -Force -NoTypeInformation
}

function Get-Services {
    Get-WmiObject Win32_Service | Select-Object DisplayName, PathName | Export-Csv -Path "$ResultDirectory\services.csv" -Force -NoTypeInformation
}

function Get-TcpSockets {
    Get-NetTCPConnection | Export-Csv -Path "$ResultDirectory\tcpSockets.csv" -Force -NoTypeInformation
}

function Get-UserAccounts {
    Get-WmiObject Win32_UserAccount | Select-Object Name, Domain, SID | Export-Csv -Path "$ResultDirectory\userAccounts.csv" -Force -NoTypeInformation
}

function Get-NetworkAdapterConfiguration {
    Get-WmiObject Win32_NetworkAdapterConfiguration | Select-Object Description, IPAddress, DefaultIPGateway, DNSServerSearchOrder | Export-Csv -Path "$ResultDirectory\networkAdapterConfiguration.csv" -Force -NoTypeInformation
}

# Prompt user for the result directory
$ResultDirectory = Read-Host -Prompt "Enter the path to save results"

# Create directory if it doesn't exist
if (-not (Test-Path $ResultDirectory)) {
    New-Item -ItemType Directory -Path $ResultDirectory -Force
}

# Execute functions to retrieve information
Get-Processes
Get-Services
Get-TcpSockets
Get-UserAccounts

$logs = @('Application', 'System')
foreach ($log in $logs) {
    Get-EventLog -LogName $log -After (Get-Date).AddDays(-7) | Export-Csv -Path "$ResultDirectory\$($log)Events.csv" -Force -NoTypeInformation
}

# Check if script is running with elevated privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run the script as an administrator to access the Security log."
} else {
    Get-WinEvent -LogName Security -MaxEvents 100 | Export-Csv -Path "$ResultDirectory\securityEvents.csv" -Force -NoTypeInformation
}

# PowerShell cmdlets for additional artifacts
Get-NetFirewallRule | Export-Csv -Path "$ResultDirectory\firewallRules.csv" -Force -NoTypeInformation
Get-Command | Export-Csv -Path "$ResultDirectory\powershellCommands.csv" -Force -NoTypeInformation

# Create checksums for each CSV file
Get-ChildItem "$ResultDirectory\*.csv" | ForEach-Object {
    $hash = Get-FileHash $_.FullName -Algorithm SHA1
    "$hash  $($_.Name)" | Out-File "$ResultDirectory\checksums.txt" -Append
}

# Filter files and compress archive
Get-ChildItem "$ResultDirectory" -Exclude 'checksums.txt' | Where-Object { -not $_.PSIsContainer } | Compress-Archive -DestinationPath "$ResultDirectory\results.zip" -Force

# Create a checksum for the zip file
$zipHash = Get-FileHash "$ResultDirectory\results.zip" -Algorithm SHA1
"$zipHash  results.zip" | Out-File "$ResultDirectory\checksums.txt" -Append

Write-Host "Script execution completed. Results saved to: $ResultDirectory"
