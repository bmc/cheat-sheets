---
title: Ubuntu Cheat Sheet
layout: cheat-sheet
---

# Devices

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

# Network

*Nothing here yet.*

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

----

# Gnome

## Gnome terminal size

Changing size of Gnome terminal. From
<http://ubuntuforums.org/showthread.php?t=15471>

The `gnome-terminal` uses a termcap file for its basic settings. To change
these, edit `/usr/share/vte/termcap/xterm` and change the `li#24` entry to
some other size. Save the file, and the next spawned Gnome terminal will
take that size.

Doesn't always work. If not, use `--geometry=80x44` (or whatever) on the
command line.

## Keybindings for GTK applications

    $ gconftool-2 --set /desktop/gnome/interface/gtk_key_theme Emacs --type string

## Disable "empty trash" prompt

See [gnome](gnome.html) cheat sheet.

----

# Miscellaneous User Interface

## Emacs with decent fonts

<https://launchpad.net/~ubuntu-elisp/+archive/ppa>
<http://emacs.orebokech.com/>
