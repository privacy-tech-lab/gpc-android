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
  <a href="https://privacytechlab.org/"><img src="./wifi.svg" width="200px" height="200px" alt="GPC Android Image"></a>
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

The scripts can be used in conjunction with [mitmproxy](https://mitmproxy.org/) SOCKS5 mode to intercept network traffic.

Run the scripts as follows:

1. Install and configure mitmproxy on your computer.
2. Install the mitmproxy certificate in your computer's Root Certificate directory and to the User Certificate directory of your android phone.
3. Install the [SOCKSdroid](https://play.google.com/store/apps/details?id=net.typeblog.socks&hl=en_US&gl=US) app to reroute traffic from your phone to the proxy server.
4. Start a SOCKS5 proxy on your computer. To do so, execute the following command in your computer:

   ```bash
   mitmdump --mode SOCKS5 -p $PORT_NUMBER
   ```

5. Enter the IP-address and port number of the SOCKS proxy in the SOCKSdroid app and enable the proxy on your phone. You should now be able to intercept network traffic. <br />Note: To avoid problems make sure that your phone and computer are connected to the same wifi network.
6. To use the GPC header the terminal command is

   ```bash
   mitmdump --mode SOCKS5 -p $PORT_NUMBER -s mitm-script.py
   ```

   `mitm-script.py` is available in the scripts folder.

Notice that the above instructions may not allow you to view all network data because of various reasons. To view more of the data you will have to do make a few more changes:

- Most apps don't accept user installed certificates. The suggested way to get around this is to root the device and install the [MagiskTrustUserCerts](https://github.com/NVISOsecurity/MagiskTrustUserCerts) Module to install the certificate into system store. Rooting a device depends on the version of Android you may be using and the manufacturer of your phone; as such we can't provide any instructions on this. Nevertheless, it is encouraged that you use [Magisk](https://magiskmanager.com/#How_to_Install_Magisk_Latest_Version_on_Android_Custom_Recovery_Option) to root the device.

  - The alternative method, without rooting the phone, is to apply the [apk-mitm](https://github.com/shroudedcode/apk-mitm) to the apps you want to analyze.

- Some apps may still not accept the certificate becuase of SSL Pinning. To get around this, install the [Frida](https://github.com/frida/frida) server on your device, and run the `SSL-Unpinning-script` on the desired app. Follow the [HTTP ToolKit Frida guide](https://httptoolkit.com/blog/frida-certificate-pinning/) for instructions on installing and setting up Frida.

- On Rooted devices, Chrome Certificate Transparency prevents network capture of browser data. To fix this issue, install the [MagiskBypassCertificateTransparencyError](https://github.com/JelmerDeHen/MagiskBypassCertificateTransparencyError) Module.

Note that you still may not be able to intercept network traffic for some apps. This is because the SSLUnpinning script we used is not foolproof. There are apps like Instagram that use custom pinning libraries that are very tough to workaround. Nevertheless, this should give you access to network traffic of most of the apps on the Google Play Store.

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
<p align="center">
  <a href="https://www.maastrichtuniversity.nl/about-um/faculties/law/research/law-and-tech-lab"><img src="./maastricht_law_tech.svg" width="300px" height="300px" alt="Logo of Maastricht University Law and Tech Lab"></a>
</p>

