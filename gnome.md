# Gnome Cheat Sheet

## Run startup script before Gnome starts

To get Gnome to run a startup script before invoking gnome-session (e.g.,
to ensure that various environment variables are set):

On Linux, do one of:

* Modify `/etc/X11/gdm/Sessions/Gnome` so that the appropriate file
  is sourced before gnome-session is exec'd. For instance, have
  it check for the existence of `$HOME/.gnome/init.sh`.

* Specify that an "xsession" style session is to be created, and have
  `.xsession` fire up `gnome-session` exactly as in
  `/etc/X11/gdm/Sessions/Gnome`. Then, be sure all the settings are in
  `.xsession`. Setting `LC_ALL=C` helps.

## Disable blinking cursor in gnome-terminal

    $ gnome-keybinding-properties

Fix it there. Takes effect immediately.

## Key bindings

Key bindings in Gnome (e.g., to fix the fact that, by default, ALT-SPACE
pulls up a menu, which messes with my Emacs):

    $ gconf-editor

See: *apps > metacity > global_keybindings* and
*apps > metacity > window_keybindings*

## Disable Alt-F opening Gnome Terminal menu:

Open Keyboard Preferences on an active terminal, and uncheck top checkbox.

## Single click to open a folder

* Open a folder (via Nautilus)
* *Edit > Preferences*
* *Behavior*

## Disable "empty trash" prompt

Getting Gnome desktop to quit prompting for trash emptying:

* Fire up `gconf-editor` from the command line
* Go to *apps > nautilus > preferences* and uncheck *confirm_trash*

Or: Just use *Edit > Preferences > Behavior* (as noted above).

## Get trash icon on desktop

* Fire up `gconf-editor` from the command line
* Under *apps > nautilus > desktop*, check *trash_icon_visible*

## Show the Computer, Home and Trash desktop icons in Gnome.

From <https://help.ubuntu.com/6.10/ubuntu/desktopguide/C/ch12s07.html>

* Run `gconf-editor`
* Choose: *apps > nautilus > desktop*
* Enable/disable whatever. Changes take place immediately.
