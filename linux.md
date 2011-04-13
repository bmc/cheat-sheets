---
title: Linux Cheat Sheet
layout: cheat-sheet
---

# Single User Boot

To perform single user boot with GRUB perform the steps:

* type p and password if required
* type e to enter edit mode
* select the kernel command line and append single for single user
  boot, or run level number (1 through 5)
* type b to boot the system

# UTF-8

Both *vi* (*vim*) and *emacs* will grok UTF-8 if you set `LANG`
appropriately, e.g.:

    export LANG=en_US.UTF-8
    
