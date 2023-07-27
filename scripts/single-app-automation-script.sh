#!/bin/bash

SCRIPT_PATH="/Users/nishantaggarwal/Documents/git-repositories/privacy-tech-lab/gpc-android/scripts/basic-automation-script.sh"
APP_LIST="/Users/nishantaggarwal/Documents/Apps/GAME_ACTION/apps-GAME_ACTION.txt"
INSTALL_PATH="/Users/nishantaggarwal/Documents/Apps/GAME_ACTION"

killwait ()
{
  (sleep 1; kill $1) &
  wait $1
}

# Function to install split APKs
install_app() {
  local apk="$1.apk"

  if test -f "$apk"; then
    adb install $apk
  else
    local apk_dir="$1"
    # Find all split APK files within the directory
    local apks=$(find "$apk_dir" -name "*.apk")
    # Install the APKs using adb
    adb install-multiple $apks
  fi

}

# Function to re-install split APKs while granting all permissions
reinstall_app() {
  local apk="$1.apk"

  if test -f "$apk"; then
    adb install -r -g $apk
  else
    local apk_dir="$1"
    # Find all split APK files within the directory
    local apks=$(find "$apk_dir" -name "*.apk")
    # Install the APKs using adb
    adb install-multiple -r -g $apks
  fi

}

TARGET_PACKAGE_NAME=$1

# Do something with the line
echo "Processing line: $TARGET_PACKAGE_NAME"

# TODO: GET THE ADID AND SAVE IT IN A FILE WITH PACKAGE NAME
content=$(adb shell 'su -c "grep adid_key /data/data/com.google.android.gms/shared_prefs/adid_settings.xml"')
extracted_string=$(echo "$content" | sed -n 's/.*<string name="adid_key">\([^<]*\)<\/string>.*/\1/p')

echo "$TARGET_PACKAGE_NAME: $extracted_string" >> APP_ADID.txt

# INSTALL THE APP
cd $INSTALL_PATH
# /Users/nishantaggarwal/.cargo/bin/apkeep -a $TARGET_PACKAGE_NAME .
#adb install "$TARGET_PACKAGE_NAME.apk"
install_app $TARGET_PACKAGE_NAME
sleep 2    

# WITH ADID
TYPE="_ADID"
( source $SCRIPT_PATH $TARGET_PACKAGE_NAME $TYPE)
echo "ADID DONE!"
sleep 2

# WITH PERMISSIONS
#./../aapt2 d permissions net.wordbit.enes.apk | sed -n -e "s/'//g" -e "/^uses-permission: name=android.permission\./s/^[^=]*=//p"
# adb shell cmd appops get net.wordbit.enes
# adb shell pm list permissions -g -d | awk -F: '/permission:/ {print $2}'
# Alternative reinstall app while granting  permissions
reinstall_app $TARGET_PACKAGE_NAME
TYPE="_ADID_PERMISSIONS"
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
sleep 2
adb shell input tap 763 538
sleep 1
adb shell input tap 890 1392
sleep 1
echo "AdId Deleted!"

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
adb shell pm uninstall $TARGET_PACKAGE_NAME

# RE-TURN ON THE ADID
adb shell am start -n com.google.android.gms/.ads.settings.AdsSettingsActivity
sleep 1
adb shell input tap 763 538
sleep 1