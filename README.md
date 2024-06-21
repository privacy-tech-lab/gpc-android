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
  <a href="https://github.com/sponsors/privacy-tech-lab"><img alt="GitHub sponsors" src="https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=%23fe8e86"></a>
</p>

<br>

<p align="center">
  <a href="https://privacytechlab.org/"><img src="./wifi.svg" width="200px" height="200px" alt="GPC Android Image"></a>
</p>

# GPC Android

This repo contains code and other resources for dynamically analyzing Android apps, especially, for checking their compliance with [Global Privacy Control (GPC)](https://globalprivacycontrol.org/). GPC is a privacy preference signal for opting out from ad tracking. Apps are required to respect GPC signals per the California Consumer Privacy Act (CCPA) and other privacy laws.

The code and all other resources in this repo are developed and maintained by **Nishant Aggarwal (@n-aggarwal)**, **Zachary Liu (@zatchliu)** and **Sebastian Zimmeck (@SebastianZimmeck)** of the [privacy-tech-lab](https://privacytechlab.org/) and **Konrad Kollnig (@kasnder)** of the [Law and Tech Lab of Maastricht University](https://www.maastrichtuniversity.nl/about-um/faculties/law/research/law-and-tech-lab). Wesley Tan (@wesley-tan) contributed earlier.

[1. Research Publications](#1-research-publications)  
[2. Repo Overview](#2-repo-overview)  
[3. GPC Android App](#3-gpc-android-app)  
[4. Scripts](#4-scripts)  
[5. Apps CSV](#5-apps-csv)  
[6. Thank You!](#7-thank-you)

## 1. Research Publications

Sebastian Zimmeck, Nishant Aggarwal, Zachary Liu and Konrad Kollnig, [From Ad Identifiers to Global Privacy Control: The Status Quo and Future of Opting Out of Ad Tracking on Android](), Under Review at 25th Privacy Enhancing Technologies Symposium (PETS), Washington, DC, United States and Online Event, July 2025, [BibTeX]().

If you are using code or other resources from this repo, please cite the above paper.

You can find a complete list of our GPC research publications in the [GPC OptMeowt repo](https://github.com/privacy-tech-lab/gpc-optmeowt?tab=readme-ov-file#1-research-publications).

## 2. Repo Overview

This repo contains the following resources:

- `gpc-android-app`: GPC Android app written in Java
- `scripts`: Code for dynamically intercepting and analyzing network traffic
- `app_csv`: App lists sorted by Google Play Store categories

## 3. GPC Android App

The `gpc-android-app` directory contains the code for an app with the following features:

1. Directing people to the AdID setting, where they can disable tracking, which, in our view, is equivalent to turning on GPC
2. Directing people to DuckDuckGo or Brave, two browsers with GPC enabled

You can run the app by cloning this repo and running it in [Android Studio](https://developer.android.com/studio).

## 4. Scripts

The scripts can be used in conjunction with [mitmproxy](https://mitmproxy.org/) SOCKS5 mode to intercept network traffic and perform dynamic privacy analysis on Android apps.

Run the scripts as follows:

1. Install and configure mitmproxy on your computer.
2. Install the mitmproxy certificate in your computer's Root Certificate directory and to the User Certificate directory of your Android phone.
3. Install the [SOCKSdroid app](https://play.google.com/store/apps/details?id=net.typeblog.socks&hl=en_US&gl=US) to reroute traffic from your phone to the proxy server.
4. Start a SOCKS5 proxy on your computer. To do so, execute the following command in your terminal:

   ```bash
   mitmdump --mode SOCKS5 -p $PORT_NUMBER
   ```

5. Enter the IP address and port number of the SOCKS proxy in the SOCKSdroid app and enable the proxy on your phone. You should now be able to intercept network traffic.

   **Note**: To avoid problems make sure that your phone and computer are connected to the same Wi-Fi network.

6. In order to check how an app behaves if it receives GPC signals, you can inject GPC headers with the terminal command:

   ```bash
   mitmdump --mode SOCKS5 -p $PORT_NUMBER -s mitm-script.py
   ```

   `mitm-script.py` is available in the scripts folder.

**Note**: The above instructions may not allow you to view all network traffic because apps may use SSL Pinning or other defenses against network traffic analysis. To view more of the data you will have to do make a few more changes:

- Most apps do not accept user installed certificates. The suggested way to get around this limitation is to root the device and install the [MagiskTrustUserCerts Module](https://github.com/NVISOsecurity/MagiskTrustUserCerts) to install the certificate into the system store. Rooting a device depends on the version of Android you are using and the manufacturer of your phone; as such we are not able to provide detailed instructions on this. Nevertheless, using [Magisk](https://magiskmanager.com/#How_to_Install_Magisk_Latest_Version_on_Android_Custom_Recovery_Option) is a good starting point to root the device.

  As an alternative to rooting the phone you can apply the [apk-mitm](https://github.com/shroudedcode/apk-mitm) to the apps you want to analyze.

- Some apps may still not accept the certificate because of SSL Pinning. To get around this, install the [Frida server](https://github.com/frida/frida) on your device and run the `SSL-Unpinning-script` on the desired app. Follow the [HTTP ToolKit Frida guide](https://httptoolkit.com/blog/frida-certificate-pinning/) for instructions on installing and setting up Frida.

- On rooted devices, Chrome Certificate Transparency prevents network capture of browser data. To get around this issue, install the [MagiskBypassCertificateTransparencyError Module](https://github.com/JelmerDeHen/MagiskBypassCertificateTransparencyError).

  **Note**: You still may not be able to intercept network traffic for some apps. This is because the SSLUnpinning script we use is not foolproof. There are apps like Instagram that use custom pinning libraries that are very tough to workaround. Nevertheless, performing the above measures should give you access to network traffic of most of apps on the Google Play Store.

## 5. Apps CSV

The `apps_csv directory` contains a collection of CSV files, each representing a category of apps on the Google Play Store. Each file contains a list of the top 40 free apps for a category.

### 5.1 Directory Contents

The directory contains the following files:

- Multiple CSV files with the naming convention `apps_<CATEGORY>.csv` where CATEGORY is the app category name from the Google Play Store, for example `apps_ART-AND-DESIGN.csv`
- A JavaScript file, `trial-play-scraper.js`, which can be used to scrape app data from the Google Play Store
- A bash shell script `play-store-downloader.sh`, which reads a CSV file and downloads the corresponding apps

Each CSV file contains the following columns:

- `APP_ID`: the unique ID of the app on the Google Play Store
- `TITLE`: the title of the app
- `DEVELOPER`: the developer of the app
- `SCORE`: the score of the app on the Google Play Store

### 5.2 How to Use

1. Clone this repo to your local machine with:

   ```bash
   git clone https://github.com/privacy-tech-lab/gpc-android.git
   ```

   Then, navigate to the `app_csv` directory.

2. To scrape app metadata from the Google Play Store for a particular category, first make sure you have [Node.js](https://nodejs.org/en) installed.

3. Then, run the `trial-play-scraper.js` script with:

   ```bash
   node trial-play-scraper.js
   ```

4. To download APKs from the Google Play Store with the `play-store-downloader.sh` run:

   ```bash
   chmod +x play-store-downloader.sh
   ./play-store-downloader.sh
   ```

   Before running the downloader script replace `email@gmail.com` and `password` in the `play-store-downloader.sh` script with your Google Play Store email and password, respectively. Then, give the script execution permissions and run it. Doing so will download all the apps listed in the `apps-ART_AND_DESIGN.csv` file. To download apps from a different category, replace "apps-ART_AND_DESIGN.csv" with the desired CSV file name in the script.

5. If downloading apps with the `play-store-downloader.sh` fails, you can also use [Raccoon](https://raccoon.onyxbits.de/) as follows:

   1. Make sure to have a US-based IP address (e.g., via a VPN)
   2. Set up an account with Google's US Play Store
   3. Get Raccoon and a Raccoon Premium license. Use Raccoon's DummyDroid to extract the configuration from a real Android device
   4. Choose "Import Apps" in Raccoon and paste all apps' links in there (e.g., <market://details?id=com.fishbrain.app>)
   5. Sit and wait ...

6. If downloading apps with the two previous methods fails, you can also try the `google-play` method through [apkeep](https://github.com/EFForg/apkeep).

## 6. Thank You!

<p align="center"><strong>We would like to thank our supporters!</strong></p><br>

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
  <a href="https://privacytechlab.org/"><img align="center" src="./plt_logo.png" width="auto" height="200px" alt="privacy-tech-lab logo"></a>
  <a href="https://www.maastrichtuniversity.nl/about-um/faculties/law/research/law-and-tech-lab"><img align="center" src="./maastricht_law_tech.jpg" width="auto" height="100px" alt="Logo of Maastricht University Law and Tech Lab"></a>
</p>
