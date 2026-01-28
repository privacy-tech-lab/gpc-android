# Artifact Appendix

Paper title: _Exercising the CCPA Opt-out Right on Android: Legally Mandated but Practically Challenging_

Requested Badge(s):

- [x] **Available**
- [x] **Functional**
- [ ] **Reproduced**

## Description

The following are instructions for setting up an Android phone in combination with a computer to perform a manual dynamic analysis of apps' compliance with consumer opt-out rights. By examining the network traffic of running apps, we can observe how their behavior changes with an injected GPC signal or use of in-app opt-out functionality. You can find additional details in our paper [Exercising the CCPA Opt-out Right on Android: Legally Mandated but Practically Challenging](https://arxiv.org/abs/2407.14938).

### Security/Privacy Issues and Ethical Concerns

There are no security issues or ethical concerns relevant to users of this artifact.

## Basic Requirements

### Hardware Requirements

The following instructions are for a Google Pixel 6a and MacBook with macOS Sequoia 15.6.1 and standard Terminal app. Other configurations may work as well. However, we have only tested the instructions and scripts for this configuration. If you are using a different configuration, you would need to locate and download the appropriate software versions for your devices and adjust the instructions accordingly.

### Software Requirements

The software requirements for the phone, with the versions we used are:

- Android 16
- SocksDroid (1.0.4)
- Magisk (29.0)
- Frida (17.5.1)

The software requirements for the computer are:

- MITMProxy (12.2.1)
- Frida (17.5.1)
- Mullvad VPN (only required if you are interested in testing for a different region than the one you are located in) (2025.8)
- Android Platform Tools/Android Debug Bridge (ADB) (36.0.0)
- Python 3.13.5

We tested our setup with a MacBook running macOS Sequoia 15.6.1. USB debugging must be enabled for the phone.

### Estimated Time and Storage Consumption
- The software required for use of this artifact takes up a negligible amount of space on both the phone and the computer, and the bulk of the storage used will depend on your choice of apps to analyze.
- Once the environment is set up, using the artifact to collect an app's network traffic should take, on average, five minutes (accounting for data collection, loading screens, configuring the scripts, etc.)

## Environment

### Accessibility

The scripts for performing the dynamic analysis are available in our [GPC Android GitHub repository](https://github.com/privacy-tech-lab/gpc-android/tree/main).

### Set up the environment

1. If you do not have it yet, install [Python 3](https://www.python.org/) and [Homebrew](https://brew.sh/) on the computer you are using for the analysis. To install Homebrew you can run in the Terminal of your computer:

   ```console
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. Additionally, if you do not have them yet, install the Android Platform Tools on your computer with:

   ```console
   brew install android-platform-tools
   ```

   Doing so will allow you to connect your computer to your phone via ADB later.

3. On your computer, install Frida by running the following in the Terminal:

   ```console
   pip install frida
   pip install frida-tools
   ```

   Frida will set up a server on your phone to bypass certificate pinning in combination with our certificate unpinning script.

4. Also on your computer, download the most recent version of `frida-server` from the [Frida GitHub repository](https://github.com/frida/frida). Ensure that you are installing the version compatible with your phone's system architecture. We used [frida-server-17.5.1-android-arm64.xz](https://github.com/frida/frida/releases/download/17.5.1/frida-server-17.5.1-android-arm64.xz).
5. On your phone, install [Magisk](https://github.com/topjohnwu/Magisk), and use it to root your phone.
   - Once you have done so, install the [Bypass Certificate Transparency Error](https://github.com/JelmerDeHen/MagiskBypassCertificateTransparencyError) and [Custom Certificate Authorities](https://github.com/0xdad0/custom-certificate-authorities) modules in Magisk.
6. On your phone, install the most recent release of [SocksDroid from its GitHub repository](https://github.com/bndeff/socksdroid). You will need to use the APK file provided in the [releases](https://github.com/bndeff/socksdroid/releases) section, as the Play Store link is broken at the time of writing.
7. On your computer, to install the latest version of MITMProxy run:

   ```console
   brew install mitmproxy
   ```

8. Lastly, on your phone, follow the instructions in the Custom Certificate Authorities README document, located in the [Custom Certificate Authorities GitHub repository](https://github.com/0xdad0/custom-certificate-authorities), to install the appropriate MITMProxy certificate.

### Installation

1. Navigate to the folder on your computer where the frida-server file you installed is located. Rename the file to "frida-server". Open a Terminal window in this folder.
2. Connect your phone to your computer using a USB cable. Verify that the connection is successful by running in your Terminal:

   ```console
   adb devices
   ```

   If your phone is connected, you should see it pop up.

3. Run the following commands in your Terminal in sequence.

   To move the frida-server file to your phone's storage run:

   ```console
   adb push ./frida-server /data/local/tmp/frida-server
   ```

   To access your phone's Terminal from the Terminal on your computer run:

   ```console
   adb shell
   ```

   The following command will enable superuser access. You should see that you are a superuser as identified in the command line in your Terminal. If it fails, you likely have not rooted your phone successfully.

   ```console
   su
   ```

   To ensure the frida-server file will be runnable by your phone run:

   ```console
   chmod 755 /data/local/tmp/frida-server
   ```

   This process will install the frida-server on your Android device. You can test that you did so successfully by running the following command to start the frida-server:

   ```console
   /data/local/tmp/frida-server &
   ```

   In a new Terminal tab run:

   ```console
   frida-ps -U
   ```

   This command should display a list of running processes. If the frida-server has been started successfully, it should appear in this list.

4. Download and unzip the contents of this GitHub repository to get the scripts to run the analysis. The scripts are necessary for testing the environment, which we will discuss next.

### Testing the Environment

The following steps provide a sanity check to determine whether you have set up the environment properly.

1. Install `de.danoeh.antennapod.apk`, as [provided in our GPC Android repository](https://github.com/privacy-tech-lab/gpc-android/tree/main), on your Android device.
2. Turn on Data Saver and Turn off Private DNS on your Android device. Both settings can be found in `Settings -> Networks`.
3. Open a new Terminal session on your computer.
4. Navigate to the `gpc-android-main` directory, created by unzipping the contents of the GitHub directory.
5. Prepare the capture script as follows:
   1. Open `./scripts/save_flows.py` in your preferred code editor and set pkg\*name, on line 4, to `de.danoeh.antennapod`.
   2. Create a folder called `de.danoeh.antennapod` in the `mitm-captures` folder of the `\_gpc-android-main* directory`.
6. Open two more Terminal tabs, located in the same directory.
7. In the first tab, use the commands provided above to ensure that the frida-server on your Android device is running correctly.
8. Set up the SOCKS5 proxy as follows:
   1. In the SocksDroid app, set Server IP to 127.0.0.1 and Server Port to 8889.
   2. Turn on the proxy.
9. In the second tab run:

   ```console
   adb shell su -c pm clear de.danoeh.antennapod
   ```

10. In the third tab run:

    ```console
    mitmdump --mode socks5  --listen-port 8889 -s ./scripts/save_flows.py
    ```

    Wait until you see that your phone is correctly sending traffic, which is indicated by lines such as "client connect" and "server connect" appearing. Their appearance may take a variable amount of time.

    If the proxy does not connect, ensure that the ports are properly connected by running in another Terminal tab:

    ```console
     adb reverse tcp:8889 tcp:8889
    ```

11. Returning, to the second tab run:

    ```console
    frida -U -l ./scripts/frida-script.js -f de.danoeh.antennapod
    ```

    You should see the app open on your Android device, and network traffic should begin to appear in the third Terminal tab.

12. You can now interact with the app and capture its network traffic. For example, you can navigate to an app's opt-out UI and opt out. Once you finished your analysis, use `COMMAND + C` to end the MITMProxy and Frida processes. You should now see a JSON file with your saved network traffic located in `./mitm-captures/de.danoeh.antennapod`.

## Artifact Evaluation

### Main Results and Claims
The paper uses analysis of app traffic gathered using capture infrastructure to provide cases where using in-app opt-out functionality did not lead to an app handling user data with the appropriate privacy standards. 

### Experiments

This section lists the experiments required to validate the artifact’s functionality and to perform the same analyses as done for the paper.

#### Experiment 1: Environment setup and instrumentation verification

- **Time:** Approximately 15-30 minutes
- **Storage:** Negligible

This experiment verifies that the analysis environment can be set up successfully and that the artifact’s instrumentation components function as intended.

**Steps:**
1. Follow the instructions in *Set up the environment* and *Installation* to configure the Android device and host computer.
2. Connect the Android device to the host computer and verify connectivity using: `adb devices`
3. Start frida-server on the Android device and verify it is running.
4. From the host computer, run: `frida-ps -U` and confirm that running processes on the device are listed.

**Expected result:**
The device is visible via ADB, frida-server runs without errors, and Frida can enumerate processes on the device. This experiment confirms that the artifact’s analysis environment is functional.

#### Experiment 2: Network traffic interception and capture

   - **Time:** Approximately 5-10 minutes
   - **Storage:** Negligible

This experiment verifies that the artifact can intercept, decrypt, and record Android app network traffic.

**Steps**:
   1. Configure SocksDroid and MITMProxy as described in _Testing the Environment_.
   2. Start MITMProxy in SOCKS5 mode:
   `mitmdump --mode socks5 --listen-port 8889 -s ./scripts/save_flows.py`
   4. Install the test application (de.danoeh.antennapod) on the Android device.
   5. Launch the app using the provided Frida script:
   `frida -U -l ./scripts/frida-script.js -f de.danoeh.antennapod`
   6. Interact with the app for a minute or so, then terminate the capture.

**Expected result:**
MITMProxy logs active connections, and a JSON file containing captured network traffic is created in ./mitm-captures/de.danoeh.antennapod. This experiment indicates that the artifact is properly set up and can capture traffic as needed.

#### Experiment 3: Comparison of network behavior before and after opt-out

   - **Time:** Approximately 5-10 minutes per app
   - **Storage:** Negligible

This experiment replicates the process used to collect data. You may replace `de.danoeh.antennapod` with the package name of the app you wish to analyze.

**Steps:**

   1. Clear the app’s state: `adb shell su -c pm clear de.danoeh.antennapod`
   2. Launch the app and capture baseline network traffic as in Experiment 2.
   3. Exercise the app’s opt-out mechanism (e.g., navigate to the opt-out UI and opt out, or inject the GPC signal as described in the paper).
   4. Capture network traffic again after opting out.
   5. Compare the two capture files.

**Expected result:**
Network traffic continues to be observed after opt-out actions are taken. While specific requests and destinations may differ, you should see two separate non-empty JSON files in ./mitm-captures corresponding to the app's opted-in and opted-out states.

## Limitations

Results may vary due to app updates, server-side behavior, geographic location, or timing of user interactions. Such variability is expected and does not affect the artifact’s ability to demonstrate its functionality.

## Notes on Reusability

The network capture infrastructure described here can be applied to save and analyze network traffic to and from most Android apps for a variety of purposes.
