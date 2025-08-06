#!/bin/bash
export ANDROID_PRODUCT_OUT=/home/pppig/losv/out/target/product/ovaltine

# ask if waiting for adb device
echo "Waiting for adb device... ? (y/n)"
read answer
if [ "$answer" == "y" ]; then
        # wait for adb device
        adb wait-for-device

        echo "Getting device serial number..." 
        adb get-serialno
        adb reboot fastboot
fi

# List of partitions to flash
partitions=("boot" "dtbo" "vendor_boot" "vendor_dlkm" "recovery")

# Check if fastboot is installed
if ! command -v fastboot &> /dev/null; then
    echo "Error: fastboot not found. Please install Android Platform Tools."
    exit 1
fi

# Flash each image
for part in "${partitions[@]}"; do
        echo "Flashing $part from $img..."
        fastboot flash "$part"
done

# Optional reboot
echo "Rebooting device... ? (y/n)"
read answer
if [ "$answer" == "y" ]; then
        fastboot reboot
fi

echo "Done!"
