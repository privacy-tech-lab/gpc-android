# Artifact Appendix

Paper title: _Exercising the CCPA Opt-out Right on Android: Legally Mandated but Practically Challenging_

Requested Badge(s):

- [x] **Available**
- [x] **Functional**
- [ ] **Reproduced**

## Description

The following are instructions for setting up an Android phone in combination with a computer to perform a manual dynamic analysis of apps' compliance with consumer opt-out rights. By examining the network traffic of running apps, we can observe how their behavior changes with privacy-enhancing features, in particular, with an injected GPC signal or use of in-app opt-out functionality. You can find additional details in our paper [Exercising the CCPA Opt-out Right on Android: Legally Mandated but Practically Challenging](https://arxiv.org/abs/2407.14938).

### Security/Privacy Issues and Ethical Concerns

There are no such issues or concerns.

## Basic Requirements

### Hardware Requirements

The following instructions are for a Google Pixel 6a and MacBook with macOS Sequoia 15.6.1 and standard Terminal app. Other configurations may work as well. However, we have only tested the instructions and scripts for our configuration. If you are using a different configuration, you would need to locate and download the appropriate versions of all software for your devices and adjust the instructions accordingly.

### Software Requirements

The software requirements for the phone are:

- Android 16
- SocksDroid
- Magisk
- Frida

The software requirements for the computer are:

- MITMProxy
- Frida
- Mullvad VPN (only required if you are interested in testing for a different region than the one you are located in)
- Android Platform Tools/Android Debug Bridge (ADB)
- Python 3

We tested our setup with the most recent available versions of all software. USB debugging must be enabled for the phone.

## Environment

### Accessibility

The Scripts for performing the dynamic analysis are available in our [GPC Android GitHub repository](https://github.com/privacy-tech-lab/gpc-android/tree/main).

### Set up the environment

1. If you do not have it yet, install [Python 3](https://www.python.org/) and [Homebrew](https://brew.sh/) on the computer you are using for the analysis. To install Homebrew you can run in the terminal of your computer

   ```console
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. Additionally, if you have not done so yet, install the Android Platform Tools on your computer with

   ```console
   brew install android-platform-tools
   ```

   This will allow you to connect to your phone via ADB later.

3. On your computer, install Frida by running the following in the terminal:

   ```console
   pip install frida
   pip install frida-tools
   ```

   Frida will set up a server on your phone to bypass certificate pinning in combination with our certificate unpinning script.

4. Also on your computer, download the most recent version of `frida-server` from the [Frida GitHub repository](https://github.com/frida/frida). Ensure that you are installing the version compatible with your phone's system architecture. We used [frida-server-17.5.1-android-arm64.xz](https://github.com/frida/frida/releases/download/17.5.1/frida-server-17.5.1-android-arm64.xz).
5. On your phone, install [Magisk](https://github.com/topjohnwu/Magisk), and use it to root your phone.
   - Once you have done so, install the [Bypass Certificate Transparency Error](https://github.com/JelmerDeHen/MagiskBypassCertificateTransparencyError) and [Custom Certificate Authorities](https://github.com/0xdad0/custom-certificate-authorities) modules in Magisk.
6. On your phone, install the most recent release of [SocksDroid from its GitHub repository](https://github.com/bndeff/socksdroid).
7. On your computer, to install the latest version of MITMProxy run

   ```console
   brew install mitmproxy
   ```

8. Lastly, on your phone, follow the instructions in the Custom Certificate Authorities README document to install the appropriate MITMProxy certificate.

### Installation

1. Navigate to the folder on your computer where the frida-server file you installed is located. Rename the file to "frida-server". Open a terminal window in this folder.
2. Connect your phone to your computer using a USB cable. Verify that the connection is successful by running in your terminal

   ```console
   adb devices
   ```

   If your phone is connected, you should see it pop up.

3. Run the following commands in your terminal in sequence.

   To move the frida-server file to your phone's storage run

   ```console
   `adb push ./frida-server /data/local/tmp/frida-server`
   ```

   To access your phone's terminal from the terminal on your computer run

   ```console
   adb shell
   ```

   The following command will enable superuser access. You should see that you are a superuser as identified in the command line in your terminal. If it fails, you likely have not rooted your phone successfully.

   ```console
   su
   ```

   To ensure the frida-server file will be runnable by your phone run

   ```console
   chmod 755 /data/local/tmp/frida-server
   ```

   This process will install the frida-server on your Android device. You can test that you did so successfully by running the following command to start the frida-server

   ```console
   /data/local/tmp/frida-server &
   ```

   In a new terminal tab, then run

   ```console
   frida-ps -U
   ```

   This command should display a list of running processes. If the frida-server has been started successfully, it should appear in this list.

4. Download and unzip the contents of the GitHub repository.

### Testing the Environment

1. Install `de.danoeh.antennapod.apk`, as [provided in our GPC Android repository](https://github.com/privacy-tech-lab/gpc-android/tree/main), on your Android device.
2. Turn on Data Saver and Turn off Private DNS on your Android device. Both settings can be found in `Settings -> Networks`.
3. Open a new terminal session.
4. Navigate to the `gpc-android-main` directory, created by unzipping the contents of the GitHub directory.
5. Prepare the capture script as follows
   i. Open `./scripts/save_flows.py` in your preferred code editor and set pkg*name, on line 4, to `de.danoeh.antennapod`.
   ii. Create a folder called `de.danoeh.antennapod` in the `mitm-captures` folder of the `\_gpc-android-main* directory`.
6. Open two more terminal tabs, located in the same directory.
7. In the first tab, use the commands provided above to ensure that the frida-server on your Android device is running correctly.
8. Set up the SOCKS5 proxy as follows
   i. In the SocksDroid app, set Server IP to 127.0.0.1 and Server Port to 8889.
   ii. Turn the proxy on.
9. In the second tab run

   ```console
   adb shell su -c pm clear de.danoeh.antennapod
   ```

10. In the third tab run

    ```console
    mitmdump --mode socks5  --listen-port 8889 -s ./scripts/save_flows.py
    ```

    Wait until you see that your phone is correctly sending traffic, this is indicated by lines such as "client connect" and "server connect" appearing. This may take a variable amount of time.

    If the proxy does not connect, ensure that the ports are properly connected by running in another terminal tab

    ```console
     adb reverse tcp:8889 tcp:8889
    ```

11. Returning, to the second tab run

    ```console
    frida -U -l ./scripts/frida-script.js -f de.danoeh.antennapod
    ```

    You should see the app open on your Android device, and network traffic should begin to appear in the third terminal tab.

12. You can now interact with the app and capture its network traffic. Once you are satisfied, use `COMMAND + C` to end the MITMProxy and Frida processes. You should now see a JSON file with your saved network traffic located in `./mitm-captures/de.danoeh.antennapod`.

## Notes on Reusability

The network capture infrastructure described here can be applied to save and analyze network traffic to and from most Android apps for a variety of purposes.
