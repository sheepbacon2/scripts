#!/bin/bash
#switch back to regular mode for multiple monitors
cabletype=$(xrandr | awk '/\*/ {next} /connected/ {print $1}')
selected_cabletype=$(echo "$cabletype" | dmenu -l 10 -p "Disconnect selected cabletype") 
xrandr --output "LVDS-1" --auto --output "$selected_cabletype" --off 

#--output "DP-1" --off 
