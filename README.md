<p align="center">
  <a href="https://github.com/privacy-tech-lab/gpc-android/releases"><img alt="GitHub release (latest by date)" src="https://img.shields.io/github/v/release/privacy-tech-lab/gpc-android"></a>
  <a href="https://github.com/privacy-tech-lab/gpc-android/releases"><img alt="GitHub Release Date" src="https://img.shields.io/github/release-date/privacy-tech-lab/gpc-android"></a>
  <a href="https://github.com/privacy-tech-lab/gpc-android/commits/main"><img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/privacy-tech-lab/gpc-android"></a>
  <a href="https://github.com/privacy-tech-lab/gpc-android/issues"><img alt="GitHub issues" src="https://img.shields.io/github/issues-raw/privacy-tech-lab/gpc-android"></a>
  <a href="https://github.com/privacy-tech-lab/gpc-android/issues?q=is%3Aissue+is%3Aclosed"><img alt="GitHub closed issues" src="https://img.shields.io/github/issues-closed-raw/privacy-tech-lab/gpc-android"></a>
  <a href="https://github.com/privacy-tech-lab/gpc-android/blob/main/LICENSE.md"><img alt="GitHub" src="https://img.shields.io/github/license/privacy-tech-lab/gpc-android"></a>
  <a href="https://github.com/privacy-tech-lab/gpc-android/watchers"><img alt="GitHub watchers" src="https://img.shields.io/github/watchers/privacy-tech-lab/gpc-android?style=social"></a>
  <a href="https://github.com/privacy-tech-lab/gpc-android/stargazers"><img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/privacy-tech-lab/gpc-android?style=social"></a>
  <a href="https://github.com/privacy-tech-lab/gpc-android/network/members"><img alt="GitHub forks" src="https://img.shields.io/github/forks/privacy-tech-lab/gpc-android?style=social"></a>
</p>
  
<br>

<p align="center">
  <a href="https://privacytechlab.org/"><img src="./gpc-logo-small-black.svg" width="200px" height="200px" alt="GPC logo"></a>
</p>

# GPC Android

This repo contains code and analysis scripts for GPC on Android.

GPC Android is developed and maintained by Nishant Aggarwal (@n-aggarwal), Wesley Tan (@wesley-tan), Konrad Kollnig (@kasnder), and Sebastian Zimmeck (@SebastianZimmeck) of the [Law and Tech Lab of Maastricht University](https://www.maastrichtuniversity.nl/about-um/faculties/law/research/law-and-tech-lab) and the [privacy-tech-lab of Wesleyan University](https://privacytechlab.org/).

[1. Repo Overview](#1-repo-overview)  
[2. GPC Android App](#2-gpc-android-app)  
[3. Scripts](#3-scripts)  
[4. Apps CSV](#4-apps-csv)  
[5. Thank You!](#5-thank-you)

## 1. Repo Overview

This repo contains the following directories:

- `gpc-android-app`: GPC Android app written in Java
- `scripts`: Code for intercepting and analyzing network traffic
- `app-csv`: App lists sorted by Google Play Store categories

## 2. GPC Android App

The gpc-android-app directory contains the code for an app with the following features:

1. Directing people to the AdID setting, where they can disable tracking
2. Directing people to DuckDuckGo or Brave, two browsers with GPC enabled

You can run the app by cloning this repo and running it in [Android Studio](https://developer.android.com/studio).

## 3. Scripts

The scripts can be used in conjunction with [mitmproxy](https://mitmproxy.org/), with the WireGuard method, to intercept network traffic.

Run the scripts as follows:

1. Download the WireGuard app to your phone through the Google Play Store.
2. Run in the terminal of your computer

   ```bash
   mitmweb --mode
   ```

   Note this step assumes that mitmproxy has been installed and configured correctly on the phone. Now a new tab should open in your browser. This tab will contain a QR code. Scan the QR code using the WireGuard app you installed on your phone and save it.

3. Now you can turn on a VPN tunnel in the WireGuard app, and all the traffic should be intercepted.
4. To use the GPC header the terminal command is

   ```bash
   mitmweb --mode wireguard -s mitm-script.py
   ```

   where mitm-script.py is the name of the script file.

5. Use [apk-mitm](https://github.com/shroudedcode/apk-mitm) on the APK. Otherwise, the TSL handshake will not work. You should then see the indicator that GPC is enabled: `"Sec-GPC: 1"`.

## 4. Apps CSV

The apps_csv directory contains a collection of CSV files, each representing a category of apps on the Google Play Store. Each file contains a list of the top 40 free apps for a category.

### 4.1 Directory Contents

The directory contains the following files:

- Multiple CSV files named as `apps_<CATEGORY>.csv` where CATEGORY is the category name from the Google Play Store
- A JavaScript file, trial-play-scraper.js, which is used to scrape app data from the Google Play Store
- A bash shell script play-store-downloader.sh, which reads a CSV file and downloads the corresponding apps

Each CSV file is named after a category on the Google Play Store, for example apps_ART-AND-DESIGN.csv. Each CSV file contains the following columns:

- APP_ID: the unique ID of the app on the Google Play Store
- TITLE: the title of the app
- DEVELOPER: the developer of the app
- SCORE: the score of the app on the Google Play Store
- Each CSV file contains the top 40 free apps for that category

### 4.2 How to Use

1. Clone the repo to your local machine and navigate to the app_csv directory.
2. To scrape app metadata from the Google Play Store for a particular category, use the trial-play-scraper.js file run

   ```bash
   node trial-play-scraper.js
   ```

3. Download APKs from the Google Play Store with

   ```bash
   chmod +x play-store-downloader.sh
   ./play-store-downloader.sh
   ```

   Before running the downloader script replace `email@gmail.com` and `password` in the play-store-downloader.sh file with your Google Play Store email and password, respectively. Then, give the script execution permissions and run it. Doing so will download all the apps listed in the apps-ART_AND_DESIGN.csv file. To download apps from a different category, replace apps-ART_AND_DESIGN.csv with the desired CSV file name in the script.

## 5. Thank You!

<p align="center"><strong>We would like to thank our financial supporters!</strong></p><br>

<p align="center">Major financial support provided by the National Science Foundation.</p>

<p align="center">
  <a href="https://nsf.gov/awardsearch/showAward?AWD_ID=2055196">
    <img class="img-fluid" src="./nsf.png" height="100px" alt="National Science Foundation Logo">
  </a>
</p>

<p align="center">Additional financial support provided by the Alfred P. Sloan Foundation, Wesleyan University, and the Anil Fernando Endowment.</p>

<p align="center">
  <a href="https://sloan.org/grant-detail/9631">
    <img class="img-fluid" src="./sloan_logo.jpg" height="70px" alt="Sloan Foundation Logo">
  </a>
  <a href="https://www.wesleyan.edu/mathcs/cs/index.html">
    <img class="img-fluid" src="./wesleyan_shield.png" height="70px" alt="Wesleyan University Logo">
  </a>
</p>

<p align="center">Conclusions reached or positions taken are our own and not necessarily those of our financial supporters, its trustees, officers, or staff.</p>

##

<p align="center">
  <a href="https://privacytechlab.org/"><img src="./plt_logo.png" width="200px" height="200px" alt="privacy-tech-lab logo"></a>
<p>
