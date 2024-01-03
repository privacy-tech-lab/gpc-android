#!/bin/bash

# Create an array of subdirectories in the Apps folder
subdirs=($(find /mnt/d/Apps -mindepth 1 -type d))

# Loop through each subdirectory
for subdir in "${subdirs[@]}"
do
    # Get the name of the subdirectory
    subdir_name=$(basename "$subdir")  

    # Create an array of APK files in the current subdirectory
    apk_files=($(find "$subdir" -name "*.apk"))

    # Loop through each APK file in the subdirectory
    for apk_file in "${apk_files[@]}"
    do
        # Run ./exodus_privacy on the APK file and save the output to a temporary file
        ./exodus_analyze.py -j "$apk_file" >> temp_results.txt
    done

    # Create a JSON object with the results for the current subdirectory
    jq -n --arg subdir_name "$subdir_name" --slurpfile results temp_results.txt '{($subdir_name): $results}' >> final_results.json

    # Clear the temporary file for the next iteration
    > temp_results.txt
done
