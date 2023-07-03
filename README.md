# gpc-android

This repo contains code and documentation for implementing GPC on Android. Google is exploring an alternative to Apple Inc.’s new anti-tracking feature, the latest sign that the internet industry is slowly embracing user privacy, according to people with knowledge of the matter.
Contact us with any questions or comments at sebastian@privacytechlab.org.

The repo contains the following
- a folder containing `gpc-android-app`, code for an Android app written in Java
- a folder containing `scripts`, which can be used to intercept network traffic

### gpc-android-app
The gpc-android-app folder contains the code for an app which has the following functions
1. Directs users to DuckDuckGo or Brave, two browsers where GPC is enabled
2. Directs users to the AdID setting, where they can disable the AdID setting.

You can run it using `git clone https://github.com/privacy-tech-lab/gpc-android/gpc-android-app.git` into your Terminal, and subsequently use an emulator, such as Android Studio to run the application

### scripts
The code in scripts can be used in conjunction with mitmproxy with WireGuard method to intercept network traffic
We are currently working on an automated way to analyze network traffic, but our current method is as follows:
1. Download the WireGuard app on the Phone through play store.
2. Next, run the command `mitmweb --mode` wireguard in the terminal (on your computer). Note this step assumes that mitmproxy has been installed and configured correctly on the users device. Now a new tab should open in your browser; this will contain a QR code. Scan the QR code using the WireGuard app you installed on your phone and save it.
3. Now you can turn on this vpn tunnel in the WireGuard app, and all the traffic should be intercepted
4. To use the GPC header, The terminal command now is `mitmweb --mode wireguard -s mitm-script.py` where mitm-script.py is the name of the script file.
5. Use apk-mitm (https://github.com/shroudedcode/apk-mitm) on the apk, else TSL handshake will not work.
You should then see the indicator that GPC enabled; “Sec-GPC: 1”

### apps_csv

The `apps_csv` folder contains a collection of CSV files, each representing a category of apps on the Google Play Store. Each file contains a list of the top 40 free apps for that category. The following instructions will guide you on how to use the content of this folder:

# Structure of the Folder
Multiple CSV files named as `apps_<CATEGORY>.csv` where <CATEGORY> is the category name from the Google Play Store.
A JavaScript file trial-play-scraper.js, which is used to scrape app data from the Google Play Store.
A bash shell script play-store-downloader.sh, which reads a CSV file and downloads the corresponding apps.

Each CSV file is named after a category on the Google Play Store, for example apps_ART-AND-DESIGN.csv. Each CSV file contains the following columns:

APP_ID: the unique ID of the app on the Google Play Store.
TITLE: the title of the app.
DEVELOPER: the developer of the app.
SCORE: the score of the app on the Google Play Store.
Each CSV file contains the top 40 free apps for that category.

# How to Use
Step 1: Clone the Repository
Start by cloning the repository to your local machine, then navigate to the app_csv folder:
``cd app_csv``

Step 2: Use the Scraper
To scrape app data from the Google Play Store for a particular category, use the trial-play-scraper.js file:
``node trial-play-scraper.js``

Step 3: Use the Downloader
Before running the downloader script, remember to replace <email>@gmail.com and <password> in the play-store-downloader.sh file with your Google Play Store email and password respectively.
Then, give the script execution permissions and run it:

```
chmod +x play-store-downloader.sh
./play-store-downloader.sh
```
This will download all the apps listed in the apps-ART_AND_DESIGN.csv file.

To download apps from a different category, replace apps-ART_AND_DESIGN.csv with the desired CSV file name in the script.

# Note
Please be sure to follow all relevant Terms of Service when interacting with the Google Play Store. Misuse of scraping and downloading tools can lead to your account being suspended or banned. Always respect the rights of the app developers and the platform.
