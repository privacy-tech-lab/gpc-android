# gpc-android

This repo contains code and documentation for implementing GPC on Android, which is [especially relevant](https://www.bloomberg.com/news/articles/2021-02-04/google-explores-alternative-to-apple-s-new-anti-tracking-feature?sref=ExbtjcSG),

Contact us with any questions or comments at sebastian@privacytechlab.org.

Google is exploring an alternative to Apple Inc.’s new anti-tracking feature, the latest sign that the internet industry is slowly embracing user privacy, according to people with knowledge of the matter. We hope to examine:
- How are the GPC and Google’s AdID opt-out supposed to affect apps’ data practices?
- How do the GPC signal and Google’s AdID opt-out affect apps’ data flow on the latest Android?
- What happens to the AdID? 
- What countermeasures do apps take? Using other unique AdIDs (e.g. Facebook, Amazon)?

## Research Focus
Currently, our focus is on analyzing network traffic, and we are focused on analyzing how enabling GPC and disabling the AdID affects the network traffic. We are currently working on an automated way to do so, but our current method is as follows:

### mitmproxy with WireGuard method to intercept network traffic
1. Download the WireGuard app on the Phone through play store.
2. Next, run the command `mitmweb --mode` wireguard in the terminal (on your computer). Note this step assumes that mitmproxy has been installed and configured correctly on the users device. Now a new tab should open in your browser; this will contain a QR code. Scan the QR code using the WireGuard app you installed on your phone and save it.
3. Now you can turn on this vpn tunnel in the WireGuard app, and all the traffic should be intercepted
4. To use the GPC header, The terminal command now is `mitmweb --mode wireguard -s mitm-script.py` where mitm-script.py is the name of the script file.
5. Use apk-mitm (https://github.com/shroudedcode/apk-mitm) on the apk, else TSL handshake will not work.

You should then see the indicator that GPC enabled; “Sec-GPC: 1”
