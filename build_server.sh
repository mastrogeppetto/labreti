#!/bin/bash

# ATTENZIONE: VA ESEGUITO SULLA MACCHINA VIRTUALE

# Provato su mini ubuntu 14.04: va riprovato sulla 16.04, sostituendo
# enp0s8 con enp0s8. Caricamento pacchetti da completare.

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

# login automatico sull tty1 NON FUNZIONA, cambiato il 16.04
#tmp=$(tempfile)
#sed "s%^exec .*%exec /bin/login -f telematica < /dev/tty1 > /dev/tty1 2>\&1%" /etc/init/tty1.conf > $tmp
#mv $tmp /etc/init/tty1.conf

# motd con indirizzo IP e MAC
cat > /etc/update-motd.d/92-vminfo <<"EOF"
#!/bin/sh
IPaddr=`ip addr show dev enp0s8 | egrep "inet\b" | tr -s " " | cut -f3 -d " "`
MACaddr=`ip link | grep -A2 enp0s8 | tail -1 | tr -s " " | cut -f 3 -d " "`
echo " * IP address: $IPaddr"
echo " * MAC address: $MACaddr"
EOF
sudo chmod a+x /etc/update-motd.d/92-vminfo

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


