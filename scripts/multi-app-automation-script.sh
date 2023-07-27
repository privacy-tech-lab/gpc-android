APP_LIST="/Users/nishantaggarwal/Documents/Apps/GAME_ACTION/apps-GAME_ACTION.txt"
SCRIPT_PATH="/Users/nishantaggarwal/Documents/git-repositories/privacy-tech-lab/gpc-android/scripts/single-app-automation-script.sh"

while read TARGET_PACKAGE_NAME <&3
do
    echo $TARGET_PACKAGE_NAME
    timeout 300 "$SCRIPT_PATH" "$TARGET_PACKAGE_NAME"

    exit_status=$?
    if [[ $exit_status -eq 124 ]]; then
        echo "$TARGET_PACKAGE_NAME" >> app_fail.txt
    fi

done 3<$APP_LIST