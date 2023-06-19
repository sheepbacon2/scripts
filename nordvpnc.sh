#!/bin/bash

if nordvpn status | grep -q "Disconnected"; then
   nordvpn c 
else 
   vpncon=$(echo -e "connect to new ip\ndisconnect" | dmenu -l 2) 
   case $vpncon in 
      "connect to new ip")
         nordvpn c
         ;;
      "disconnect")
         nordvpn d 
         ;;
      *)
         echo "invalid option"
         ;;
   esac
fi

