#!bin/bash

#Storyline: Script to perform local security checks

function checks() {
	if [[ $2 != $3 ]]
	then
		echo "The $1 is not compliant. The Current policy is: $2
	else
		echo "The $1 policy is compliant. Current Value is $3."
	fi
}

#Checks the password max days policy
pmax=$(egrep -i '^PASS_MAX_DAYS' /etc/login.defs | awk ' { print $2 } ')
checks "Password Max Days" "365" "${pmax}"

#Checks the password min days policy
pmin=$(egrep -i '^PASS_MIN_DAYS' /etc/login.defs | awk ' { print $2 } ')
checks "Password Min Days" "14" "${pmin}"

#Checks the password warn age policy
pwarn=$(egrep -i '^PASS_WARN_AGE' /etc/login.defs | awk ' { print $2 } ')
checks "Password Warn Age" "7" "${pwarn}"

#Checks the SSH Usepam Configuration
chkSSHPAM=$(egrep -i '^UsePAM' /etc/ssh/sshd_config | awk ' { print $2 } ')
checks "SSH UsePAM" "yes" "${chkSSHPAM}"

#Check permissions on user's home directory
echo ""
for eachDir in $(ls -l /home | egrep '^d' | awk ' { print $3 } ')
do
	chDir=$(ls -ld /home/${eachDir} | awk ' { print $1 } ')
	checks "home Directory ${eachDir}" "drwx------" "${chDir}"

done


# Check if IP forwarding is disabled
ip_fwd=$(cat /proc/sys/net/ipv4/ip_forward)
checks "IP Forwarding" "0" "${ip_fwd}"

# Check if ICMP redirects are not accepted
icmp_rdr=$(cat /proc/sys/net/ipv4/conf/all/accept_redirects)
checks "ICMP Redirects" "0" "${icmp_rdr}"

# Check permissions on cron files
cron_files=(
    "/etc/crontab"
    "/etc/cron.hourly"
    "/etc/cron.daily"
    "/etc/cron.weekly"
    "/etc/cron.monthly"
    "/etc/passwd"
    "/etc/shadow"
    "/etc/group"
    "/etc/gshadow"
    "/etc/passwd-"
    "/etc/shadow-"
    "/etc/group-"
    "/etc/gshadow-"
)

for file in "${cron_files[@]}"; do
    if [[ -f "$file" ]]; then
        perms=$(stat -c "%a %U %G" "$file")
        checks "Permissions on $file" "600 root root" "${perms}"
    fi
done

# Check for legacy "+" entries
legacy_files=("/etc/passwd" "/etc/shadow" "/etc/group")

for file in "${legacy_files[@]}"; do
    if grep -q '^+' "$file"; then
        echo "Found legacy '+' entries in $file"
    else
        echo "No legacy '+' entries found in $file"
    fi
done

# Ensure root is the only UID 0 account
root_uid=$(awk -F: '($3 == "0")' /etc/passwd | wc -l)
checks "Number of UID 0 accounts" "1" "${root_uid}"
