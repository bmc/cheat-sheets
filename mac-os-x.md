title: Mac OS X Cheat Sheet

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

## Thunderbird

If it hangs, try removing all the ".msf" folders in the local folders area,
letting T-bird rebuild them (especially if they were built by T-bird
running on another OS).

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

    if \[ -f /Users/$1/.on-login.sh \]
    then
        su $1 -c "/Users/$1/.on-login.sh"
    fi

Use individual `.on-login.sh` scripts in user directories.

## Automounting shares and NFS partitions:

* <http://sial.org/howto/osx/automount/>
* <http://www.bombich.com/mactips/automount.html>
* <http://mactechnotes.blogspot.com/2005/08/mac-os-x-as-nfs-client_31.html>

## Automounting Windows shares on login

<http://www.macosxhints.com/article.php?story=20070202190047133>

## Restarting a server (such as Postfix)

    $ sudo launchctl stop org.postfix.master
    $ sudo launchctl start org.postfix.master

## VPN routing
 
Bring up a PPTP VPN and, by default, all traffic gets routed over that
connection. Solutions:

Via Internet Connect:

1. Pull up Internet Connect.
2. Select the PPTP VPN.
3. Go to the menu bar and select *Connect > Options*
4. Uncheck "Send all traffic over VPN connection"

Or, use a shell script to change the routes.

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

*Another solution:* The LockTight preference pane, which allows setting a
hot key combination for the "lock screen" capability.
<http://mac.pieters.cx/>

Also, in Snow Leopard, Ctrl-Shift-Eject activates the screen saver.

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

* Insert a burnable disc.
* Open it in the Finder.
* Drag files to the disc.
* Press the Burn button.

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

## Creating a dock folder (a "stack")

Just drag a folder to the dock. Note: Can't always drag from the sidebar,
though (e.g., Applications)

## Calibrating the monitor

Use *System Preferences > Displays > Calibrate*. Select Expert Mode.

## Mac Fuse notes

<http://code.google.com/p/macfuse/wiki/HOWTO>

When building, use "port" to install pkg-config, glib-2.0, glib2-devel

### sshfs

Don't build *sshfs* Universally (i.e., leave out `-arch ppc1`).
It won't work, because the port-installed libraries are i386-only.

Run `configure` like this:

    CFLAGS="-D__FreeBSD__=10 -O -g -arch i386 -isysroot /Developer/SDKs/MacOSX10.4u.sdk" LDFLAGS="-arch i386" ./configure --prefix=/usr/local --disable-dependency-tracking

After running `configure`, manually edit Makefile and remove `-pthread`

See also the list of FUSE file system projects at
<http://fuse.sourceforge.net/wiki/index.php/FileSystems>

### Uninstalling

From the FAQ (http://code.google.com/p/macfuse/wiki/FAQ):

Q: How can I uninstall MacFUSE Core?

A: If you installed "MacFUSE Core.pkg" version 0.1.9 or greater then
   you can use the uninstall script. From a terminal window run the
   following command:

    sudo /System/Library/Filesystems/fusefs.fs/uninstall-macfuse-core.sh

## Safari

See the [Safari](safari.html) cheat sheet.

## To capture audio going to sound driver

Use WireTap Pro: <http://www.ambrosiasw.com/utilities/wiretap/>

## To capture audio from specific applications

Use Audio Hijack Pro: <http://rogueamoeba.com/audiohijackpro/>

## Connecting to Windows share

Problem: Can't connect to Windows share; log says:

     smb_smb_negotiate: server configuration requires packet signing, which
     we dont support

See item #1 in the Samba cheat sheet.

## Capturing the screen

* Entire screen: Command-Shift-3
* Just a portion: Command-Shift-4, then drag rectangle around area

Results are written to a PNG file on the Desktop

## Disable the Dashboard

From MacOSXHints.com:

To turn Dashboard off:

    $ defaults write com.apple.dashboard mcx-disabled -boolean YES 

To turn Dashboard on:

    $ defaults write com.apple.dashboard mcx-disabled -boolean NO 

You have to restart the Dock after making either change for it to take
effect:

    $ killall Dock 

## Running Apache

Enable "Personal Web Sharing" in the *System Preferences > Sharing* panel.

- Personal directory is in `~/Sites`
- DocumentRoot is `/Library/WebServer/Documents`
- `httpd.conf` is in `/etc/httpd`

NOTE: When you enable personal web sharing, the system creates file
`/etc/httpd/users/$USER.conf` to contain the Apache `\<Directory\>`
entry for the user's Sites folder. Any changes (e.g., to enable
symlinking) must be made in there, not in `httpd.conf`.

## GNU configure errors

When building GNU-based open source, `configure` fails with

    configure fails with 'Can't determine host type'

Solution: Copy `config.guess` and `config.sub` from `/usr/share/libtool` to
the current directory (i.e., the directory containing the GNU
autoconf-generated `configure` script).

## NetBeans with Java 6

Use these settings, in `~/.netbeans/5.5/etc/netbeans.conf`:

    netbeans_default_options="-J-Dfile.encoding=UTF-8 -J-Dapple.awt.graphics.UseQuartz=true -J-Xms32m -J-Xmx512m -J-XX:PermSize=32m -J-XX:MaxPermSize=160m -J-Xverify:none -J-Dapple.laf.useScreenMenuBar=true --fontsize 11"

Courtesy: <http://www.entropy.ch/blog/2006/11/22/More-NetBeans-on-Mac.html>

## Startup Items

Primer on Startup Items:

<http://www.oreillynet.com/pub/a/mac/2003/10/21/startup.html>

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

## Encrypted file systems

Can use Apple's FileVault. However, it encrypts the entire home directory.
To encrypt only one directory tree, use one of these options:

* Use a FUSE-based file system like EncFS, in conjunction with Mac-FUSE.
  This option works very well, and it results in a "file system" that can
  be copied to a Linux machine and mounted there.

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

## Clear DNS cache

    $ sudo lookupd -flushcache

## Change printer info

Use `/Applications/Utilities/Printer Setup Utility`

## BIND on Mac OS X

<http://slaptijack.com/system-administration/bind-startup-in-mac-os-x-104-tiger/>
<http://slaptijack.com/system-administration/starting-bind-in-os-x-even-after-reboot/>

## Dynamic linking

Use DYLD_LIBRARY_PATH to pick up `.dylib` files.

## LPD printer stopped. No explanation

Solution: Check `/etc/hosts.lpd` on machine running LPD.

## Change file associations

To change default application that opens a file (e.g., PDF):

* Right click on a file of that type.
* Select *Get Info*
* Change the `Open with` value.
* Select `Change All` to change for all files, not just that one.

## Disable "Empty Trash" confirmation dialog

Go to *Finder > Preferences*, select the *Advanced* button, and uncheck
"Show warning before emptying the Trash." You may also wish to check the
"Empty Trash securely" while you're there.

## Running *cron*

<http://mactips.dwhoard.com/home/system/schedule-automatic-tasks>

Once the crontab file and the associated script file(s) have been created
and stored in the specified locations, you must initiate the cron process
by issuing the command:

    # crontab $HOME/.crontab

## Working with PDFs

### Merge two PDFs, or pages thereof

* Open both PDF documents in Preview.
* Ensure that the sidebar is visible in both. (*View > Sidebar > Show...*)
* Holding down the Command key, drag the pages from the source document to
  the target document.
* Rearrange within the sidebar of the target document.
* Save.

### Add an image to a PDF

* Convert the PDF document to an image with File > Save As.... Choose PN
  as the format and change the resolution as desired.
* Open the image file and select the whole image with Edit > Select Al
  (or select just a part of it with the mouse if you wish).
* Copy the selection via Command-C or *Edit > Copy*.
* Go back to the document (which is now a PNG image) and paste the
  selection with Command-V or *Edit > Paste*, and resize it as you wish.
* Save the file as a PDF with *File > Save As...* Choose PDF as the format.

Note that a PDF made from an image is not searchable, so that is a drawback
to this procedure.

## Control sound devices from menu bar

Use SoundSource: <http://www.rogueamoeba.com/freebies/>

## Prevent Mac from going to sleep

Use Caffeine, which sits in the menu bar: <http://lightheadsw.com/caffeine>

