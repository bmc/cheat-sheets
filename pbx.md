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

Two simple solutions:

### Follow Me

1. Applications > Follow Me
2. Select the extension.
3. Select *hunt* as the Ring Strategy.
4. Add the number, with a trailing #, to the Follow-Me List.
5. Optional: Adjust the ring time. 

**Note**: If the target of an inbound route is a ring group, rather than an
extension, you must include a "#" on the end of the extension in the ring
group to force Follow Me behavior.

### Chained ring groups

1. Put the external number in its own ring group (e.g., ring group #601).
2. Set the "Destination if no answer" to "Voicemail".
3. Put the main extension in different ring group (e.g., ring group #600),
   and point the inbound route at this ring group.
4. In this primary ring group (#600), set the ring time appropriately.
5. Set the "Destination if no answer" to go to the second ring group.

### Ensuring that the original caller ID follows a forwarded call

Go into Advanced Settings and change **SIP trustrpid** and **SIP sendrpid** to
`yes`.

Also, make *sure* you don't have the Outbound CID set on the primary
extension.

**NOTE**: This strategy may not work. The DID provider may not honor the PBX's
attempt to pass along the original caller ID. (Mine doesn't; I always see the
caller ID of the PBX's outbound trunk.)

In that case, one solution is to modify the second ring group (#601, in the
example above) so that "Confirm Calls" is checked. When the call is
forwarded, the PBX (which knows the original caller ID) will play a short
message ("press 1 to accept the call, 2 to reject it, 3 to listen to the
caller ID information"). This approach provides a way to allow the callee
to get the caller ID information, even though it's not passed along by the
telco. **Be sure to configure enough ring time on the second ring group to
permit the callee to listen to the message!

### 

# References

* <http://nerdvittles.com/?p=3026>
