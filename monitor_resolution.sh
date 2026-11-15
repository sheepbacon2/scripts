#!/usr/bin/env bash

# Find internal laptop monitor: LVDS-1, eDP-1, etc.
internal_monitor=$(xrandr --query | awk '/ connected/ && $1 ~ /^(LVDS|eDP)/ {print $1; exit}')

if [ -z "$internal_monitor" ]; then
    notify-send "No internal monitor found"
    exit 1
fi

# Get all connected external monitors
external_monitors=$(xrandr --query | awk '/ connected/ && $1 !~ /^(LVDS|eDP)/ {print $1}')

if [ -z "$external_monitors" ]; then
    notify-send "No external monitors detected"
    exit 1
fi

# Select external monitor
selected_monitor=$(echo "$external_monitors" | dmenu -l 10 -p "Select external monitor:")

[ -z "$selected_monitor" ] && exit 0

# Select action
action=$(printf "Extend right\nExtend left\nMirror\nTurn off" | dmenu -p "Action for $selected_monitor:")

[ -z "$action" ] && exit 0

if [ "$action" = "Turn off" ]; then
    xrandr --output "$selected_monitor" --off
    notify-send "$selected_monitor turned off"
    exit 0
fi

# Get available resolutions for selected monitor
resolutions=$(xrandr --query | awk -v mon="$selected_monitor" '
    $1 == mon {found=1; next}
    found && /^[^[:space:]]/ {found=0}
    found && /^[[:space:]]+[0-9]+x[0-9]+/ {print $1}
' | awk '!seen[$0]++')

selected_resolution=$(echo "$resolutions" | dmenu -l 10 -p "Resolution for $selected_monitor:")

[ -z "$selected_resolution" ] && exit 0

case "$action" in
    "Extend right")
        xrandr \
            --output "$internal_monitor" --auto \
            --output "$selected_monitor" --mode "$selected_resolution" --right-of "$internal_monitor"
        ;;

    "Extend left")
        xrandr \
            --output "$internal_monitor" --auto \
            --output "$selected_monitor" --mode "$selected_resolution" --left-of "$internal_monitor"
        ;;

    "Mirror")
        xrandr \
            --output "$internal_monitor" --auto \
            --output "$selected_monitor" --mode "$selected_resolution" --same-as "$internal_monitor"
        ;;

    *)
        exit 0
        ;;
esac

notify-send "$selected_monitor set to $selected_resolution"
