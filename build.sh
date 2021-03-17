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
sudo apt-get install -y qt4-qmake libqt4-dev libminiupnpc-dev libdb++-dev libdb-dev libcrypto++-dev libqrencode-dev libboost-all-dev build-essential libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libdb++-dev ufw git software-properties-common
sudo apt-get install -y openssl1.0=1.0.2n-1ubuntu5.6 libssl1.0.0=1.0.2n-1ubuntu5.6 libssl1.0-dev=1.0.2n-1ubuntu5.6

sudo add-apt-repository -y ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install -y libdb4.8-dev libdb4.8++-dev

# By default, assume running within repo
repo=$(pwd)
file=$repo/src/signatumd
if [ ! -e "$file" ]; then
	# Now assume running outside and repo has been downloaded and named signatum
	if [ ! -e "$repo/build.sh" ] || [ ! -e "$repo/signatum-qt.pro" ] || [ ! -d "$repo/src" ] ; then
		sudo cp build.sh ../build.sh
		cd ../
		rm -rf $repo
		# if not, download the repo and name it signatum
		git clone https://github.com/username1565/signatum-source $repo
		sudo cp build.sh $repo/build.sh
	fi
fi
cd $repo/src/
make -j$NPROC -f makefile.unix

sudo cp $repo/src/signatumd /usr/bin/signatumd

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

