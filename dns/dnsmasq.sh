#!/bin/sh

for env in `cat /jffs/ac86u-ssh-tunnel/.env`;
do
  eval "${env}"
done

echo "server=127.0.0.1" > /jffs/opt/etc/resolv.conf
ln -sf /jffs/opt/etc/resolv.conf /etc/resolv.conf

echo "server=$ORIGINAL_DNS" > /tmp/resolv.conf

echo "server=$ORIGINAL_DNS" > /tmp/resolv.dnsmasq

for domain in `cat /jffs/ac86u-ssh-tunnel/dns/tunnel-domains.txt`;
do
  echo "server=/$domain/127.0.0.1#53000" >> /tmp/resolv.dnsmasq
done

/sbin/service restart_dnsmasq
