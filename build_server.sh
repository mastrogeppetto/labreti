#!/bin/bash

# ATTENZIONE: VA ESEGUITO SULLA MACCHINA VIRTUALE

# Provato su mini ubuntu 14.04: va riprovato sulla 16.04, sostituendo
# enp0s8 con enp0s8. Caricamento pacchetti da completare.

fail() { echo -e "\n===\nErrore\n===\n"; exit 1; }

# Configurazione automatica rete hostonly
cat > /etc/netplan/enp0s8.yaml <<EOF
# The hostonly network interface
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s8:
      dhcp4: true
EOF

# sudo senza password
scp studente studente@192.168.5.2:/etc/sudoers.d/studente

# autologin su tty01
scp autologin@.service studente@192.168.5.2:/etc/systemd/system/autologin@.service
systemctl daemon-reload
systemctl disable getty@tty1
systemctl enable autologin@tty1
systemctl start autologin@tty1

# motd con indirizzo IP e MAC
cat > /etc/update-motd.d/92-vminfo <<"EOF"
#!/bin/sh
IPaddr=`ip addr show dev enp0s8 | egrep "inet\b" | tr -s " " | cut -f3 -d " "`
MACaddr=`ip link | grep -A2 enp0s8 | tail -1 | tr -s " " | cut -f 3 -d " "`
echo " * IP address: $IPaddr"
echo " * MAC address: $MACaddr"
EOF
sudo chmod a+x /etc/update-motd.d/92-vminfo

exit 0


if ! apt-get -y update; then fail; fi
if ! apt-get -y upgrade; then fail; fi
# midori web browser
# if ! apt-get -y install midori; then fail; fi
# Virtualbox guest utils (non sono sicuro che funzionino sempre...)
# if ! apt-get -y install virtualbox-guest-utils; then fail; fi
# Lab tools
if ! apt-get -y install traceroute curl wget; then fail; fi
adduser telematica wireshark
# git conky
if ! apt-get -y install git-core; then fail; fi
# red hat cloud (openshift)
if ! apt-get -y install ruby-full; then fail; fi
if ! apt-get -y install rubygems; then fail; fi
if ! gem install rhc; then fail; fi
# 
# Pulizia
rm /var/cache/apt/archives/*

# CONFIGURAZIONE UTENTE
cd

sudo -u telematica git clone https://augusto_ciuffoletti@bitbucket.org/augusto_ciuffoletti/labreti5.git Scrivania/labreti
#rm .bash_history
# Ora l'utente deve:
# git config --global user.name "Your Name Comes Here"
# git config --global user.email you@yourdomain.example.com
# rhc setup


