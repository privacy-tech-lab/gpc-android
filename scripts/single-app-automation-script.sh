#!/bin/bash

current_dir=$(pwd)
SCRIPT_PATH="$current_dir/../scripts/basic-automation-script.sh"
INSTALL_PATH="$current_dir/../apps"

killwait ()
{
  (sleep 1; kill $1) &
  wait $1
}

# Function to save the Permssions
save_permissions () {
adb shell su -c dumpsys package $1 | awk '/runtime permissions:/, /^[^ ]/{ if (!/^[^ ]/) print $0 }' > permissions.txt
adb shell su -c pm clear $1
}

# Function to retrieve Permissions
retrieve_permissions () {
local package_name="$1"
cat permissions.txt | grep "granted=true" | awk -F':' '{print $1}' | while read permission; do
    echo "$TARGET_PACKAGE_NAME : $permission"
    adb </dev/null shell su -c pm grant $package_name $permission
done
}

# Function to install APKs (single or split-apks) without granting permissions
install_app() {
  echo "$INSTALL_PATH"
  local apk="$1.apk"

  if test -f "$apk"; then
    adb install $apk
  else
    local apk_dir="$1"
    local apks=$(find "$apk_dir" -name "*.apk")
    adb install-multiple $apks
  fi

  cd $current_dir

}

# Function to install (single or split) APKs while granting all permissions
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
echo "Processing line: $TARGET_PACKAGE_NAME"

# Retrieve and save the AdID for the app
content=$(adb shell 'su -c "grep adid_key /data/data/com.google.android.gms/shared_prefs/adid_settings.xml"')
extracted_string=$(echo "$content" | sed -n 's/.*<string name="adid_key">\([^<]*\)<\/string>.*/\1/p')
echo "$TARGET_PACKAGE_NAME: $extracted_string" >> APP_ADID.txt

# Install the app
cd $INSTALL_PATH
install_app $TARGET_PACKAGE_NAME
sleep 2   

#  ====== CAPTURES UNDER DIFFERENT CONDITIONS ======

# INITIAL CAPTURE ADID
TYPE="_ADID"
( source $SCRIPT_PATH $TARGET_PACKAGE_NAME $TYPE)
echo "Initial Adid Done!"
adb shell su -c pm clear $TARGET_PACKAGE_NAME

# WITH ADID
TYPE="_ADID_2"
( source $SCRIPT_PATH $TARGET_PACKAGE_NAME $TYPE)
echo "ADID DONE!"
sleep 2
adb shell su -c pm clear $TARGET_PACKAGE_NAME

# WITH PERMISSIONS
reinstall_app $TARGET_PACKAGE_NAME
TYPE="_ADID_PERMISSIONS"
( source $SCRIPT_PATH $TARGET_PACKAGE_NAME $TYPE)
echo "ADID DONE!"
sleep 2 

# WITH GPC
TYPE="_ADID_GPC"
save_permissions $TARGET_PACKAGE_NAME
retrieve_permissions $TARGET_PACKAGE_NAME
echo "ADID+GPC STARTED!"
sleep 2
( source $SCRIPT_PATH $TARGET_PACKAGE_NAME $TYPE)
echo "ADID+GPC DONE!"
sleep 2

# DELETED ADID
adb shell am start -n com.google.android.gms/.adid.settings.AdsSettingsActivity
sleep 2
adb shell input tap 763 538
sleep 1
adb shell input tap 890 1392
sleep 1
echo "AdId Deleted!"

TYPE="_NO_ADID"
save_permissions $TARGET_PACKAGE_NAME
retrieve_permissions $TARGET_PACKAGE_NAME
echo "NO ADID STARTED!"
sleep 2
( source $SCRIPT_PATH $TARGET_PACKAGE_NAME $TYPE)
echo "NO ADID DONE!"
sleep 2

# DELETE ADID + FORCE QUIT
adb shell am force-stop $TARGET_PACKAGE_NAME
TYPE="_NO_ADID_QUIT"
save_permissions $TARGET_PACKAGE_NAME
retrieve_permissions $TARGET_PACKAGE_NAME
( source $SCRIPT_PATH $TARGET_PACKAGE_NAME $TYPE)
echo "NO ADID+QUIT DONE!"
sleep 2

# DELETE ADID + GPC
TYPE="_NO_ADID_GPC"
save_permissions $TARGET_PACKAGE_NAME
retrieve_permissions $TARGET_PACKAGE_NAME
( source $SCRIPT_PATH $TARGET_PACKAGE_NAME $TYPE)
echo "NO ADID+GPC DONE!"
sleep 2

# UNINSTALL THE APP
adb shell pm uninstall $TARGET_PACKAGE_NAME

# RE-TURN ON THE ADID
adb shell am start -n com.google.android.gms/.adid.settings.AdsSettingsActivity
sleep 1
adb shell input tap 763 538
sleep 1