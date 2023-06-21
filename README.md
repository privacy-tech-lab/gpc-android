# gpc-android

This repo contains code and documentation for implementing GPC on Android. Google is exploring an alternative to Apple Inc.’s new anti-tracking feature, the latest sign that the internet industry is slowly embracing user privacy, according to people with knowledge of the matter. We hope to examine:
- How are the GPC and Google’s AdID opt-out supposed to affect apps’ data practices?
- How do the GPC signal and Google’s AdID opt-out affect apps’ data flow on the latest Android?
- What happens to the AdID? 
- What countermeasures do apps take? Using other unique AdIDs (e.g. Facebook, Amazon)?
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
