#!/bin/sh

nvram set jffs2_on=1
nvram set jffs2_enable=1
nvram set jffs2_scripts=1
nvram set jffs2_exec="/jffs/ac86u-ssh-tunnel/jffs.autorun"
nvram commit

umount /opt

rm -rf /jffs/opt
mkdir /jffs/opt
mkdir /jffs/opt/bin
mkdir /jffs/opt/doc
mkdir /jffs/opt/etc
mkdir /jffs/opt/include
mkdir /jffs/opt/lib
mkdir /jffs/opt/sbin
mkdir /jffs/opt/scripts
mkdir /jffs/opt/share
mkdir /jffs/opt/tmp
mkdir /jffs/opt/usr
mkdir /jffs/opt/var

cp -f /opt/scripts/* /jffs/opt/scripts

mount -o bind /jffs/opt /opt

wget -O - http://pkg.entware.net/binaries/armv7/installer/entware_install.sh | sh

opkg install openssh-client autossh socat redsocks monit

opkg install --force-checksum --force-reinstall /jffs/ac86u-ssh-tunnel/ipk/libmnl_1.0.4-1_armv7soft.ipk
opkg install --force-checksum --force-reinstall /jffs/ac86u-ssh-tunnel/ipk/libipset_6.32-2_armv7soft.ipk
opkg install --force-checksum --force-reinstall /jffs/ac86u-ssh-tunnel/ipk/ipset_6.32-2_armv7soft.ipk

cp -f /jffs/ac86u-ssh-tunnel/opt/etc/* /jffs/opt/etc
chmod 600 /opt/etc/monitrc

chmod +x /jffs/ac86u-ssh-tunnel/jffs.autorun
chmod +x /jffs/ac86u-ssh-tunnel/dns/ipset-dns
find /jffs/ac86u-ssh-tunnel -name "*.sh" -exec chmod +x {} \;

echo "Please update ac86u-ssh-tunnel/id_rsa to your own rsa private key file"
echo "Please update ac86u-ssh-tunnel/.env to config your vps user/host/port"