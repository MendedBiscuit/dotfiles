#!/usr/bin/env sh

pkill swww-daemon
swww-daemon --format xrgb &

while ! swww query >/dev/null 2>&1; do
    sleep 0.2
done

swww img ~/.config/sway/assets/3.jpg
