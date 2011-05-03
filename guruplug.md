---
title: GuruPlug Cheat Sheet
layout: cheat-sheet
---

*This cheat sheet concerns the [GuruPlug][] plug computing device, a 5-watt
ARM device that, by default, runs [Debian][]. My device has two Ethernet cards
and WiFi capability.*

[Debian]: http://www.debian.org/
[GuruPlug]: http://en.wikipedia.org/wiki/GuruPlug

# Turning GuruPlug into a bridging WAP

**Goal**: To turn the plug into a [wireless bridge][], with one Ethernet
interface and the wireless interface on the same (internal) subnet.

[wireless bridge]: http://en.wikipedia.org/wiki/Wireless_bridge

## bridge-utils

First, install *bridge-utils*.

    $ apt-get install bridge-utils

Assumptions:

* Inside wired interface is `eth0`
* Wireless interface is `uap0`
* `eth1` is connected to the Internet (or some other subnet)

## Create bridge

Edit `/etc/network/interfaces` to define the bridge:

    auto lo
    iface lo inet loopback
           # up /etc/ip6up

    auto eth0
    iface eth0 inet static
    address 0.0.0.0

    auto uap0
    iface uap0 inet static
    address 0.0.0.0

    auto eth1
    iface eth1 inet dhcp
        # When the Internet link comes up, with a DHCP address, I end up
        # with two default routes, one for the outside link and one for the
        # inside link. This screws up routing, as one might expect. The
        # following seems to help:
        up /sbin/route del default gw 192.168.3.2

    auto br0
    iface br0 inet static
            address 192.168.3.1
            netmask 255.255.255.0
            network 192.168.3.0
            broadcast 192.168.3.255
            gateway 192.168.3.1
            #bridge_stp off
            bridge_ports uap0 eth0
            # 
            # For some reason, uap0 does not end up in the bridge.
            # Force it.
            up /usr/sbin/brctl addif br0 uap0

Note the `up` line at the bottom. This hack was the only way I could force
the bridge to contain the wireless device. If the bridge does not contain
the wireless device, one symptom will be that DHCP requests from wireless
clients won't be answered (because the DHCP server won't see them).

If the wireless device doesn't end up in the bridge, just add it manually:

    # /usr/sbin/brctl addif br0 uap0

## Configure the DHCP server.

### `udhcpd`

If using `udhcp`, be sure the `br0` interface is specified in the
configuration file, `/etc/udhcpd.conf`:

    interface br0

### `dnsmasq`

If using the DHCP server in `dnsmasq`, be sure the `br0` interface is
specified in the configuration file, `/etc/dnsmasq.conf`:

    bind-interfaces br0

### ISC DHCPD

If using the ISC DHCP server, modify `/etc/default/isc-dhcp-server` so that
`INTERFACES` contains `br0`:

    INTERFACES="br0"

This setting tells `/etc/init.d/isc-dhcp-server` to pass `br0` on the
command line.

# Routing issues

*Reproduced from a comment in the `/etc/network/interfaces` file, above.*

When the Internet link comes up, with a DHCP address, I end up
with two default routes, one for the outside link and one for the
inside link. This screws up routing, as one might expect. The
following fixes the problem:

    # /sbin/route del default gw 192.168.3.2


# Default root password

All GuruPlugs ship with the same default root password ("nosoup4u"). If
you've connected the GuruPlug to the Internet and left SSH open to the
outside, it's a good idea to change the root password.

# Run the SSH daemon on another port

While this is just [security through obscurity][], generally a [fail][],
it's still not a bad idea. Edit `/etc/ssh/sshd_config` and change the `Port`
line to something else, e.g.:

    Port 10022

[security through obscurity]: http://en.wikipedia.org/wiki/Security_through_obscurity
[fail]: http://failblog.org/

# Firewall

If connected to the Internet, you should obviously install some firewall
rules. I set things up so that there's a `firewall.sh` script in
`/usr/local/sbin`, that fires whenever `dhclient(8)` gets a new Internet
address from my provider.

Sample: [`firewall.sh`](firewall.sh)
