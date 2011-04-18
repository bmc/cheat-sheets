#!/bin/bash
#
# Called by dhclient hook script.

# eth0 is connected to a private subnet.
# eth1 (passed in) is connected to the internet.

ip=${1?'Missing IP address'}
ext_if=${2?'Missing interface'}

ip=$1
if [ -z $ip ]
then
    logger -s -t firewall.sh -p daemon.err "No IP address for $ext_if."
    exit 1
fi

logger -s -t firewall.sh -p daemon.info "Updating firewall rules for $ip"

# Where we'll be doing some port forwarding later.
INSIDE_SERVER=$(host -4 inside-server.example.org|awk '{print $NF}')

PRIVATE_IF=eth0
PRIVATE=172.16.87/24

# Loopback address
LOOP=127.0.0.1

# ---------------------------------------------------------------------------
# Delete old iptables rules and temporarily block all traffic.

iptables -P OUTPUT DROP
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -F

# ---------------------------------------------------------------------------
# Set default policies

iptables -P OUTPUT ACCEPT
iptables -P INPUT DROP
iptables -P FORWARD DROP

# ---------------------------------------------------------------------------
# Prevent external packets from using loopback addr

iptables -A INPUT -i $ext_if -s $LOOP -j DROP
iptables -A FORWARD -i $ext_if -s $LOOP -j DROP
iptables -A INPUT -i $ext_if -d $LOOP -j DROP
iptables -A FORWARD -i $ext_if -d $LOOP -j DROP

# ---------------------------------------------------------------------------
# Anything coming from the Internet should have a real Internet address

iptables -A FORWARD -i $ext_if -s 192.168.0.0/16 -j DROP
iptables -A FORWARD -i $ext_if -s 172.16.0.0/12 -j DROP
iptables -A FORWARD -i $ext_if -s 10.0.0.0/8 -j DROP
iptables -A INPUT -i $ext_if -s 192.168.0.0/16 -j DROP
iptables -A INPUT -i $ext_if -s 172.16.0.0/12 -j DROP
iptables -A INPUT -i $ext_if -s 10.0.0.0/8 -j DROP

# ---------------------------------------------------------------------------
# Block outgoing NetBios (if you have windows machines running on the
# private subnet). This will not affect any NetBios traffic that flows over
# the VPN tunnel, but it will stop local windows machines from broadcasting
# themselves to the internet.

iptables -A FORWARD -p tcp --sport 137:139 -o $ext_if -j DROP
iptables -A FORWARD -p udp --sport 137:139 -o $ext_if -j DROP
iptables -A OUTPUT -p tcp --sport 137:139 -o $ext_if -j DROP
iptables -A OUTPUT -p udp --sport 137:139 -o $ext_if -j DROP

# ---------------------------------------------------------------------------
# Check source address validity on packets going out to internet

iptables -A FORWARD -s ! $PRIVATE -i $PRIVATE_IF -j DROP

# ---------------------------------------------------------------------------
# Allow local loopback

iptables -A INPUT -s $LOOP -j ACCEPT
iptables -A INPUT -d $LOOP -j ACCEPT

# ---------------------------------------------------------------------------
# Allow incoming pings (can be disabled)

#iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

# ---------------------------------------------------------------------------
# Allow services such as www and ssh (can be disabled)

#iptables -A INPUT -p tcp --dport http -j ACCEPT
iptables -A INPUT -p tcp --dport ssh -j ACCEPT

# ---------------------------------------------------------------------------
# OpenVPN: If running OpenVPN on the plug.

# Allow incoming OpenVPN packets. Duplicate the line below for each
# OpenVPN tunnel, changing --dport n  to match the OpenVPN UDP port.
#
# In OpenVPN, the port number is controlled by the --port n option.
# If you put this option in the config file, you can remove the leading '--'
#
# If you are taking the stateful firewall approach (see the OpenVPN HOWTO),
# then comment out the line below.

#iptables -A INPUT -p udp --dport 1194 -j ACCEPT

# Allow packets from TUN/TAP devices.  When OpenVPN is run in a secure mode,
# it will authenticate packets prior to their arriving on a tun or tap
# interface.  Therefore, it is not necessary to add any filters here,
# unless you want to restrict the type of packets which can flow over
# the tunnel.

#iptables -A INPUT -i tun+ -j ACCEPT
#iptables -A FORWARD -i tun+ -j ACCEPT
#iptables -A INPUT -i tap+ -j ACCEPT
#iptables -A FORWARD -i tap+ -j ACCEPT

# ---------------------------------------------------------------------------
# Allow packets from private subnets

iptables -A INPUT -i $PRIVATE_IF -j ACCEPT
iptables -A FORWARD -i $PRIVATE_IF -j ACCEPT

# ---------------------------------------------------------------------------
# Keep state of connections from local machine and private subnets

iptables -A OUTPUT -m state --state NEW -o $ext_if -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m state --state NEW -o $ext_if -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

# ---------------------------------------------------------------------------
# Masquerade local subnet

iptables -t nat -A POSTROUTING -s $PRIVATE -o $ext_if -j MASQUERADE

# ---------------------------------------------------------------------------
# PORT FORWARDING
#
# See http://goo.gl/0zNk4
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# Pass OpenVPN through to the back end (TCP).

iptables -t nat -A PREROUTING -p tcp -i $ext_if -d $ip \
    --dport 10022 --sport 1024:65535 -j DNAT --to ${INSIDE_SERVER}:22

# After DNAT, the packets are routed via the filter table's FORWARD chain.

iptables -A FORWARD -p tcp -i $PRIVATE_IF -o $ext_if -d ${INSIDE_SERVER} \
    --dport 22 --sport 1024:65535 -m state --state NEW -j ACCEPT

iptables -A FORWARD -t filter -o $PRIVATE_IF -m state \
    --state NEW,ESTABLISHED,RELATED -j ACCEPT

iptables -A FORWARD -t filter -i $PRIVATE_IF -m state \
    --state ESTABLISHED,RELATED -j ACCEPT

# ---------------------------------------------------------------------------
# Pass SSH on port 9022 through to the back end.

