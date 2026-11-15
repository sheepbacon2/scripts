#!/bin/bash

while true; do
    # Mark the currently focused window
    i3-msg 'mark --add current_window'

    # Focus Roblox window (sober)
    i3-msg '[class="org.vinegarhq.Sober"] focus'

    #sleep .2
    # Press space
    xdotool key --repeat 10 --delay 30 space
    # Refocus the original window
    sleep .3
    i3-msg '[con_mark="current_window"] focus'

    # Unmark it so next cycle re-marks the new focused window
    i3-msg 'unmark current_window'

    # Delay 15 minutes
    sleep 900
done
