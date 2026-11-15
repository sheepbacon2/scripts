#!/bin/bash
#this basically does something 
xrandr --output "DP-1" --set audio force-dvi --mode 1920x1080

#first output is for the internal monitor which is my laptop and sets LVDS aka other monitor to the right
xrandr --output "LVDS-1" --auto --output "DP-1" --above "LVDS-1"




