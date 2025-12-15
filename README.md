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

The code and all other resources in this repo are developed and maintained by **Sage Altman (@sagealtman)**, **Nishant Aggarwal (@n-aggarwal)**, **Zachary Liu (@zatchliu)** and **Sebastian Zimmeck (@SebastianZimmeck)** of the [privacy-tech-lab](https://privacytechlab.org/) and **Konrad Kollnig (@kasnder)** of the [Law and Tech Lab of Maastricht University](https://www.maastrichtuniversity.nl/about-um/faculties/law/research/law-and-tech-lab). Wesley Tan (@wesley-tan), Samir Cerrato (@samir-cerrato), Eliza Kuller (@ekuller) and Bella Tassone (@bella-tassone) contributed earlier.

[1. Research Publications](#1-research-publications)  
[2. Repo Overview](#2-repo-overview)  
[3. Scripts](#3-scripts)  
[4. Apps CSV](#4-apps-csv)  
[5. Thank You!](#5-thank-you)

For setup instructions, see also our [Artifact Appendix](https://github.com/privacy-tech-lab/gpc-android/blob/main/ARTIFACT-APPENDIX.md).

## 1. Research Publications

Sebastian Zimmeck, Nishant Aggarwal, Zachary Liu, Sage Altman, and Konrad Kollnig, [From Ad Identifiers to Global Privacy Control: The Status Quo and Future of Opting Out of Ad Tracking on Android](https://arxiv.org/abs/2407.14938).

You can find a complete list of our GPC research publications in the [GPC OptMeowt repo](https://github.com/privacy-tech-lab/gpc-optmeowt?tab=readme-ov-file#1-research-publications).

## 2. Repo Overview

This repo contains the following resources:

- `scripts`: Code for dynamically intercepting and analyzing network traffic
- `app_csv`: App lists sorted by Google Play Store categories

## 3. Scripts

The scripts can be used in conjunction with [mitmproxy](https://mitmproxy.org/) SOCKS5 mode to intercept network traffic and perform dynamic privacy analysis on Android apps. The following is a guide on how to run the analysis. To begin you should clone the repo.

### 3.1 Dependencies (Prerequisites)

1. Frida Server on phone
2. App for SOCKS Proxy on phone
3. MITM Proxy on computer
4. Mullvad VPN Account and set up on computer (optional if for different analysis regions)
5. MITM Proxy installed and set up on computer
6. ADB Installed and set up on computer
7. Rooted phone set up with the appropriate Magisk Modules
8. USB Debugging is enabled on the phone

### 3.2 Apps to Test

Once the repo is cloned, you will see there is a file called `scripts/app-list.txt`. In that file you should enter the list of **package names** that you want to test. Each package name should be on a new line. Make sure to add an empty line after your last package name.

The next step is to upload the actual apk files. You will see a folder called `apps`. This is where all the apks should be uploaded. It is recommended that the apks are deleted (or not staged) prior to any commit.

### 3.3 Setting up the Capture Infrastructure

Now we can move on to setting up the capture infrastructure. To begin, you will need a usb type-c to type-c cable. Use it to connect the phone to the computer (via the Android Debug Bridge (ADB)). Make sure the phone is connected by running the command `adb devices`. If you see a device in the list, you should be ready. If not, try detaching and reconnecting the usb connection.

### 3.4 Running the Analysis

Before you begin, make sure that your setup has followed all instructions so far and all the pre-requisites have been satisfied. If so, we are now ready to start the captures. The following is a list of steps in order that explicitly tell you how to run it.

1. Reboot the phone:

   ```console
   adb reboot
   ```

2. Turn on Data Saver and Turn off Private DNS on the phone; both settings are in `Settings -> Networks`
3. Turn on Frida

   ```console
   adb shell su -c /data/local/tmp/frida-server &
   ```

4. Now connect the phone to the computer using SOCKS Proxy. To do so first find the IP address of the computer (for MacBooks, it is in `Settings -> Wifi -> Details`). Now set it to be the IP address of the SOCKS Proxy on the phone. Set the port to 8889. Turn on the SOCKS Proxy Connection.
5. If you want to analyze apps' traffic from a different region than the one you are located in, turn on Mullvad VPN on the computer and connect to the region of your choice.
6. Navigate to the `scripts` directory in the `gpc-android` repo and run the command

   ```console
   bash multi-app-automation-script.sh
   ```

### 3.5 Output Files

The output files (.mitm and .har files) are stored in the `mitm-captures` folder. These files will not be uploaded to the remote repo. If you do want to upload them, please modify the .gitignore files accordingly.

### 3.6 Troubleshooting

#### 3.6.1 Frida

Frida is the most likely component to break the testing framework. The reason is that new OTA Android updates can break its functionality. To fix the issue, you can try a couple of things:

- Install the latest version of Frida server on android (arm64)
- Make sure the Frida client and Frida server are the same version
- Check the Frida GitHub repo for relevant information on the issue you may be facing

An error that you may encounter when running the Frida server is the following:

- {"type":"error","description":"Error: Unable to perform state transition; please file a bug","stack":"Error: Unable to perform state transition; please file a bug\n at bt (frida/node*modules/frida-java-bridge/lib/android.js:578:1)\n at frida/node_modules/frida-java-bridge/lib/class-model.js:112:1\n at Function.build (frida/node_modules/frida-java-bridge/lib/class-model.js:7:1)\n at k.\_make (frida/node_modules/frida-java-bridge/lib/class-factory.js:168:1)\n at k.use (frida/node_modules/frida-java-bridge/lib/class-factory.js:62:1)\n at frida/node_modules/frida-java-bridge/index.js:224:1\n at c.perform (frida/node_modules/frida-java-bridge/lib/vm.js:12:1)\n at \_performPendingVmOpsWhenReady (frida/node_modules/frida-java-bridge/index.js:223:1)\n at *.perform (frida/node_modules/frida-java-bridge/index.js:204:1)\n at /internal-agent.js:490:6","fileName":"frida/node_modules/frida-java-bridge/lib/android.js","lineNumber":578,"columnNumber":1}

To resolve this issue, you can delete the Android runtime library. Steps to uninstall it are

1. Run

   ```console
   adb shell
   ```

2. Run

   ```console
   pm uninstall com.google.android.art
   ```

3. Exit the shell with CTRL + D and then reboot your phone

   ```console
   adb reboot
   ```

#### 3.6.2 Network Connection

The path the network traffic takes in this setup is somewhat complicated. As such there could be several different places where the issue could be arising from:

- **SOCKS Proxy:** The SOCKS Proxy connects the phone to the computer. To make sure the connection is setup properly, first check the IP address of the computer you are connecting the device to. Now set that to the IP address to be reached in the SOCKS Proxy. But this alone is not enough. You also need to make sure that the port that you are sending the data to is listening for incoming data. This would, for us, be MITM Proxy. The port we are using is 8889. Additionally, if SocksDroid is directing traffic to what seems like the proper port, but it is not being picked up by MITM, it is possible that the port on the Android device is not properly connected to the respective port on the computer. Running `adb reverse tcp:8889 tcp:8889` and ensuring SocksDroid is set with Server IP: 127.0.0.1 and Server Port: 8889 may resolve this issue.
- **MITM Proxy:** The MITM Proxy is the next stage in the network transfer process. To make sure it is set up correctly make sure that MITM is up to date and running on the same port as defined in the SOCKS Proxy. For us, this should be 8889.
- **Mullvad VPN:** The last step in our network transfer process is the Mullvad VPN, assuming you are using it. We have almost never encountered issues with it, but in case you have a connection issue, it may be better to just test the setup without the VPN running to eliminate a potential reason for failure. Additionally, it may take a variable amount of time for the phone to connect to the MITM Proxy (this will be shown by "client connect" and "server connect" messages in the terminal). In this case, wait until the connection registers before attempting to analyze traffic.

### 3.7 Procedure for Manual Traffic Analysis

The process for capturing traffic manually is similar to the setup above but has some key differences. First follow the instructions under "Setting up the Capture Infrastructure," as well as those under "Running the Analysis" above through step 5 (turning on Mullvad VPN). Additionally, you will need the app whose traffic you wish to analyze installed on your phone. Proceed with the following steps:

1. Edit the paths given in `save_flows.py` (in the `scripts` directory) to ensure the script has a valid path to save to. Generally, this path should be `./mitm-captures/$APP_PACKAGE_NAME/not_opted_out.json` (or `.../opted_out.json`). The JSON files do not need to exist beforehand (and in fact should not exist), but the directories parenting them must be present for the script to function.
2. Then run the following three commands in your terminal in sequence.

   Clear any data on the android device associated with the given app

   ```console
   adb shell su -c pm clear $APP_PACKAGE_NAME
   ```

   Begin capturing network traffic from the device

   ```console
   mitmdump --mode socks5 -s ./scripts/save_flows.py
   ```

   Open the app with the necessary Frida script running

   ```console
   frida -U -l ./scripts/frida-script.js -f $APP_PACKAGE_NAME
   ```

3. In order to stop saving traffic to the path listed in `save_flows.py`, you can press CTRL+C at any time to quit mitmproxy and CTRL+C along with `exit` to end the Frida script.

This capture method is used to directly examine the traffic an app is sending before and after an in-app privacy toggle is switched on. It was run on a Google Pixel 6a. These instructions should also generally work with other Android phones, but you would need to download versions of the respective software compatible with your device and OS. Most recent versions tested are as follows:

- Pixel 6a
- Android 16 (Build Number BP2A.250705.008)
- MITMProxy v12.2.1
- Frida v17.5.1
- SocksDroid v1.0.4

## 4. Apps CSV

The `apps_csv directory` contains a collection of CSV files, each representing a category of apps on the Google Play Store. Each file contains a list of the top 40 free apps for a category.

### 4.1 Directory Contents

The directory contains the following files:

- Multiple CSV files with the naming convention `apps_<CATEGORY>.csv` where CATEGORY is the app category name from the Google Play Store, for example `apps_ART-AND-DESIGN.csv`
- A JavaScript file, `trial-play-scraper.js`, which can be used to scrape app data from the Google Play Store
- A bash shell script `play-store-downloader.sh`, which reads a CSV file and downloads the corresponding apps

Each CSV file contains the following columns:

- `APP_ID`: the unique ID of the app on the Google Play Store
- `TITLE`: the title of the app
- `DEVELOPER`: the developer of the app
- `SCORE`: the score of the app on the Google Play Store

### 4.2 How to Use

1. Clone this repo to your local machine with

   ```console
   git clone https://github.com/privacy-tech-lab/gpc-android.git
   ```

   Then, navigate to the `app_csv` directory.

2. To scrape app metadata from the Google Play Store for a particular category, first make sure you have [Node.js](https://nodejs.org/en) installed.

3. Then, run the `trial-play-scraper.js` script with

   ```console
   node trial-play-scraper.js
   ```

4. To download APKs from the Google Play Store with the `play-store-downloader.sh` run

   ```console
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

## 5. Thank You!

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
