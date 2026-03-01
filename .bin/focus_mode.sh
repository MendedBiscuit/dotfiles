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
    
    echo "--- UNLOCK ---"
    echo "Solve this to proceed: $NUM1 * $NUM2"
    read -p "Answer: " answer

    if [ "$answer" != "$RESULT" ]; then
        echo "Err"
        exit 1
    fi

    SENTENCE=""
    echo -e "\nType the following:"
    echo "$SENTENCE"
    read -p "> I write this sitting in the kitchen sink." input

    if [ "$input" != "$SENTENCE" ]; then
        echo "Err"
        exit 1
    fi

    echo -e "\n Cooldown..."
    for i in {180..1}; do
        printf "%d " $i
        sleep 1
    done
    echo -e "\n"

    sudo cp /etc/hosts.open /etc/hosts
    send_notification "Focus Mode: OFF" "Distractions unblocked."
    echo "off"

else
    echo "Usage: work | relax"
fi
