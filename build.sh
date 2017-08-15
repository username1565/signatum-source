#!/bin/bash

set -e

date

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

# By default, assume running within repo
repo=$(pwd)
file=$repo/src/signatumd
if [ ! -e "$file" ]; then
	# Now assume running outside and repo has been downloaded and named signatum
	if [ ! -e "$repo/signatum/build.sh" ]; then
		# if not, download the repo and name it signatum
		git clone https://github.com/signatumd/source signatum
	fi
	repo=$repo/signatum
	file=$repo/src/signatumd
	cd $repo/src/
fi
make -j$NPROC -f makefile.unix

cp $repo/src/signatumd /usr/bin/signatumd

################################################################
# Configure to auto start at boot                                      #
################################################################
file=$HOME/.signatum
if [ ! -e "$file" ]
then
        mkdir $HOME/.signatum
fi
printf '%s\n%s\n%s\n%s\n' 'daemon=1' 'server=1' 'rpcuser=u' 'rpcpassword=p' | tee $HOME/.signatum/signatum.conf
file=/etc/init.d/signatum
if [ ! -e "$file" ]
then
        printf '%s\n%s\n' '#!/bin/sh' 'sudo signatumd' | sudo tee /etc/init.d/signatum
        sudo chmod +x /etc/init.d/signatum
        sudo update-rc.d signatum defaults
fi

/usr/bin/signatumd
echo "Signatum has been setup successfully and is running..."

