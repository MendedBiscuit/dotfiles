#!/bin/bash

TEMP=3000

if pgrep -x "gammastep" > /dev/null; then
    pkill gammastep
    notify-send "Blue Light Filter" "OFF" --icon=display
else
    gammastep -O $TEMP &
    notify-send "Blue Light Filter" "ON" --icon=display
fi
