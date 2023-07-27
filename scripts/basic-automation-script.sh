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

MITM_PATH="/Users/nishantaggarwal/Documents/mitm-captures/$TARGET_PACKAGE_NAME$TYPE.mitm"
HAR_PATH="/Users/nishantaggarwal/Documents/mitm-captures/$TARGET_PACKAGE_NAME$TYPE.har"
FRIDA_PATH="/Users/nishantaggarwal/Documents/git-repositories/privacy-tech-lab/gpc-android/scripts/frida-script.js"
HAR_SCRIPT_PATH="/Users/nishantaggarwal/Documents/git-repositories/privacy-tech-lab/gpc-android/scripts/har_dump.py"
MITM_SCRIPT_PATH="/Users/nishantaggarwal/Documents/git-repositories/privacy-tech-lab/gpc-android/scripts/mitm-gpc-script.py"

# Start MITM-Wireguard
if [ "$TYPE" == "_ADID_GPC" ] || [ "$TYPE" == "_NO_ADID_GPC" ]; then
  mitmdump --mode socks5 -p 8889 -s $MITM_SCRIPT_PATH --showhost -w $MITM_PATH -s $HAR_SCRIPT_PATH --set hardump=$HAR_PATH &
  MITM_PID=$!
  echo "MITM-Proxy started"
  sleep 2
else 
  mitmdump --mode socks5 -p 8889 --showhost -w $MITM_PATH -s $HAR_SCRIPT_PATH --set hardump=$HAR_PATH &
  MITM_PID=$!
  echo "MITM-Proxy started"
  sleep 2
fi


# Apply the Frida Script 
frida -U -l $FRIDA_PATH -f $TARGET_PACKAGE_NAME &
FRIDA_PID=$!

# Sleep for testing purposes
sleep 30

# End the frida script
killwait $FRIDA_PID
echo "FRIDA DONE!"
sleep 2

# End MITM-Wireguard
killwait $MITM_PID
