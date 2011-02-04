# Windows Cheat Sheet

## Create a hotkey to lock the workstation

* Create a new shortcut on the desktop
* In the command-line box, type: rundll32.exe user32.dll, LockWorkStation
* Click "Next"
* Give the shortcut a name like "Lock Workstation"
* Click "Finish"
* Right-click on the shortcut icon, and select "Properties"
* In the "hotkey" box, press F10.
* Click "OK"

Adapted from <http://pubs.logicalexpressions.com/Pub0009/LPMArticle.asp?ID=70>

## Problems with Add or Remove Programs

When you attempt to open the Add or Remove Programs applet in the
Control Panel, the following message may appear:

    Add or Remove Programs has been restricted.
    Please check with your administrator.

This is due to one of the following Policy settings:

* NoAddRemovePrograms
* NoControlPanel

If your system is attached to a domain, your network administrator may have
disabled the Add or Remove Programs applet. For standalone systems, follow
the steps below to unlock the restrictions.

Click Start, Run and type `Regedit.exe`. Then, navigate to the following
branches one by one:

    HKEY_CURRENT_USER \ Software \ Microsoft \ Windows \ CurrentVersion \ Policies \ Uninstall
    HKEY_LOCAL_MACHINE \ Software \ Microsoft \ Windows \ CurrentVersion \ Policies \ Uninstall

Delete the `NoAddRemovePrograms` value if present in the above locations.

Then, navigate to following locations:

    HKEY_CURRENT_USER \ Software \ Microsoft \ Windows \ CurrentVersion \ Policies \ Explorer
    HKEY_LOCAL_MACHINE \ Software \ Microsoft \ Windows \ CurrentVersion \ Policies \ Explorer

Delete the `NoControlPanel` value in the above locations.

## Windows 2000: Repair

Repairing Win2K with installation CD when boot disk is trashed

* Boot from boot CD
* Select repair option
* Try auto-repair.
* If that doesn't do the trick, select manual repair.
* From CMD prompt, run `CHKDSK C: /R`
* You might have to poke around to find a required EXE

## Generating an icon file that'll work with Windows

Creating an MS Windows "favicon.ico" file:

- Create a PNG.
- Scale it to 16x16. (ImageMagick's *convert*(1) works well.)
- Use `png2ico` to pack it into an "ico" file. See the `png2ico` port on
  the Mac.

## Windows Autorun

How to Make a CD-R Automatically Play a Video or Display a web page using
the Autoplay feature. From
<http://website.lineone.net/~andy.savage3/tips/#autocd>

If you place a file called `autorun.inf` in the root of the disc, then the
PC will run the script in it when it is inserted into a PC's DVD/CD drive.

To make a MPEG movie play all you need to do is use the Windows `START`
command to launch the media player with your video.

To do this, create a Notepad document called `autorun.inf` and put the
following text into it, substituting the name of the video with yours.

    [autorun]
    open=C:\windows\command\start.exe myvideo.mpg

Remember to save the file as `autorun.inf`.

If you burn a CD-R with this file and your MPEG video in the root of the CD,
it will automatically play the video when inserted. This method can also be
used to auto run an HTML page you have on your CD, This means that you can
create a nice front end menu system for the CD. This is ideal if you want
to create an interactive photo album forsomeone. You can make it launch
your index.html page which will could have thumbnails links to your
photographs on it, you could combine this with the Kiosk mode option of IE5

This will work on all Windows 95/98/ME machines where windows has been
installed to the standard directory of "C:\Windows"

Please note that this does not work on NT machines because Windows is not
installed in the Windows directory.

## Windows printing

### Getting Windows to talk to a Unix LPD/LPR printer

Getting Vista or Windows 7 to talk to a Unix printer via LPD/LPR:
<http://uis.georgetown.edu/labs/instructions/winvista.print.pctolabprinter.html>

### Updating print drivers

Updating Windows 7's print drivers (i.e., adding more Microsoft drivers):

* *Start > Devices and Printers*
* Select a printer
* When *Print server properties* appears up top, click on it.
* In the resulting pop-up window, select the *Drivers* tab.
* Click the *Add...* button.
* Click *Next* until you get to the Printer Driver Selection window.
* Click *Windows Update*.
* Wait a surprisingly long time.
* When the dialog returns, find the manufacturer and print driver for
  the printer. Select it and hit *Next*.
* On the final screen, click *Finish*. This might take awhile to complete.

The driver should now be available when adding a printer.

### Getting Windows 7 to talk to a CUPS printer on another system.

See #16 in the "Ubuntu" cheat sheet.





