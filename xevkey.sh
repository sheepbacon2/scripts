xev | awk '{gsub(/),/,"")}/key/{ print $3,$4,$7}' 
