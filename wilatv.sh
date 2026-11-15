#!/bin/bash
#this basically does something 
#$out "HDMI-1" --set audio force-dvi --mode 1920x1080i
xrandr --output "HDMI-1" --auto
xrandr --output "HDMI-1"  --set audio force-dvi --panning 1920x1080i  --mode 1920x1080i 
#first output is for the internal monitor which is my laptop and sets LVDS aka other monitor to the right
#xrandr --set audio force-dvi
xrandr --output "LVDS-1" --auto --output "HDMI-1" --above "LVDS-1"

#Transform syntax: --transform <a>,<b>,<c>,<d>,<e>,<f>,<g>,<h>,<i>	
#Default values: 1,0,0,0,1,0,0,0,1
#Typically, a and e corresponds to the scaling on the X and Y axes, c and f specify the x and y offset of the area, and g, h, and i are respectively 0, 0 and 1.


