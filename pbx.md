---
title: PBX Cheat Sheet
layout: cheat-sheet
---

*Notes on FreePBX, IncrediblePBX, and the like.*

# Installation

## Copy the ISO to the SDHC card

* Download IncrediblePBX for Pi. See <http://nerdvittles.com/?p=3026>
* Unpack the tarball.
* Put the SDHC card in the card reader (assumes Linux).
* Run the `make-sdhc` script that came out of the tarball.

## Boot the Pi.

Put the SDHC card in the Pi, attach the HDMI port to a monitor, and boot.

## Initial configuration

* Log in as `root`. Initial password is `raspberry`.
* Allow IncrediblePBX to update itself.
* At the bash prompt, run `raspi-config`.
* If the SD card has more than 4Gb, choose the menu item to expand the file
  system. (The ISO is only 4Gb, and Linux will only see that much, unless
  you expand the file system.)
* Possibly select the overclock option, as well.
* Enable the SSH daemon.
* Reboot.

# Configuration

## Configure the PBX

* Connect to the web server on the Pi.
* Select the administration logo. 
* Log in as `admin`, with password `admin`.

## Forwarding to an external number after so many rings

Easiest solution:

1. Applications > Follow Me
2. Select the extension.
3. Select *hunt* as the Ring Strategy.
4. Add the number, with a trailing #, to the Follow-Me List.
5. Optional: Adjust the ring time. 

**Note**: If the target of an inbound route is a ring group, rather than an
extension, you must include a "#" on the end of the extension in the ring
group to force Follow Me behavior.

### Ensuring that the original caller ID follows a forwarded call

Go into Advanced Settings and change **SIP trustrpid** and **SIP sendrpid** to
`yes`.

Also, make *sure* you don't have the Outbound CID set on the primary
extension.

# References

* <http://nerdvittles.com/?p=3026>
