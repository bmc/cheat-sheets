---
title: Ubuntu Cheat Sheet
layout: cheat-sheet
---

# Devices

## Apple Magic Mouse

### Setting the scroll speed

Create `/etc/modprobe.d/hid-magicmouse`, with the following contents:

    options hid_magicmouse scroll-speed=55 scroll-acceleration=1

The scroll speed value is a number from 0 (slow) to 63 (fast).

To force a change, reload the module:

    $ sudo rmmod hid_magicmouse
    $ sudo modprobe hid_magicmouse

To check that the value was properly picked up on reload:

    $ cat /sys/module/hid_magicmouse/parameters/scroll_speed              

## APC Back UPS

Adapted from <http://www.panticz.de/APC-Back-UPS-ES-700G-under-Ubuntu>.
Works with my APC Back-UPS ES 750.

Install the `apcupsd` package

    $ sudo apt-get install -y apcupsd

Configure it. First, edit `/etc/apcupsd/apcupsd.conf` and set:

    UPSNAME somename
    UPSCABLE usb
    UPSTYPE usb
    # blank device
    DEVICE

Then, edit `/etc/default/apcupsd`:

    ISCONFIGURED=yes

Start the daemon:

    $ sudo /etc/init.d/apcupsd start

Get status, as a test:

    $ apcaccess status

Monitor:

    $ tail -f /var/log/apcupsd.events

*Optional*: configure `/etc/apcupsd/apccontrol`

More information: <http://www.apcupsd.com/manual/manual.html>

## Getting sound to work.

<https://help.ubuntu.com/community/SoundTroubleshooting>

Specific to the Intel ICH8 (in many laptops):

<http://linuxtechie.wordpress.com/2007/10/19/getting-intel-ich8-family-rev-3-sound-card-to-work-in-gutsy/>

Also, make sure the sound isn't (accidentally) muted.

## Broadcom wireless NIC

Getting Broadcom wireless NIC to work. (This is the NIC in Dell laptops.)

<https://help.ubuntu.com/community/WifiDocs/Driver/bcm43xx/Feisty_No-Fluff>

Be sure the Wifi switch on the side of the laptop is on!

----

# Telephony

## Sending a fax via a fax modem

* Attach the modem. (External USB modems work fine.)
* For a USB modem, look at `/var/log/syslog` to determine the assigned TTY.
  (e.g., `ttyACM0`)
* Install the *efax-gtk* package.
* Fire up *efax-gtk* (typically under "Office" in the Gnome *Applications*
  menu).
* Configure *efax-gtk* (File > Settings). In particular, be sure to set the
  appropriate TTY device.
* Send the fax.

----

# Music and Audio

## Streaming Radio

Use Radio Tray. See <http://itsfoss.com/radio-tray-ubuntu/>. To install:

    sudo add-apt-repository ppa:eugenesan/ppa
    sudo apt-get update
    sudo apt-get install radiotray

----

# Video

## Getting Netflix to work on Ubuntu

See <http://www.webupd8.org/2013/08/pipelight-use-silverlight-in-your-linux.html>

----

# Unity

## Themes

There are numerous Unity themes out there. This site lists a few of the best:
<http://itsfoss.com/best-themes-ubuntu-1310/>

Once a theme is installed, it can be previewed and activated via the
Unity Tweak Tool.

## Emacs key bindings

    $ gsettings set org.gnome.desktop.interface gtk-key-theme "Emacs"

## Allow X server to listen for TCP connections

Ubuntu uses [LightDM][]. To tell LightDM to allow incoming TCP connections
(controlled via _xhost_ settings, of course), modify
`/etc/lightdm/lightdm.conf` so that the `[SeatDefaults]` section contains
`xserver-allow-tcp=true`. For example:

    [SeatDefaults]
    autologin-guest=false
    autologin-user=oem
    autologin-user-timeout=0
    autologin-session=lightdm-autologin
    xserver-allow-tcp=true

Then, log out, and from a remote terminal window, type:

    $ sudo restart lightdm

[LightDM]: http://www.freedesktop.org/wiki/Software/LightDM/
 
----

# Network

## Setting up an FTP server

Use PureFTP, as discussed at <https://help.ubuntu.com/community/PureFTP>.

## Bridging

Easiest procedure is here: <https://help.ubuntu.com/10.04/serverguide/network-configuration.html>. Works on 12.10, as well.

----

# Java

## Adding the Oracle JDK via PPA

See <http://www.webupd8.org/2012/01/install-oracle-java-jdk-7-in-ubuntu-via.html>

----

# Miscellaneous System Administration

## Rough equivalent to "chkconfig"

Use `update-rc.d`.

## Mounting remote Windows or Samba shares

First, install `smbfs`:

    $ sudo apt-get install smbfs

Then, add something like this to `/etc/fstab`

    //tera1/share /mnt/tera1 cifs username=root,password=,noauto,uid=0,rw,suid 0 0

## Sharing a printer to Windows

See: <https://help.ubuntu.com/community/NetworkPrintingFromWinXP>

Works with Windows 7.

## Problems removing package

When removing a package, you get

    subprocess pre-removal script returned error

and the package refuses to go away. Solution:

* Go to `/var/lib/dpkg/info`
* Look for `package.prerm`
* Remove it
* Try again

----

# APT

## Using backports

See <https://help.ubuntu.com/community/UbuntuBackports>

----

# Gnome

See [Gnome Cheat Sheet](gnome.html) for more non-Ubuntu Gnome tips.

## Gnome terminal size

Changing size of Gnome terminal. From
<http://ubuntuforums.org/showthread.php?t=15471>

The `gnome-terminal` uses a termcap file for its basic settings. To change
these, edit `/usr/share/vte/termcap/xterm` and change the `li#24` entry to
some other size. Save the file, and the next spawned Gnome terminal will
take that size.

Doesn't always work. If not, use `--geometry=80x44` (or whatever) on the
command line.

----

# Miscellaneous User Interface

## Emacs with decent fonts

<https://launchpad.net/~ubuntu-elisp/+archive/ppa>
<http://emacs.orebokech.com/>

## Thunderbird

### Opening URLs with something other than Firefox

On Ubuntu 11.04 and 11.10 (in my environment, anyway), Thunderbird always opens links in Firefox, no matter what the Ubuntu default browser is.

Step 1:

Pull up the Advanced Configuration Editor
(`Edit > Preferences > Advanced > Config Editor`), and change the following
values:

    network.protocol-handler.app.ftp
    network.protocol-handler.app.http
    network.protocol-handler.app.https

Set all to `/usr/bin/google-chrome` (or desired browser.)

**In my case, this did _not_ work.**

Step 2:

An _strace_(1) of Thunderbird showed that it was invoking, in turn, the
following Gnome shortcuts. (The fact that I'm using xfce4 makes no difference
to Thunderbird.)

* `~/.local/share/applications/firefox.desktop` (not there, in my case)
* `/usr/share/xsession/applications/firefox.desktop` (also not there)
* `/usr/local/share/xsession/applications/firefox.desktop` (again, not there)
* `/usr/share/applications/firefox.desktop` (found)

So, a quick hack solution:

    $ ln -s /usr/share/applications/google-chrome.desktop ~/.local/share/applications/firefox.desktop

At that point, Thunderbird finally invoked the browser I wanted it to invoke.

----

# Virtualization

# VirtualBox on 12.10

Use this procedure, rather than the `apt` version of VirtualBox:

    $ echo "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
    $ wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -
    $ sudo apt-get update
    $ sudo apt-get install virtualbox-4.2

## Using logical volumes for virtualization with kvm

First, ensure that a logical volume exists.  See [The Linux Cheat
Sheet](linux.html#logical-and-physical-volume-groups) Then, ensure that the
virtual machine is *not* running.

### If moving from a file-based image (`.img` file)

    # dd if=/path/to/machine.img of=/dev/volgroupname/lvname

e.g.:

    # dd if=/var/lib/libvirt/images/foobar.img of=/dev/virtimages/foobar

This step, obviously, can take awhile.

Then, using `virt-manager`, edit the virtual machine's configuration, and
create or edit an IDE device to point to the logical volume name
(e.g., `/dev/virtimages/foobar`).

Note: This also works, but it's more error-prone:

    $ virsh edit foobar

     --- edit the XML, removing the existing disk image and replacing
     --- it with:

    <disk type='block' device='disk'>
      <source dev='/dev/virtimages/foobar'/>
      <target dev='hda' bus='ide'/>
    </disk>

Fire up the virtual machine.

Reference: (http://blog.codefront.net/2010/02/01/setting-up-virtualization-on-ubuntu-with-kvm/>

