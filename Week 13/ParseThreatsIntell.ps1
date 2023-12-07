#Storyline: Array of websites containing threat intell
$drop_urls = @('https://rules.emergingthreats.net/blockrules/emerging-botcc.rules','https://rules.emergingthreats.net/blockrules/compromised-ips.txt')

#Loop through the URLs for the rules list
foreach($u in $drop_urls) {
    #Extract the file name
    $temp = $u.split("/")
    $file_name = $temp[-1]

    #Download the rules list
    Invoke-WEbRequest -Uri $u -OutFile $file_name
}

#Array containing the filename
$input_paths = @('.\compromised-ips.txt','.\emerging-botcc.rules')

#Extract the ip address
$regex_drop = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'

#Append the IP address to the tmeporary IP list
select-string -Path $input_paths -Pattern $regex_drop |
ForEach-Object { $_.Matches } |
ForEach-Object { $_.Value } | Sort-Object | Get-Unique |
Out-File -FilePath "ips-bad.tmp"

#Get the IP addresses discovered, loop through and replace the beginning of the line with the IPTables syntax

#iptables -A INPUT -s 108.191.2.72 -j DROP
(Get-Content -Path ".\ips-bad.tmp") | ForEach-Object `
{ $_ -replace "^", "iptables -A INPUT -s " -replace "$", " -j DROP" } | `
Out-File -FilePath "iptables.bash"
