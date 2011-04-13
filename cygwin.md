---
title: Cygwin Cheat Sheet
layout: cheat-sheet
---

# Installing & starting a [Cygwin][] service

## inetd

    cygrunsrv -I inetd -d "CYGWIN inetd" -p /usr/sbin/inetd -a -d -e CYGWIN=ntsec
    cygrunsrv -S inetd

## cron

    cygrunsrv -I cron -p /usr/sbin/cron -a -D
    cygrunsrv -S cron

[Cygwin]: http://www.cygwin.com/
