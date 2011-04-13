---
title: BitTorrent Cheat Sheet
layout: cheat-sheet
---

# The original *curses* client

## Installing

Linux:

    $ sudo yum install bittorrent            # Fedora
    $ sudo apt-get install python-bittorrent # Ubuntu and Debian

FreeBSD:

> Install `/usr/ports/net/py-bittorrent`

## Running

    $ btdownloadcurses.py --max_allow_in 10 --max_initiate 10 -minport 6881 --maxport 6889 torrentfile

# Good cross-platform GUI client

Transmission: <http://transmissionbt.com/>
