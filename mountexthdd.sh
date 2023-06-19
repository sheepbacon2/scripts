#!/bin/bash
#if
#	sudo umount /media/externalhdd4tb ; then 
#	echo successfully unmounted
#else 
#	echo ubadstarsx?
#fi
#!/bin/bash

device="/dev/sdc2"
mount_point="/media/externalhdd4tb"

if mount | grep -q "$device"; then
    echo "Device already mounted. Unmounting..."
    sudo umount "$device"
    echo "Device unmounted successfully."
else
    echo "Mounting device..."
    sudo mount "$device" "$mount_point"
    if [ $? -eq 0 ]; then
        echo "Device mounted successfully on $mount_point."
    else
        echo "Failed to mount the device."
    fi
fi

