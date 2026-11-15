network=$(nmcli d w l | awk '{print $2,$5}' )
selected_network=$(echo "$network" | dmenu -l 10 -p "wifi networks" | awk '{print $1}')
nmcli d w c $selected_network

