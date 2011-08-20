---
title: Linksys WAP54G Cheat Sheet
layout: cheat-sheet
---

# After resetting

After resetting the hardware, the device will have the following settings:

* **SSID**: linksys
* **Wireless security**: None
* **IP address**: 192.168.1.245
* **Login credentials**: User name *empty*, password "admin".

# Resetting Device with Mac OS X

1. Reset the hardware. (Be sure to hold the reset button for 30 seconds, and
   then disconnect the power for another 30 seconds.)

2. Connect the WAP directly to the Mac's ethernet port and plug it back in.

3. Wire a static IP to the Mac's wired interface. e.g.:

    $ sudo ifconfig en0 192.168.1.100 netmask 0xffffff00

4. You should now be able to point your Mac's browser to http://192.168.1.245/
   to reconfigure the WAP.
