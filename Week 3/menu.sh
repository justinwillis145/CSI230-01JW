!/bin/bash

# Storyline: Menu for admin

function invalid_option() {
    echo "Invalid Option"
    sleep 2
}

function menu() {
    # clear screen
    clear

    echo "[1] List Open Network Sockets"
    echo "[2] Check for Non-Root Users with UID 0"
    echo "[3] Check the Last 10 Logged-in Users"
    echo "[4] See Currently Logged-in Users"
    echo "[5] Exit"
    read -p "Please enter a choice above: " choice

    case "$choice" in
    1)
        echo "List of Open Network Sockets:"
        netstat -a
        ;;
    2)
        echo "Users with UID 0:"
        awk -F: '$3 == 0 && $1 != "root" {print $1}' /etc/passwd
        ;;
    3)
        echo "Last 10 Logged-in Users:"
        last -n 10
        ;;
    4)
        echo "Currently Logged-in Users: "
        who
        ;;
    5)
        echo "Exiting Menu"
        exit 0
        ;;
    *)
        invalid_option
        ;;

    esac
}

# Call the main menu
menu

