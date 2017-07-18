#!/bin/bash

set -e

date
ps axjf

#################################################################
# Update Ubuntu and install prerequisites for running Signatum   #
#################################################################
sudo apt-get update
#################################################################
# Build Signatum from source                                     #
#################################################################
NPROC=$(nproc)
echo "nproc: $NPROC"
#################################################################
# Install all necessary packages for building Signatum           #
#################################################################
sudo apt-get install -y qt4-qmake libqt4-dev libminiupnpc-dev libdb++-dev libdb-dev libcrypto++-dev libqrencode-dev libboost-all-dev build-essential libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libssl-dev libdb++-dev libssl-dev ufw git
sudo add-apt-repository -y ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install -y libdb4.8-dev libdb4.8++-dev

cd /usr/local
file=/usr/local/signatumX
if [ ! -e "$file" ]
then
        sudo git clone https://github.com/signatumproject/signatumX.git
fi

cd /usr/local/signatumX/src
file=/usr/local/signatumX/src/signatumd
if [ ! -e "$file" ]
then
        sudo make -j$NPROC -f makefile.unix
fi

sudo cp /usr/local/signatumX/src/signatumd /usr/bin/signatumd

################################################################
# Configure to auto start at boot                                      #
################################################################
file=$HOME/.signatum
if [ ! -e "$file" ]
then
        sudo mkdir $HOME/.signatum
fi
printf '%s\n%s\n%s\n%s\n' 'daemon=1' 'server=1' 'rpcuser=u' 'rpcpassword=p' | sudo tee $HOME/.signatum/signatum.conf
file=/etc/init.d/signatum
if [ ! -e "$file" ]
then
        printf '%s\n%s\n' '#!/bin/sh' 'sudo signatumd' | sudo tee /etc/init.d/signatum
        sudo chmod +x /etc/init.d/signatum
        sudo update-rc.d signatum defaults
fi

/usr/bin/signatumd
echo "Signatum has been setup successfully and is running..."
exit 0

