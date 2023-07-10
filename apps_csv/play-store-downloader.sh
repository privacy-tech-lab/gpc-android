#!/bin/bash
EMAIL='tanwesley407@gmail.com'  # replace with your email
PASSWORD='privacytechlab'  # replace with your password

# Read the CSV file
while IFS=$',' read -r APP_ID TITLE DEVELOPER SCORE
do
    # Skip the header
    if [ "$APP_ID" != "APP_ID" ]
    then
        echo "Downloading App with ID $APP_ID, titled: $TITLE..."
        apkeep -a $APP_ID -d google-play -o split_apk=1 -u $EMAIL -p $PASSWORD .
    fi
done < apps-AUTO_AND_VEHICLES.csv # replace the csv file
