---
title: GTK2 Cheat Sheet
layout: cheat-sheet
---

# Key bindings

From <http://neugierig.org/content/gtk2/>:

The default GTK2 key bindings are supposed to be more user-friendly (Ctl+A
maps to "select all", for instance). To enable Emacs bindings:

* Fire up `gconf-editor`
* Go to `/desktop/gnome/interface/gtk_key_theme`
* Change entry from *Default* to *Emacs*

Change should be immediate, though some apps may require a restart.
