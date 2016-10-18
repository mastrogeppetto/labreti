#!/bin/bash

# ATTENZIONE: VA ESEGUITO SULLA MACCHINA VIRTUALE

# Provato su mini ubuntu con lubuntu minimal
fail() { echo -e "\n===\nErrore\n===\n"; exit 1; }

# Configurazione automatica rete hostonly
cat > /etc/network/interfaces.d/enp0s8 <<EOF
# The hostonly network interface
auto enp0s8
iface enp0s8 inet dhcp
EOF

# sudo senza password
cat > /etc/sudoers.d/telematica <<EOF
telematica ALL=(ALL:ALL) NOPASSWD:ALL
EOF
sudo chmod 0440 /etc/sudoers.d/telematica

# login automatico
cat > /etc/lightdm/lightdm.conf <<EOF
[SeatDefaults]
autologin-user=telematica
autologin-user-timeout=5
EOF

if ! apt-get -y update; then fail; fi
if ! apt-get -y upgrade; then fail; fi
# midori web browser
if ! apt-get -y install midori; then fail; fi
# Virtualbox guest utils (non sono sicuro che funzionino sempre...)
if ! apt-get -y install virtualbox-guest-utils; then fail; fi
# Lab tools
if ! apt-get -y install wireshark packeth traceroute curl wget geany; then fail; fi
adduser telematica wireshark
# git conky
if ! apt-get -y install git-core conky-all; then fail; fi
# red hat cloud (openshift)
if ! apt-get -y install ruby-full; then fail; fi
if ! apt-get -y install rubygems; then fail; fi
if ! gem install rhc; then fail; fi
# 
# Pulizia
rm /var/cache/apt/archives/*

# CONFIGURAZIONE UTENTE
cd
# Attivazione conky
if ! grep conky ~/.config/lxsession/LXDE/autostart > /dev/null
then
	echo "@conky -p5" >> ~/.config/lxsession/LXDE/autostart
fi

sudo -u telematica git clone https://augusto_ciuffoletti@bitbucket.org/augusto_ciuffoletti/labreti5.git Scrivania/labreti
#rm .bash_history
# Ora l'utente deve:
# git config --global user.name "Your Name Comes Here"
# git config --global user.email you@yourdomain.example.com
# rhc setup
echo "Finito: tutto bene! Ricorda di modificare la pagina iniziale del browser midori"


