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

current_dir=$(pwd)

MITM_PATH="$current_dir/../mitm-captures/$TARGET_PACKAGE_NAME$TYPE.mitm"
HAR_PATH="$current_dir/../mitm-captures/$TARGET_PACKAGE_NAME$TYPE.har"
FRIDA_PATH="$current_dir/frida-script.js"
HAR_SCRIPT_PATH="$current_dir/har_dump.py"
MITM_SCRIPT_PATH="$current_dir/mitm-gpc-script.py"
MITM_DUMMY_SCRIPT_PATH="$current_dir/mitm-dummy-script.py"

# Start MITM-Wireguard
if [ "$TYPE" == "_ADID_GPC" ] || [ "$TYPE" == "_NO_ADID_GPC" ]; then
  mitmdump --mode socks5 -p 8889 -s $MITM_SCRIPT_PATH --showhost -w $MITM_PATH --set hardump=$HAR_PATH &
  MITM_PID=$!
  echo "MITM-Proxy started"
  sleep 2
else 
  mitmdump --mode socks5 -p 8889 -s $MITM_DUMMY_SCRIPT_PATH --showhost -w $MITM_PATH --set hardump=$HAR_PATH &
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
