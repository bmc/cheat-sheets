---
title: PBX Cheat Sheet
layout: cheat-sheet
---

*Notes on FreePBX, IncrediblePBX, and the like.*

# Installation

## Copy the ISO to the SDHC card

* Download IncrediblePBX for Pi. See <http://nerdvittles.com/?p=3026>
* Unpack the tarball.
* Put the SDHC card in the card reader (assumes Linux).
* Run the `make-sdhc` script that came out of the tarball.

## Put the Pi on the network

For security reasons, do *not* put the Pi outside your firewall!

## Boot the Pi.

Put the SDHC card in the Pi, attach the HDMI port to a monitor, and boot.

## Initial configuration

* Log in as `root`. Initial password is `raspberry`.
* Allow IncrediblePBX to update itself.
* At the bash prompt, run `raspi-config`.
* If the SD card has more than 4Gb, choose the menu item to expand the file
  system. (The ISO is only 4Gb, and Linux will only see that much, unless
  you expand the file system.)
* Possibly select the overclock option, as well.
* Enable the SSH daemon.
* Reboot.

In a terminal window on another machine, `ssh` into the PBX machine.

## Configure MySQL

The docs I've seen don't say what the IncrediblePBX distribution uses for
the MySQL root password, and it's useful to be able to get into MySQL. Set
the root password as follows:

    # /etc/init.d/mysql stop 
    # mysqld_safe --skip-grant-tables &
    # mysql -u root
    mysql> use mysql;
    mysql> update user set password=PASSWORD("NEW-PASSWORD") where user='root';
    mysql> flush privileges;
    mysql> quit
    # /etc/init.d/mysql restart
    # mysql -u root -p

## Change the host name

Edit `/etc/hostname` to reflect your desired host name. Then, run:

    # hostname $(cat /etc/hostname)
    
## Install and configure postfix

This is only necessary if you prefer *postfix* to the default *exim*.

    # apt-get install postfix

A smart host relay is sufficient. Having a configured mail server allows
the PBX to email voice mail audio files.

### Using Gmail as a relay

First, you'll need TLS support, which requires installing some supplementary
packages.

    # apt-get install libsasl2-modules

Next, add the following to `/etc/postfix/main.cf`

    # Use Gmail as smart relay. See
    # http://mhawthorne.net/posts/postfix-configuring-gmail-as-relay.html and
    # http://anothersysadmin.wordpress.com/2009/02/06/postfix-as-relay-to-a-smtp-requiring-authentication/
    relayhost = [smtp.gmail.com]:587
    smtp_sasl_auth_enable = yes
    smtp_sasl_password_maps = hash:/etc/postfix/sasl_password
    smtp_sasl_security_options = noanonymous

    smtp_use_tls = yes
    smtp_tls_security_level = secure
    smtp_tls_mandatory_protocols = TLSv1
    smtp_tls_mandatory_ciphers = high
    smtp_tls_secure_cert_match = nexthop
    smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt

Change `masquerade_domains` appropriately, as well.

Finally, you have to add authentication parameters. Create
`/etc/postfix/sasl_password` with the following contents:

    [smtp.gmail.com]:587 gmailuser:gmailpassword
    
Replace `gmailuser` with your Gmail login. If you use a Google Apps
domain account, use your domain email address as the user.

Then, run these commands:

    # cd /etc/postfix
    # postmap sasl_password
    # chown postfix sasl_password*

## Adjust your router's firewall

With your Pi behind your firewall, you'll have to open some ports. Configure
your firewall to pass UDP ports 5060, 5061, and 10,000 through 20,000 to and
from the Pi. If you're using a Linux-based *iptables* firewall, the following
rules should do the trick

    EXT_IF=...   # The external, Internet visible interface (e.g., eth0)
    PBX=...      # The internal IP address of your Raspberry Pi PBX machine

    iptables -t nat -A PREROUTING -i $EXT_IF -p udp -m udp \
             -dport 10000:20000 -j DNAT --to-destination $PBX
    iptables -t nat -A PREROUTING -i $EXT_IF -p udp -m udp \
             -dport 5060:5061 -j DNAT --to-destination $PBX

## Configure the PBX

* Connect to the web server on the Pi.
* Select the administration logo. 
* Log in as `admin`, with password `admin`.
* Change the password, under the Admin > Administrators menu.
* Under the Settings menu, select Asterisk Settings.
* Set the NAT configuration.

# Ongoing Configuration

## Forwarding to an external number after so many rings

Two simple solutions:

### Follow Me

1. Applications > Follow Me
2. Select the extension.
3. Select *hunt* as the Ring Strategy.
4. Add the number, with a trailing #, to the Follow-Me List.
5. Optional: Adjust the ring time. 

**Note**: If the target of an inbound route is a ring group, rather than an
extension, you must include a "#" on the end of the extension in the ring
group to force Follow Me behavior.

### Chained ring groups

1. Put the external number in its own ring group (e.g., ring group #601).
2. Set the "Destination if no answer" to "Voicemail".
3. Put the main extension in different ring group (e.g., ring group #600),
   and point the inbound route at this ring group.
4. In this primary ring group (#600), set the ring time appropriately.
5. Set the "Destination if no answer" to go to the second ring group.

### Ensuring that the original caller ID follows a forwarded call

Go into Advanced Settings and change **SIP trustrpid** and **SIP sendrpid** to
`yes`.

Also, make *sure* you don't have the Outbound CID set on the primary
extension.

**NOTE**: This strategy may not work. The DID provider may not honor the PBX's
attempt to pass along the original caller ID. (Mine doesn't; I always see the
caller ID of the PBX's outbound trunk.)

In that case, one solution is to modify the second ring group (#601, in the
example above) so that "Confirm Calls" is checked. When the call is
forwarded, the PBX (which knows the original caller ID) will play a short
message ("press 1 to accept the call, 2 to reject it, 3 to listen to the
caller ID information"). This approach provides a way to allow the callee
to get the caller ID information, even though it's not passed along by the
telco. **Be sure to configure enough ring time on the second ring group to
permit the callee to listen to the message!**

## Ensuring that an extension only uses specific outbound routes

This is useful if you have, say, a home line and an office line on the
same PBX, and you want to ensure that each one uses a specific outbound route.

Solutions proposed on the web include:

1. Using the complicated, and unsupported, Custom Contexts module.
   **This is a potentially dangerous module that can totally bork your PBX.**
2. Using something called Extension Routing, by SchmoozeCom; getting it
   requires a complicated registration procedure at SchmoozeCom, one that
   doesn't appear to work with Incredible PBX.
3. Using a dial pattern to specify individual internal extension caller IDs
   on each outbound route.

(I have not gotten this working yet.)

## Modifying the inbound caller ID.

* Install the Set Caller ID module. This module works as a filter.
* Create a new Set Caller ID, editing the inbound caller ID as appropriate.
* Set the new Set Caller ID's destination to be the desired extension or
  ring group. If adding a prefix (e.g., "H" to indicate that the call came
  into the home line), it's best just to modify the caller ID name.
* Go to the appropriate inbound route and set its destination to the new
  Set Caller ID.

# Misc. Admin

## Restarting Asterisk

    # amportal restart
    
## Changing the log level

**First, ensure that the FreePBX Asterisk Logfiles module is installed.**

* Within the FreePBX web UI, go to Admin > Module Admin
* Click the Check Online button
* Location the Asterisk Logfiles module and install it, if it isn't
  already installed.
  
**Next, adjust the logging.**

* Go to Settings > Asterisk Logfile Settings

## Backups

Needless to say, it's a *really good idea* to backup your PBX. It's possible
to screw things up beyond the point of recovery (especially using experimental
modules like Custom Contexts).

To schedule a routine backup, ensure that the Backup and Restore module is
installed. (By default, it should be.) Then, go to Admin > Backup. The
"Full Backup" template is a reasonable place to start.

Backups are written to `/var/spool/asterisk/backup`. Copying this directory
off to another machine is also a wise idea.

# Provider-specific

## Vitelity

### Sample trunk configurations, using a subaccount

#### Outbound

Set **Maximum Channels** to 2.

Set the **Outbound Caller ID** to the number for the DID you're using
for outbound calls.

Set the trunk name under **Outgoing Settings** (e.g., `vitel-out`).

Set **PEER Details** under **Outgoing Settings** to something like the
following. Replace the username and secret to correspond to the Vitelity
subaccount.

    type=friend
    dtmfmode=auto
    username=subaccount_user
    secret=subaccount_password
    fromuser=subaccount_user
    trustrpid=yes
    sendrpid=yes
    context=ext-did
    canreinvite=no
    nat=yes
    host=outbound.vitelity.net

#### Inbound

Set the trunk name under **Outgoing Settings** (e.g., `vitel-in`).

Set **PEER Details** under **Outgoing Settings** to something like the
following. Replace the username and secret with the credentials of the
Vitelity subaccount you're using.

    type=friend
    dtmfmode=auto
    username=subaccount_user
    secret=subaccount_password
    context=from-trunk
    insecure=port,invite
    canreinvite=no
    nat=yes
    host=inbound29.vitelity.net

Set the **Register String**. Again, replace the username and secret with
the credentials of the Vitelity subaccount you're using.

    subaccount_user:subaccount_password@inbound29.vitelity.net:5060

If inbound calls aren't working, be sure to set the provider route for the
DID(s) appropriately, via the DIDs page on the Vitelity customer portal.

# Troubleshooting

## Can't access voicemail

### Password not accepted

You enter the password on the phone handset, but it isn't accepted. Common
problem: The phone isn't a SIP phone, and you're using an adapter, but the
adapter's DTMF method isn't set to "SIP INFO" for that extension. Set the
DTMF method to "SIP INFO" and try again.

# References

* <http://nerdvittles.com/?p=755>
* <http://nerdvittles.com/?p=3026>
