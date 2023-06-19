#!/bin/bash


# Path to the VeraCrypt file container
container="/media/externalhdd4tb/veracrypt"

# Mount point
mount_point="/media/veracrypt"


if mountpoint -q $mount_point; then
    # Unmount the VeraCrypt container
    sudo veracrypt --text --non-interactive --dismount $mount_point
    if [ $? -eq 0 ]; then
	echo "VeraCrypt container unmounted successfully."
    else
	echo "Failed to unmount the VeraCrypt container."
    fi
else
    # Prompt for the password
    read -s -p "Enter the password for the VeraCrypt container: " password
    echo

    # Mount the VeraCrypt container
    sudo veracrypt --text --non-interactive --mount $container $mount_point -p "$password"

    if [ $? -eq 0 ]; then
	echo "VeraCrypt container mounted successfully at $mount_point."
	
	# Perform operations on the mounted container
	# Add your desired operations here
	
	# Check if the VeraCrypt container is mounted
    else
	echo "Failed to mount the VeraCrypt container."
    fi
fi
