---
title: AquaEmacs Cheat Sheet
layout: cheat-sheet
---

# Loading .emacs

To get Aqua Emacs to load `~/.emacs`, create a file called `site-start.el`
in `~/Library/Application Support/Aquamacs Emacs`, with this line:

    (load-file "~/.emacs")
