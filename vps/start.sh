#!/bin/sh

# Create tun interface
echo "Create tun interface..."
ip tuntap del tun1000 mode tun
ip tuntap add tun1000 mode tun
ip link set tun1000 up
ip addr add 10.20.30.1/24 dev tun1000

# Flush route cache
ip route flush cache

# Enable ip forward
sysctl -w net.ipv4.ip_forward=1

# Setup iptables
echo "Setup iptables..."
iptables -D FORWARD -i tun1000 -j ACCEPT 2>/dev/null
iptables -I FORWARD -i tun1000 -j ACCEPT
iptables -D FORWARD -o tun1000 -j ACCEPT 2>/dev/null
iptables -I FORWARD -o tun1000 -j ACCEPT
iptables -t nat -D POSTROUTING -s 10.20.30.0/24 -j MASQUERADE 2>/dev/null
iptables -t nat -I POSTROUTING -s 10.20.30.0/24 -j MASQUERADE
