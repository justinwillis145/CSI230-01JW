#!bin/bash

#Storyline: Extract IPs from emergingthreats.net and create a firewall ruleset

#Regex to extract the networks

wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O /tmp/emerging-threats

egrep '[0-9] {1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2}' /tmp/emerging-threats

# Check to see if the emerging-threat file exists
if [ -e /tmp/emerging-threats ]; then
    # File exists; prompt the user to confirm overwriting
    read -p "The emrging-threat file  already exists. Do you want to overwrite it? (y/n): " overwrite
    if [ "$overwrite" != "y" ]; then
        # If the user chooses not to overwrite, exit the program
        echo "Exiting without making changes."
        exit 1
    fi
fi


# Initialize variables for firewall type, CSV file URL, and Cisco URL filter file
firewall_type=""
csv_url=""
cisco_url_filter_file=""

while getopts ":f:c:r:" opt; do
  case $opt in
    f)
      firewall_type="$OPTARG"
      ;;
    c)
      csv_url="$OPTARG"
      ;;
    r)
      cisco_url_filter_file="$OPTARG"
      ;;
    :)
      echo "Option -$OPTARG requires an argument."
      exit 1
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      exit 1
      ;;
  esac
done


# Check if both firewall_type, csv_url, and cisco_url_filter_file are provided
if [ -z "$firewall_type" ] || [ -z "$csv_url" ] || [ -z "$cisco_url_filter_file" ]; then
  echo "Usage: $0 -f <firewall_type> -c <csv_url> -r <cisco_url_filter_file>"
  exit 1
fi

# Function to create an inbound drop rule based on firewall type
create_firewall_rule() {
  case "$1" in
    "iptables")
      # Create an inbound drop rule for iptables
      iptables -A INPUT -j DROP
      echo "Inbound drop rule added to iptables."
      ;;
    "cisco")
      # Create an inbound drop rule for Cisco firewall (ASA)
      # Replace 'ACCESS-LIST' and 'SOURCE-IP' with actual values
      cisco_cmd="access-list ACCESS-LIST deny ip SOURCE-IP any"
      echo "$cisco_cmd"
      ;;
    "netscreen")
      # Create an inbound drop rule for Netscreen firewall
      # Replace 'POLICY-NAME' with an actual policy name
      netscreen_cmd="set policy id POLICY-NAME from untrust to trust any any any deny"
      echo "$netscreen_cmd"
      ;;
    "windows")
      # Create an inbound drop rule for Windows Firewall (using netsh)
      # Replace 'RULE-NAME' with a unique rule name
      windows_cmd="netsh advfirewall firewall add rule name='RULE-NAME' dir=in action=block enable=yes"
      echo "$windows_cmd"
      ;;
    "macos")
      # Create an inbound drop rule for Mac OS X Firewall (using pfctl)
      # This is a basic example, more advanced rules may be needed
      macos_cmd="echo 'block in all' | sudo pfctl -f -"
      echo "$macos_cmd"
      ;;
    *)
      echo "Invalid firewall option: $1"
      exit 1
      ;;
  esac
}

# Call the function to create the firewall rule
create_firewall_rule "$firewall_type"


#Download and parse the CSV file, creating Cisco URL filter rules for domain names
curl -sL "$csv_url" | awk -F',' '$1 ~ /^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/ { print "Create URL Filter Rule for Domain: " $1 }' > "$cisco_url_filter_file"

# Shift past the processed options
shift $((OPTIND-1))

# Function to create an inbound drop rule for iptables
create_iptables_rule() {
  iptables -A INPUT -j DROP
  echo "Inbound drop rule added to iptables."
}

# Function to create an inbound drop rule for Cisco firewall
create_cisco_rule() {
  # Replace 'ACCESS-LIST' and 'SOURCE-IP' with actual values
  cisco_cmd="access-list ACCESS-LIST deny ip SOURCE-IP any"
  echo "$cisco_cmd"
}

# Function to create an inbound drop rule for Netscreen firewall
create_netscreen_rule() {
  # Replace 'POLICY-NAME' with an actual policy name
  netscreen_cmd="set policy id POLICY-NAME from untrust to trust any any any deny"
  echo "$netscreen_cmd"
}

# Function to create an inbound drop rule for Windows Firewall
create_windows_rule() {
  # Replace 'RULE-NAME' with a unique rule name
  windows_cmd="netsh advfirewall firewall add rule name='RULE-NAME' dir=in action=block enable=yes"
  echo "$windows_cmd"
}

# Function to create an inbound drop rule for Mac OS X Firewall
create_macos_rule() {
  # This is a basic example; more advanced rules may be needed
  macos_cmd="echo 'block in all' | sudo pfctl -f -"
  echo "$macos_cmd"
}

# Function to create Cisco URL filter rules from CSV (only domain names)
create_cisco_url_filter_rules() {
  # Download and parse the CSV file, creating Cisco URL filter rules for domain names
  curl -sL "$1" | awk -F',' '$1 ~ /^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/ { print "Create URL Filter Rule for Domain: " $1 }' > "$2"
  echo "Cisco URL filter rules created in $2."
}



# Function to create Cisco URL filter rules from CSV (only domain names)
create_cisco_url_filter_rules() {
  # Download and parse the CSV file, creating Cisco URL filter rules for domain names
  curl -sL "$1" | awk -F',' '$1 ~ /^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/ { print "Create URL Filter Rule for Domain: " $1 }' > "$2"
  echo "Cisco URL filter rules created in $2."
}

# Display the main menu
while true; do
  clear
  echo "Security Administration Menu"
  echo "1. Create Inbound Drop Rule for iptables"
  echo "2. Create Inbound Drop Rule for Cisco Firewall"
  echo "3. Create Inbound Drop Rule for Netscreen Firewall"
  echo "4. Create Inbound Drop Rule for Windows Firewall"
  echo "5. Create Inbound Drop Rule for Mac OS X Firewall"
  echo "6. Create Cisco URL Filter Rules for Domain Names"
  echo "7. Quit"

  read -p "Select an option (1-7): " choice

  case $choice in
    1)
      create_iptables_rule
      read -p "Press Enter to continue..."
      ;;
    2)
      create_cisco_rule
      read -p "Press Enter to continue..."
      ;;
    3)
      create_netscreen_rule
      read -p "Press Enter to continue..."
      ;;
    4)
      create_windows_rule
      read -p "Press Enter to continue..."
      ;;
    5)
      create_macos_rule
      read -p "Press Enter to continue..."
      ;;
    6)
      read -p "Enter CSV URL: " csv_url
      read -p "Enter output file for Cisco URL filter rules: " cisco_url_filter_file
      create_cisco_url_filter_rules "$csv_url" "$cisco_url_filter_file"
      read -p "Press Enter to continue..."
      ;;
    7)
      echo "Exiting the Security Administration Menu."
      exit 0
      ;;
    *)
      echo "Invalid option. Please enter a valid option (1-7)."
      read -p "Press Enter to continue..."
      ;;
  esac
done
