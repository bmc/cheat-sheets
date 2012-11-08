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

# Installing SSHD

See: <http://www.howtogeek.com/howto/41560/how-to-get-ssh-command-line-access-to-windows-7-using-cygwin/>

[Cygwin]: http://www.cygwin.com/
