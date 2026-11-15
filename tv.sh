#!/bin/bash
#this basically does something 
#$out "HDMI-1" --set audio force-dvi --mode 1920x1080i
xrandr --output "HDMI-1" --auto
xrandr --output "HDMI-1"  --set audio force-dvi --panning 1920x1080i  --mode 1920x1080i --transform 1.055,0,-50,0,1.055,-34,0,0,1  
 
#xrandr --output "HDMI-1" --auto
#xrandr --output "HDMI-1"  --set audio force-dvi --panning 1280x720 --mode 1280x720 --transform 1.250,0,-20,0,1.150,-124,0,0,1  
xrandr --output "LVDS-1" --auto --output "HDMI-1" --above "LVDS-1"

#Transform syntax: --transform <a>,<b>,<c>,<d>,<e>,<f>,<g>,<h>,<i>	
#Default values: 1,0,0,0,1,0,0,0,1
#Typically, a and e corresponds to the scaling on the X and Y axes, c and f specify the x and y offset of the area, and g, h, and i are respectively 0, 0 and 1.


