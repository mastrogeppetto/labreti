#!/bin/bash
cd
history -c
cat /dev/null > .bash_history
sudo rm /var/cache/apt/archives/*
sudo dd if=/dev/zero of=/EMPTY bs=1M;sudo rm -f /EMPTY
sudo dhclient -r enp0s8
sudo rm /var/lib/dhcp/*.leases
# rimuove pacchetti parzialmente rimossi o obsoleti
sudo dpkg --purge `dpkg --get-selections | grep deinstall | cut -f1`
suro rm /var/lib/apt/lists/* # si ricostruiscono con apt-get update
sync
sudo halt
