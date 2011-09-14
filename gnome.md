---
title: Gnome Cheat Sheet
layout: cheat-sheet
---

# Run startup script before Gnome starts

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

# Disable blinking cursor in gnome-terminal

    $ gnome-keyboard-properties

Fix it there. Takes effect immediately.

# Key bindings

Key bindings in Gnome (e.g., to fix the fact that, by default, ALT-SPACE
pulls up a menu, which messes with my Emacs):

    $ gconf-editor

See: *apps > metacity > global_keybindings* and
*apps > metacity > window_keybindings*

## Typing accented characters

First, ensure that you have a Compose Key on your keyboard. In
*System > Preferences > Keyboard*, select the *Layouts* tab, click the
keyboard name, and press *Show...*. Verify that a Compose Key is set.

Then, use the *Compose* + *accent-key* + *character* sequence to generate
an accent. Note: Unlike on the Mac, where you use *Option* as a chorded key,
use *Compose* separately (e.g., *Compose*, **then** *accent**, **then*
*character*).

On a standard USA keyboard, *Compose* is often the left Windows key.

Examples:

* *Compose*, \`, e **yields** &eacute;
* *Compose*, ", e **yields** &euml;
* *Compose*, comma (,), c **yields** &ccedil;
* *Compose* ^ a **yields** &acirc;

# Disable Alt-F opening Gnome Terminal menu:

Open Keyboard Shortcuts on an active terminal, and uncheck top checkbox.

# Single click to open a folder

* Open a folder (via Nautilus)
* *Edit > Preferences*
* *Behavior*

# Disable "empty trash" prompt

Getting Gnome desktop to quit prompting for trash emptying:

* Fire up `gconf-editor` from the command line
* Go to *apps > nautilus > preferences* and uncheck *confirm_trash*

Or: Just use *Edit > Preferences > Behavior* (as noted above).

# Get trash icon on desktop

* Fire up `gconf-editor` from the command line
* Under *apps > nautilus > desktop*, check *trash_icon_visible*

# Show the Computer, Home and Trash desktop icons in Gnome.

From <https://help.ubuntu.com/6.10/ubuntu/desktopguide/C/ch12s07.html>

* Run `gconf-editor`
* Choose: *apps > nautilus > desktop*
* Enable/disable whatever. Changes take place immediately.

# Disabling Workspace Switcher tooltips

From: <http://www.wtfm.org/tooltip>:

This is as a workaround to a bug that left some tooltips "hanging" and
were generally annoying. ...

If you want to disable the "Click to start dragging" tooltip (when you
hover over a workspace in the workspace switcher) and that for the
calendar, so they don't linger around or pop up in the first place, do the
following:

Start `ccsm`:

    $ ccsm

Go to *Accessibility > Opacity, Brightness and Saturation > Opacity >*
*Window specific settings*. Create settings like this:

| class=^Clock-applet$ & type=Tooltip | 0 |
| class=^Wnck-applet$ & type=Tooltip  | 0 |

Be sure to click the *Enable Opacity, Brightness and Saturation* checkbox.

# Compiz

## Disable resize when mouse moves on top border

*Symptom*: Moving the mouse upwards on the top border of a window initiates
a resize action (e.g., with a growing orange rectangle).

*Solution*: In the CompizConfig Settings Manager, go to *Window Management*,
then *Grid*, and select *Edges*. Under *Resize Actions*, select "None".
