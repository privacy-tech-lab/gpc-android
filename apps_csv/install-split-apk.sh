#!/bin/bash

# Directory containing folders with APK files
APK_PARENT_DIR="/Users/wesleysimeontan/Desktop/ptl-google-play-scraper/install-apps-here/test-folder-workflow"

# Device ID
DEVICE_ID="emulator-5554"

# Function to install split APKs
install_split_apks() {
    local apk_dir="$1"
    echo "Installing APKs from $apk_dir..."

    # Find all split APK files within the directory
    local apks=$(find "$APK_PARENT_DIR/$apk_dir" -name "*.apk")

    # Install the APKs using adb
    adb -s $DEVICE_ID install-multiple $apks
}

# Ensure ADB is connected and can see your device
adb devices

# Main script execution

# Get all subdirectories in the parent directory
app_dirs=$(ls -d "$APK_PARENT_DIR"/*/)

# Install each set of split APKs
for apk_dir in $app_dirs; do
    # Extract the directory name from the path
    apk_dir=$(basename "$apk_dir")

    # Install the APKs
    install_split_apks "$apk_dir"
done
