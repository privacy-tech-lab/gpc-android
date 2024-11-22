current_dir=$(pwd)

APP_LIST="$current_dir/app-list.txt"
SCRIPT_PATH="$current_dir/single-app-automation-script.sh"

while read TARGET_PACKAGE_NAME <&3
do
    echo $TARGET_PACKAGE_NAME
    timeout 600 "$SCRIPT_PATH" "$TARGET_PACKAGE_NAME"

    exit_status=$?
    if [[ $exit_status -eq 124 ]]; then
        echo "$TARGET_PACKAGE_NAME" >> app_fail.txt
    fi

done 3<$APP_LIST

cd $current_dir