#!/bin/bash

# Define the Apache log file
LOG_FILE="access.log"

# Define the output file for IPTables rules
IPTABLES_RULES_FILE="iptables-rules.txt"

# Define the threshold for blocking an IP address (e.g., 100 requests)
THRESHOLD=100

#Checks to see if the apache file exists
read -p "Please enter an apache log file." tFile
if [[ ! -f ${tFile} ]]
then

  echo "File doesn't exists."
  exit 1
fi


# Function to sort and remove duplicates from the list of IP addresses
unique_ips() {
    sort -n | uniq
}

# Parse the Apache logs and extract IP addresses that exceed the threshold
awk -v threshold=$THRESHOLD '{
    ip_count[$1]++
} END {
    for (ip in ip_count) {
        if (ip_count[ip] > threshold) {
            print ip
        }
    }
}' $LOG_FILE | unique_ips > blocked-ips.txt

# Generate IPTables rules to block the extracted IP addresses
echo "# Generated IPTables rules to block malicious IP addresses" > $IPTABLES_RULES_FILE
while read -r ip; do
    echo "iptables -A INPUT -s $ip -j DROP" >> $IPTABLES_RULES_FILE
done < blocked-ips.txt

# Display the generated IPTables rules
cat $IPTABLES_RULES_FILE

