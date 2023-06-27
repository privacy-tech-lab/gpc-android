APP_LIST="/Users/nishantaggarwal/Documents/git-repositories/privacy-tech-lab/gpc-android/scripts/app-list.txt"
SCRIPT_PATH="/Users/nishantaggarwal/Documents/git-repositories/privacy-tech-lab/gpc-android/scripts/bulk-automation-script.sh"

while read TARGET_PACKAGE_NAME <&3
do
    echo $TARGET_PACKAGE_NAME
    timeout 300 "$SCRIPT_PATH" "$TARGET_PACKAGE_NAME"
done 3<$APP_LIST