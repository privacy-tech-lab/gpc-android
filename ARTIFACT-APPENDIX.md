
Paper title: *Exercising the CCPA Opt-out Right on Android: Legally Mandated but Practically Challenging*

Requested Badge(s):
  - [x] **Available**
  - [x] **Functional**
  - [ ] **Reproduced**

## Description
The following are instructions and scripts for setting up an Android phone in combination with a computer to perform a manual dynamic analysis of apps' compliance with consumer opt-out rights. By examining the network traffic of running apps, we can observe how their behavior changes with privacy-enhancing features (such as with an injected GPC signal or use of in-app opt-out functionality). You can find all the details in our paper *Exercising the CCPA Opt-out Right on Android: Legally Mandated but Practically Challenging*.

### Security/Privacy Issues and Ethical Concerns

There are no such issues or concerns.

## Basic Requirements
### Hardware Requirements
The following steps are for a Pixel 6a and MacBook with macOS Sequoia 15.6.1 and standard Terminal app. Other configurations may work as well. However, we have only tested the instructions and scripts for our setup, so one would need to locate and download the appropriate versions of all software for their devices and adjust the instructions accordingly.

### Software Requirements
The artifact requires a Google Pixel phone with Android 16, 	SocksDroid, Magisk, and a Frida server installed, as well as a consumer-grade computer with MITMProxy, Frida, Mullvad VPN, ADB, and Python installed. Use the most recent available versions of all software. USB debugging must be enabled for the phone.

## Environment
### Accessibility 
The artifact is available in our GitHub repository, at https://github.com/privacy-tech-lab/gpc-android/tree/main

### Set up the environment
1. If you do not have it yet, install Python 3 on the computer you are using for the analysis, as well as Homebrew (you can run `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"` in the terminal on your computer).
2. Additionally, if you have not done so already, install the Android Platform Tools on the computer with `brew install android-platform-tools`. This will allow you to connect to the phone via ADB
3. On the computer, install Frida, by running the following in the terminal:
   `pip install frida`
   `pip install frida-tools`
4. Also on the computer, download the most recent version of frida-server from the Frida GitHub repository at https://github.com/frida/frida (ensure that you install the one compatible with your phone's system architecture, we used [frida-server-17.5.1-android-arm64.xz](https://github.com/frida/frida/releases/download/17.5.1/frida-server-17.5.1-android-arm64.xz))
5. On the phone, install Magisk from https://github.com/topjohnwu/Magisk, and use it to root the phone
	1. Once you have done so, install the Bypass Certificate Transparency Error and Custom Certificate Authorities modules in Magisk. These can be found at https://github.com/JelmerDeHen/MagiskBypassCertificateTransparencyError and https://github.com/0xdad0/custom-certificate-authorities, respectively
6. On the phone, install the most recent release of SocksDroid from their GitHub repository at https://github.com/bndeff/socksdroid
7. On the computer, use `brew install mitmproxy` to install the latest version of MITMProxy
8. Lastly, on the phone, follow the instructions in the Custom Certificate Authorities README document to install the appropriate MITMProxy certificate

### Installation
1. Navigate to the folder on your computer where the frida-server file you installed is located, then rename the file to "frida-server". Open a terminal window in this folder.
2. Connect the phone to the computer using a USB cord, and verify that the connection is successful by running `adb devices` in your terminal. If the phone is connected, you should see it pop up.
3. Run the following commands in your terminal in sequence:
	1. `adb push ./frida-server /data/local/tmp/frida-server` 
		1. This moves the frida-server file to the phone's storage
	2. `adb shell`
		1. This allows you to access your phone's terminal from the terminal on your computer
	3. `su`
		1. This enables superuser access and should change the character preceding the command line in your terminal. If it fails, you likely have not rooted the phone successfully
	4. `chmod 755 /data/local/tmp/frida-server`
		1. This ensures the frida-server file will be runnable by the phone
   This process will install the frida-server on your Android device. You can test that this has been done properly by running `/data/local/tmp/frida-server &`to start the frida-server. In a new terminal tab, then run `frida-ps -U`. This should display a list of running processes. If the frida-server has been started successfully, it should appear in this list.
4. Download and unzip the contents of the GitHub repository

### Testing the Environment 
1. Install `de.danoeh.antennapod.apk`, as provided in the repository at https://github.com/privacy-tech-lab/gpc-android/tree/main, to the Android device.
2. Turn on Data Saver and Turn off Private DNS on the Android device; both the settings can be found in `Settings -> Networks`
3. Open a new terminal session.
4. Navigate to the *gpc-android-main* directory, created by unzipping the contents of the GitHub directory.
5. Prepare the capture script
	1. Open `./scripts/save_flows.py` in your preferred code editor and set pkg_name, on line 4, to `de.danoeh.antennapod`
	2. Create a folder called `de.danoeh.antennapod` in the `mitm-captures` folder of the *gpc-android-main* directory
6. Open two more terminal tabs, located in the same directory.
7. In the first tab, use the commands provided above to ensure that the frida-server on the Android device is running correctly. 
8. Set up the SOCKS5 proxy
	1. In the SocksDroid app, set Server IP to 127.0.0.1 and Server Port to 8889
	2. Turn the proxy on
9. In the second tab, run `adb shell su -c pm clear de.danoeh.antennapod`
10. In the third tab, run `mitmdump --mode socks5  --listen-port 8889 -s ./scripts/save_flows.py`
	1. Wait until you see that the phone is correctly sending traffic, this is indicated by lines such as "client connect" and "server connect" appearing
	2. This may take a variable amount of time. If the proxy does not connect, ensure that the ports are properly connected by running `adb reverse tcp:8889 tcp:8889` in another terminal tab.
11. Returning, to the second, run `frida -U -l ./scripts/frida-script.js -f de.danoeh.antennapod`. You should see the app open on the Android device, and network traffic should begin to appear in the third terminal tab.
12. Once you are satisfied, use `COMMAND + C` to end the MITMProxy and Frida processes. You should now see a JSON file with your saved network traffic located in `./mitm-captures/de.danoeh.antennapod`.

## Notes on Reusability
The capture infrastructure presented by this artifact could easily be applied to save and analyze network traffic to and from most Android apps for any purpose. 