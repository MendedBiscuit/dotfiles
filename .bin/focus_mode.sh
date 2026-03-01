#!/bin/bash

REAL_USER=$(logname 2>/dev/null || echo $USER)

send_notification() {
    if [ -n "$DISPLAY" ]; then
        sudo -u "$REAL_USER" DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u "$REAL_USER")/bus notify-send "$1" "$2" 2>/dev/null
    fi
}

if [ "$1" == "work" ]; then
    sudo cp /etc/hosts.blocked /etc/hosts
    pkill gammastep 2>/dev/null
    send_notification "Focus Mode: ON" "Distractions blocked."
    echo "Work mode enabled. Go get it."

elif [ "$1" == "relax" ]; then
    NUM1=$(( ( RANDOM % 20 )  + 10 ))
    NUM2=$(( ( RANDOM % 10 )  + 5 ))
    RESULT=$(( NUM1 * NUM2 ))
    
    echo "--- UNLOCK SEQUENCE INITIATED ---"
    echo "Solve this to proceed: $NUM1 * $NUM2"
    read -p "Answer: " answer

    if [ "$answer" != "$RESULT" ]; then
        echo "Wrong. Focus on your work."
        exit 1
    fi

    SENTENCE="I am choosing to sacrifice my deep work for cheap dopamine."
    echo -e "\nType the following exactly:"
    echo "$SENTENCE"
    read -p "> " input

    if [ "$input" != "$SENTENCE" ]; then
        echo "Typo detected. Access denied."
        exit 1
    fi

    echo -e "\n Cooldown..."
    for i in {180..1}; do
        printf "\rSeconds remaining: %d " $i
        sleep 1
    done
    echo -e "\n"

    sudo cp /etc/hosts.open /etc/hosts
    send_notification "Focus Mode: OFF" "Distractions unblocked."
    echo "Relax mode enabled. Use it wisely."

else
    echo "Usage: work | relax"
fi
