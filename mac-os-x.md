---
title: Mac OS X Cheat Sheet
layout: cheat-sheet
---

# User Account Stuff

## Changing login shell

(Works for Lion; not tested elsewhere): Just use the old BSD *chsh* command.

## Creating a login hook

One solution, adapted from <http://www.bombich.com/mactips/loginhooks.html>
and <http://docs.info.apple.com/article.html?artnum=301446>:

First, create directory `/Library/Local`. Then, create file
`/Library/Local/on-login.sh` containing, e.g.:

    #!/bin/sh

    case "$#" in
        0)
            echo "No user specified!" >&2
            exit 1
            ;;
    esac

    if [ -f /Users/$1/.on-login.sh ]
    then
        su $1 -c "/Users/$1/.on-login.sh"
    fi

Use individual `.on-login.sh` scripts in user directories.

# User Interface

## Focus follows mouse

Support is limited currently. But, courtesy of
<http://www.macosxhints.com/article.php?story=20031029203936659>

> A feature that I've long waited for -- window focus that follows the
> mouse between terminal windows -- has finally been added (in a hidden
> manner) to the 10.3 Terminal application. From the Terminal, type:
>
>     defaults write com.apple.Terminal FocusFollowsMouse -string YES
>
> Quit and restart the Terminal and enjoy! Now if I only had window
> autoraise, I'd be in heaven!

## Capturing the screen

* Entire screen: Command-Shift-3
* Just a portion: Command-Shift-4, then drag rectangle around area
* An application: Command-Shift-4, then Spacebar.

Results are written to a PNG file on the Desktop

## Disable the Dashboard

From [MacOSXHints.com](http://www.macosxhints.com):

To turn Dashboard off:

    $ defaults write com.apple.dashboard mcx-disabled -boolean YES 

To turn Dashboard on:

    $ defaults write com.apple.dashboard mcx-disabled -boolean NO 

You have to restart the Dock after making either change for it to take
effect:

    $ killall Dock 

## Lock screen without logging off or waiting for screensaver

<http://www.macworld.com/weblogs/macosxhints/2006/01/lockscreen/index.php>

> You can use this application (in your Applications/Utilities folder) to
> quickly activate your screen saver from the menubar and require a
> password to turn it off--even if the Security pane option isn't enabled.
> Open Keychain Access and then go to Keychain Access: Preferences. Click
> on the General tab and select the Show Status in Menu Bar option. A small
> lock icon will appear in your menu bar. Close the Preferences window and
> quit Keychain Access. Now click the lock icon in your menubar and choose
> Lock Screen to start your screen saver.

*Another solution:* Use Automator to assign a keyboard shortcut, as described
at <http://hints.macworld.com/article.php?story=20090831093941225>.

## Creating a dock folder (a "stack")

Just drag a folder to the dock. Note: Can't always drag from the sidebar,
though (e.g., Applications)

## Calibrating the monitor

Use *System Preferences > Displays > Calibrate*. Select Expert Mode.

## Hiding users on login screen

    sudo defaults write /Library/Preferences/com.apple.loginwindow \
    HiddenUsersList -array-add account1 account2 account3

Be sure to type `.../com.apple.loginwindow`, NOT
`.../com.apple.loginwindow.plist`. The file name ends in `.plist`, but the
`defaults` utility ignores the extension. (Using the extension results in
creation of file `/Library/Preferences/com.apple.loginwindow.plist.plist`,
which is no help at all.

## Creating a custom icon for a drive or folder

<http://macapper.com/2007/04/21/how-to-create-custom-icons-for-your-mac/>

NOTE: Icns2Rsrc seems to be gone. For Lion, though, just try this:

* Generate the icon with Icon Converter (from the Developer Tools package)
* Open the icon in Preview.app
* Select and copy the largest one
* Right click the desired application, and select Get Info
* Select the icon image in the upper right, and paste

## Prevent Mac from going to sleep

Use Caffeine, which sits in the menu bar: <http://lightheadsw.com/caffeine>

## Disable "Empty Trash" confirmation dialog

Go to *Finder > Preferences*, select the *Advanced* button, and uncheck
"Show warning before emptying the Trash." You may also wish to check the
"Empty Trash securely" while you're there.

## Change file associations

To change default application that opens a file (e.g., PDF):

* Right click on a file of that type.
* Select *Get Info*
* Change the `Open with` value.
* Select `Change All` to change for all files, not just that one.

----

# Open Source Software

## Mac Ports, Fink, etc.

Skip Mac Ports and Fink. Use [HomeBrew][], instead.

[HomeBrew]: https://github.com/mxcl/homebrew/wiki/installation

## Emacsen

### Aquamacs

Completely re-worked, Carbon-ized, Mac-specific version of GNU Emacs.

### Mac Ports

Emacs as installed via Darwin Ports ("port"). Seems to have problems
creating a mapping from Command (or Option) to the Meta key.

### Build from source

Regular GNU Emacs. See 
<http://members.shaw.ca/akochoi-emacs/stories/obtaining-and-building.html>

Solution:

Build first for NextStep:

    $ ./configure --with-ns --without-dbus
    $ make bootstrap
    $ make
    $ sudo make install

Next, build for X:

    $ make clean
    $ ./configure --with-x
    $ make bootstrap
    $ make
    $ sudo cp src/emacs /usr/local/bin/emacs-x

Then, use a modified version of the `ew` front-end shell script to fire up
the appropriate one, depending on whether login is local or remote.

Note: --with-ns creates a Mac `Emacs.app` folder, which ends up being
installed in `/Applications`, allowing use directly from the desktop.

----

# Audio

## To capture audio going to sound driver

Use WireTap Pro: <http://www.ambrosiasw.com/utilities/wiretap/>

## To capture audio from specific applications

Use Audio Hijack Pro: <http://rogueamoeba.com/audiohijackpro/>

## Control sound devices from menu bar

Use SoundSource: <http://www.rogueamoeba.com/freebies/>

## Convert an M4A

First, install FAAD and LAME:

    $ brew install faad2
    $ brew install lame

### ... to a WAV

    $ faad -o foo.wav foo.m4a

### ... to an MP3

    $ faad -o - foo.m4a | lame -h -b 192 - foo.mp3

Or, just install this script, as `m4a2mp3`:

    #!/bin/bash

    for i in "$@"
    do
        case $i in
            *.m4a)
                faad -o - "$i" | lame -h -b 192 - "${i%m4a}mp3"
                ;;
            *)
                echo "Skipping non-M4A file $i" >&2
                ;;
        esac
    done


----

# Email

## Thunderbird

If it hangs, try removing all the ".msf" folders in the local folders area,
letting T-bird rebuild them (especially if they were built by T-bird
running on another OS).

----

# Printing

## LPD printer stopped. No explanation

Solution: Check `/etc/hosts.lpd` on machine running LPD.

## Change printer info

Use `/Applications/Utilities/Printer Setup Utility`

----

# Disks, Files and File Systems

## Encrypted file systems

Can use Apple's FileVault. However, it encrypts the entire home directory.
To encrypt only one directory tree, use one of these options:

* Use a FUSE-based file system like EncFS, in conjunction with Mac-FUSE.
  This option works very well, and it results in a "file system" that can
  be copied to a Linux machine and mounted there.

* Use [TrueCrypt](http://www.trucrypt.org/).

* Use an encrypted Mac disk image. From
  <http://www.macworld.com/2007/10/features/lockup_others/index.php>:

> If your computer were stolen, the thief would be able to read any of your
> files. Requiring a password to log in wouldn’t keep your data safe,
> because someone could use an OS X Install disc to reset your password, or
> remove your hard drive and view the files on another computer. Encrypting
> your most sensitive files is the best solution.
>
> FileVault, introduced in OS X 10.3 (Panther), can do this, but encrypting
> all your data in this way can be dangerous; even a minor disk error could
> leave you unable to access any of your files. A better way is to create
> an encrypted disk image.
>
> In Disk Utility, create a new disk image (File: New: Blank Disk Image).
> Then, under Encryption, choose AES-128. From the Format pop-up menu,
> choose Sparse Disk Image and specify a name and location. When the
> Authenticate dialog box appears, choose a password; clicking on the key
> button next to the Password text box will summon Apple's Password
> Assistant, which can help you generate a secure one. (See full
> instructions (<http://find.macworld.com/2425>); if that seems like too much
> trouble, you can also create an encrypted disk image with a third-party
> product such as PGP Desktop Home.)
>
> Once you've created an encrypted disk image, you can use it to store any
> files containing private data. Just remember that as long as the disk
> image is mounted, your files are vulnerable. So be sure to log out (or at
> least unmount the disk image) whenever you step away from your computer.

## Those .DS_Store files

Preventing Mac OS X from creating .DS_Store files over network connections
<http://docs.info.apple.com/article.html?artnum=301711>

Note: This will affect the user's interactions with SMB/CIFS, AFP, NFS, and
WebDAV servers.

Open a terminal window and type:

    $ defaults write com.apple.desktopservices DSDontWriteNetworkStores true

Restart the computer.

Disabling the creation of `.DS_Store` files on remote file servers can
cause unexpected behavior in the Finder. See
<http://docs.info.apple.com/article.html?artnum=107822>

(Get Info comments aren't properly propagated.)

## Getting Finder to show hidden files

In a Terminal window, run this command:

    $ defaults write com.apple.finder AppleShowAllFiles TRUE
    $ killall Finder

## Burning a disc

### Burning a DVD from a disk image

Burning a DVD from a disk image (`.img`), such as one created by iDVD:

* Mount the image (double click on it).
* Start the Disk Utility (Applications/Disk Utility).
* Select the mounted image.
* The Burn button in the upper left of the Disk Utility will activate.
* Put a DVD (R, R/W) in the drive.
* Click the Burn button.

### Burning from an ISO

* Locate the .iso file in a Finder window
* Single click it
* *File > Open With > Disk Utility*
* Select the `.iso` file in the Disk Utility window
* *Images > Burn*

### Creating and burning a data disc

First way:

* Insert a burnable disc.
* Open it in the Finder.
* Drag files to the disc.
* Press the Burn button.

Second way:

* Create a burn folder.
* Drag files to the burn folder.
* Press the Burn button.
* Insert burnable disc.

## Create a DVD from a VIDEO_TS directory

Create a DVD from a `VIDEO_TS` directory (e.g., as created from iDVD's
"Save to VIDEO_TS" capability). From
<http://www.macosxhints.com/article.php?story=20070612161317338>:

Type in this command and change the paths to suit:

    $ hdiutil makehybrid -udf -udf-volume-name DVD_NAME \
      -o MY_DVD.iso /path/to/VIDEO_TS/parent/folder

Make sure that `/path/to/VIDEO_TS/parent/folder` is the path to the folder
containing the `VIDEO_TS` folder, not the `VIDEO_TS` folder itself. Once
the `.iso` file has been created, drag this to Disk Utility and hit the
Burn button.

## Mac Fuse and sshfs

Install via [HomeBrew][]:

    $ brew install sshfs
    
Be sure to follow the instructions in this output:

    $ brew info fuse4x-kext

## Automounting shares and NFS partitions:

* <http://sial.org/howto/osx/automount/>
* <http://www.bombich.com/mactips/automount.html>
* <http://mactechnotes.blogspot.com/2005/08/mac-os-x-as-nfs-client_31.html>

## Automounting Windows shares on login

<http://www.macosxhints.com/article.php?story=20070202190047133>

----

# Working with PDFs

## Merge two PDFs, or pages thereof

* Open both PDF documents in Preview.
* Ensure that the sidebar is visible in both. (*View > Sidebar > Show...*)
* Holding down the Command key, drag the pages from the source document to
  the target document.
* Rearrange within the sidebar of the target document.
* Save.

## Add an image to a PDF

* Convert the PDF document to an image with *File > Save As...* (or
  *File > Export* on Lion). Choose PNG as the format and change the
  resolution as desired.
* Open the image file and select the whole image with *Edit > Select All*
  (or select just a part of it with the mouse if you wish).
* Copy the selection via Command-C or *Edit > Copy*.
* Go back to the document (which is now a PNG image) and paste the
  selection with Command-V or *Edit > Paste*, and resize it as you wish.
* Save the file as a PDF (*File > Save As* or *File > Export*).

Note that a PDF made from an image is not searchable, so that is a drawback
to this procedure.

----

# Server Software

## Restarting a server (such as Postfix)

    $ sudo launchctl stop org.postfix.master
    $ sudo launchctl start org.postfix.master

## Enabling Postfix

Adapted from <http://www.freshblurbs.com/how-enable-local-smtp-postfix-os-x-leopard>

Edit `/System/Library/LaunchDaemons/org.postfix.master.plist`
add following lines before the closing `</dict>` tag:

    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>

Edit `/etc/postfix/main.cf` as necessary.

Then, start Postfix:

    $ sudo launchctl start org.postfix.master

## BIND on Mac OS X

<http://slaptijack.com/system-administration/bind-startup-in-mac-os-x-104-tiger/>
<http://slaptijack.com/system-administration/starting-bind-in-os-x-even-after-reboot/>

## Apache

Enable "Personal Web Sharing" in the *System Preferences > Sharing* panel.

- Personal directory is in `~/Sites`
- DocumentRoot is `/Library/WebServer/Documents`
- `httpd.conf` is in `/etc/httpd`

NOTE: When you enable personal web sharing, the system creates file
`/etc/httpd/users/$USER.conf` to contain the Apache `\<Directory\>`
entry for the user's Sites folder. Any changes (e.g., to enable
symlinking) must be made in there, not in `httpd.conf`.

## Running *cron*

<http://mactips.dwhoard.com/home/system/schedule-automatic-tasks>

Once the crontab file and the associated script file(s) have been created
and stored in the specified locations, you must initiate the cron process
by issuing the command:

    # crontab $HOME/.crontab

----

# Network

## Clear DNS cache

    $ sudo lookupd -flushcache

## VPN routing
 
Bring up a PPTP VPN and, by default, all traffic gets routed over that
connection. Solutions:

Via Internet Connect:

1. Pull up Internet Connect.
2. Select the PPTP VPN.
3. Go to the menu bar and select *Connect > Options*
4. Uncheck "Send all traffic over VPN connection"

Or, use a shell script to change the routes.

----

# Miscellaneous

## Startup Items

Primer on Startup Items:

<http://www.oreillynet.com/pub/a/mac/2003/10/21/startup.html>

## Safari

See the [Safari](safari.html) cheat sheet.

## GNU configure errors

When building GNU-based open source, `configure` fails with

    configure fails with 'Can't determine host type'

Solution: Copy `config.guess` and `config.sub` from `/usr/share/libtool` to
the current directory (i.e., the directory containing the GNU
autoconf-generated `configure` script).

# Dynamic linking

Use `DYLD_LIBRARY_PATH` to pick up `.dylib` files.

## Making the Mac OS X Color Picker into an Application

From <http://hints.macworld.com/article.php?story=20060408050920158>:

* Open `Applications > AppleScript Editor`
* Enter the text `choose color`
* Save as an Application (`File > Save As`, and choose `Application` format)

Consider adding the free [HexColorPicker](http://wafflesoftware.net/hexpicker/)
