#!/bin/bash

SCRIPT_PATH="/Users/nishantaggarwal/Documents/git-repositories/privacy-tech-lab/gpc-android/scripts/automation-script.sh"
APP_LIST="/Users/nishantaggarwal/Documents/git-repositories/privacy-tech-lab/gpc-android/scripts/app-list.txt"
INSTALL_PATH="/Users/nishantaggarwal/Documents/apks"

killwait ()
{
  (sleep 1; kill $1) &
  wait $1
}

TARGET_PACKAGE_NAME=$1

# Do something with the line
echo "Processing line: $TARGET_PACKAGE_NAME"

# TODO: GET THE ADID AND SAVE IT IN A FILE WITH PACKAGE NAME

# INSTALL THE APP
cd $INSTALL_PATH
# /Users/nishantaggarwal/.cargo/bin/apkeep -a $TARGET_PACKAGE_NAME .
adb install -g "$TARGET_PACKAGE_NAME.apk"
sleep 2    

# WITH ADID
TYPE="_ADID"
( source $SCRIPT_PATH $TARGET_PACKAGE_NAME $TYPE)
echo "ADID DONE!"
sleep 2

# WITH GPC
TYPE="_ADID_GPC"
echo "ADID+GPC STARTED!"
sleep 2
( source $SCRIPT_PATH $TARGET_PACKAGE_NAME $TYPE)
echo "ADID+GPC DONE!"
sleep 2

# DELETED ADID
adb shell am start -n com.google.android.gms/.ads.settings.AdsSettingsActivity
sleep 1
adb shell input tap 763 538
sleep 1
adb shell input tap 890 1392
sleep 1

TYPE="_NO_ADID"
echo "NO ADID STARTED!"
sleep 2
( source $SCRIPT_PATH $TARGET_PACKAGE_NAME $TYPE)
echo "NO ADID DONE!"
sleep 2

# DELETE ADID + FORCE QUIT
adb shell am force-stop $TARGET_PACKAGE_NAME
TYPE="_NO_ADID_QUIT"
( source $SCRIPT_PATH $TARGET_PACKAGE_NAME $TYPE)
echo "NO ADID+QUIT DONE!"
sleep 2

# DELETE ADID + GPC
TYPE="_NO_ADID_GPC"
( source $SCRIPT_PATH $TARGET_PACKAGE_NAME $TYPE)
echo "NO ADID+GPC DONE!"
sleep 2

# UNINSTALL THE APP
adb shell pm uninstall -k $TARGET_PACKAGE_NAME

# RE-TURN ON THE ADID
adb shell am start -n com.google.android.gms/.ads.settings.AdsSettingsActivity
sleep 1
adb shell input tap 763 538