#!/bin/bash

# ATTENZIONE: VA ESEGUITO SULLA MACCHINA VIRTUALE

# Provato su mini ubuntu con lubuntu minimal
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
cat > /etc/sudoers.d/studente <<EOF
studente ALL=(ALL:ALL) NOPASSWD:ALL
EOF
sudo chmod 0440 /etc/sudoers.d/studente

# login automatico
cat > /etc/lightdm/lightdm.conf <<EOF
[SeatDefaults]
autologin-user=studente
autologin-user-timeout=5
EOF

if ! apt -y update; then fail; fi
if ! apt -y upgrade; then fail; fi
if ! apt -y install lubuntu-default-session; then fail; fi
# dillo web browser
if ! sudo apt -y install dillo; then fail; fi
# Virtualbox guest utils (non sono sicuro che funzionino sempre...)
if ! apt-get -y install virtualbox-guest-utils; then fail; fi
# Lab tools
if ! apt-get -y install wireshark packeth traceroute curl arduino wget geany; then fail; fi
adduser studente wireshark
# git conky
if ! apt-get -y install git-core conky-all; then fail; fi
# python
if ! apt-get -y install python python-pip; then fail; fi
pip install virtualenv
pip install Flask
# heroku cli
snap install heroku --classic
# Attivazione conky
echo -n "Configurazone conky per l'utente ... "
cp .conkyrc /home/studente/.conkyrc
chown studente.studente /home/studente/.conkyrc
if ! grep conky /home/studente/.config/lxsession/LXDE/autostart > /dev/null
then
	echo "@conky -p5" >> /home/studente/.config/lxsession/LXDE/autostart
fi
echo "Fatto"

# CONFIGURAZIONE UTENTE
echo "Altre configurazioni utente (come studente)... "
sudo -iu studente bash << EOF
# Creazione ambiente virtuale Flask (io sviluppo gli esercizi in un ambiente virtuale...)
virtualenv Flask
history -c
EOF
echo "Fatto"
# Interessante, ma non più utilizzato
#sudo -u telematica git clone https://augusto_ciuffoletti@bitbucket.org/augusto_ciuffoletti/labreti5.git Scrivania/labreti
#rm .bash_history
# Ora l'utente deve:
# git config --global user.name "Your Name Comes Here"
# git config --global user.email you@yourdomain.example.com
# rhc setup
echo -e "=====\nFinito: tutto bene! Ricorda di modificare la pagina iniziale del browser"


