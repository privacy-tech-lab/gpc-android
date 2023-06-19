#!/bin/bash

# Kill Wait Function
killwait ()
{
  (sleep 1; kill $1) &
  wait $1
}

# This will be the variable that will later be set to loop some list...
TARGET_PACKAGE_NAME=$1
TYPE=$2

# Download and Install the App + Grant all permissions
cd /Users/nishantaggarwal/Documents/apks
/Users/nishantaggarwal/.cargo/bin/apkeep -a $TARGET_PACKAGE_NAME .
adb install -g "$TARGET_PACKAGE_NAME.apk"
sleep 2

# Start MITM-Wireguard
mitmdump --mode wireguard --showhost -w /Users/nishantaggarwal/Documents/mitm-captures/$TARGET_PACKAGE_NAME$TYPE.mitm &
MITM_PID=$!
echo "MITM-Proxy started"
sleep 2

# Apply the Frida Script 
frida -U -l /Users/nishantaggarwal/Documents/git-repositories/privacy-tech-lab/gpc-android/scripts/frida-script.js -f $TARGET_PACKAGE_NAME &
FRIDA_PID=$!

# Sleep for testing purposes
sleep 10

# End the frida script
killwait $FRIDA_PID
echo "FRIDA DONE!"
sleep 2

# End MITM-Wireguard
killwait $MITM_PID

# Uninstall the App [the [-k] option allows you to keep the data and cache of the app intact]
adb shell pm uninstall -k $TARGET_PACKAGE_NAME
exec <&-
