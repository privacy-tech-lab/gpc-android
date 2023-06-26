#!/bin/bash
EMAIL='<email>@gmail.com'  # replace with your email
PASSWORD='<password>'  # replace with your password

# Read the CSV file
while IFS=$',' read -r APP_ID TITLE DEVELOPER SCORE
do
    # Skip the header
    if [ "$APP_ID" != "APP_ID" ]
    then
        echo "Downloading App with ID $APP_ID, titled: $TITLE..."
        apkeep -a $APP_ID -d google-play -u $EMAIL -p $PASSWORD .
    fi
done < apps-ART_AND_DESIGN.csv # replace the csv file
