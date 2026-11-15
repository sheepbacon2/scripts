#!/usr/bin/env bash

# Get time in minutes from argument or dmenu
if [ -n "$1" ]; then
    time_minutes="$1"
else
    time_minutes=$(echo "" | dmenu -p "Sleep in minutes:")
fi

# Exit if nothing entered
[ -z "$time_minutes" ] && exit 1

# Make sure it is a positive whole number
if ! [[ "$time_minutes" =~ ^[1-9][0-9]*$ ]]; then
    notify-send "Sleep Timer" "Invalid number: $time_minutes"
    exit 1
fi

# Convert to seconds
time_seconds=$((time_minutes * 60))

notify-send "Sleep Timer" "System will suspend in $time_minutes minute(s)."

# Allow Ctrl+C to cancel cleanly
trap 'echo -e "\nSleep timer cancelled."; notify-send "Sleep Timer" "Cancelled"; exit 130' INT

# Countdown
while [ "$time_seconds" -gt 0 ]; do
    hours=$((time_seconds / 3600))
    minutes=$(((time_seconds % 3600) / 60))
    seconds=$((time_seconds % 60))

    printf "\rSuspending in %02d:%02d:%02d  " "$hours" "$minutes" "$seconds"

    sleep 1
    time_seconds=$((time_seconds - 1))
done

printf "\nSuspending now...\n"
notify-send "Sleep Timer" "Suspending now."
systemctl suspend
