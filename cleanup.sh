#!/bin/bash
echo "Pulizia storia utente" 
sudo -iu studente bash << EOF
history -c
cat /dev/null > .bash_history
EOF
history -c
cat /dev/null > .bash_history
echo "Rimozione pacchetti parzialmente rimossi o obsoleti"
apt autoremove
echo "Rimozione cache pacchetti installati"
rm /var/cache/apt/archives/*
echo "Rimozione indice pacchetti (da ricostruire con apt update)"
rm /var/lib/apt/lists/*
#sudo dpkg --purge `dpkg --get-selections | grep deinstall | cut -f1`
echo "Azzeramento disco inutilizzato"
sudo dd if=/dev/zero of=/EMPTY bs=1M;sudo rm -f /EMPTY
echo "Pulizia registrazione DHCP"
sudo dhclient -r enp0s8
sudo rm /var/lib/dhcp/*.leases
echo "Sincronizzazione: finito!"
sudo sync
echo "Reboot"
exit 0
sudo halt
