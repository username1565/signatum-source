#!/bin/bash

echo "set -e"
set -e
echo ""

#       "Linux" on "Windows 10 Pro" with "Windows Subsystem for Linux" ("WSL"), "Ubuntu 18.04.5 LTS (Bionic Beaver)"
echo "show date"
date
echo ""

echo "display mode"
echo "mode: $1" #1, 2, 3 or undefined.
echo ""

repodir="${PWD}" #current directory with this repositary
# By default, assume running within repodir
echo "Current repodir = $repodir"
echo ""

# set signatumd file
file="$repodir/src/signatumd"
echo "signatumd pathway = $file"
echo ""

echo "Start check signatumd:"
echo ""
if [ ! -e "$file" ]; then
	#if signatumd not exists
	echo "Sitnatumd not exits..."
	echo ""

	echo "Start check folder of repositary:"
	echo ""
	# Now assume running outside and repo has been downloaded and named signatum-source
	if [ ! -e "$repodir/build.sh" ] || [ ! -e "$repodir/signatum-qt.pro" ] || [ ! -d "$repodir/src" ] ; then
		echo "build.sh or signatum-qt.pro not exist in $repodir"
		echo ""

		echo "Copy build.sh in the parent directory"
		sudo cp build.sh ../build.sh
		echo ""

		echo "leave $repodir"
		cd ../
		echo ""

		echo "remove signatum-source directory"
		sudo rm -rf signatum-source
		echo ""

		echo "Clone the repositary with signatum-source:"
		# if this files not exists, download the repo and name it signatum-source
		git clone https://github.com/username1565/signatum-source signatum-source
		# enter there
		echo ""

		echo "copy build.sh into $repodir/build.sh"
		sudo cp build.sh signatum-source/build.sh
		echo ""

		echo "Enter /signatum-source"
		cd signatum-source

		# and change repodir
		repodir="$repodir"
		echo ""
		echo "new repodir = $repodir"
		echo ""
	fi
	#show repodir
	echo "repodir: $repodir"
	echo ""
	# set signatumd file
	file="$repodir/src/signatumd"
	echo "signatumd in repodir = $file"
	echo ""
else
	echo "$repodir/src/signatumd was been found. Exit."
	exit
fi

# go to src-folder
#cd "$repodir/src/"
#echo "Go to $repodir/src/ -folder"
#echo ""

if ( [ -z "$1" ] ) || ( [ "$1" != "1" ] && [ "$1" != "2" ] && [ "$1" != "3" ] ); then
	#if unknown mode was been specified, show this usage:
	echo ""
	echo "		Usage:"
	echo "You can specify the mode:"
	echo "	sh build.sh Mode"
	echo "or"
	echo "	./build.sh ModeNumber"
	echo ", where Mode is 1, 2 or 3:"
	echo "	Mode 1:"
	echo "		Install default openssl with libssl-dev, as openssl-1.1.1,"
	echo "		and openssl1.0 with libssl1.0.0, and libssl1.0-dev as openssl-1.0.2n"
	echo "		and compile signatumd with this."
	echo "	Mode 2:"
	echo "		Download and install openssl-1.0.1g if need, and compile signatumd with this, if not exists."
	echo "	Mode 3:"
	echo "		Download and install openssl-1.0.2n if need, and compile signatumd with this, if not exists."
	echo "	Mode unknown:"
	echo "		Run default compilation."
	echo ""

	#continue compilation, in cycle, after this else-if construction...
elif [ "$1" = "1" ]; then
	echo "	Mode 1:"
	echo "		Install default openssl with libssl-dev, as openssl-1.1.1,"
	echo "		and openssl1.0 with libssl1.0.0, and libssl1.0-dev as openssl-1.0.2n"
	echo "		and compile signatumd with this."
	echo ""

	##	"more shorter" (just remove one "#", to get this code)
	##!/bin/bash
	##install openssl-1.1.1
	#sudo apt-get install openssl=1.1.1-1ubuntu2.1~18.04.8 libssl-dev=1.1.1-1ubuntu2.1~18.04.8	#openssl-1.1.1
	##install openssl-1.0.2n
	#sudo apt-get install openssl1.0=1.0.2n-1ubuntu5.6 libssl1.0.0=1.0.2n-1ubuntu5.6 libssl1.0-dev=1.0.2n-1ubuntu5.6 #openssl-1.0.2n
	#
	#which openssl
	##/usr/bin/openssl
	#openssl version -v
	##OpenSSL 1.1.1  11 Sep 2018	#or empty, must to be
	#/usr/bin/openssl version -v
	##OpenSSL 1.1.1  11 Sep 2018	#or empty, must to be
	#/usr/lib/ssl1.0/openssl version -v
	##OpenSSL 1.0.2n  7 Dec 2017	#must to be
	#
	##reboot here to free RAM, and prevent errors with allocate memory
	#
	#cd src
	#unset PKG_CONFIG_PATH CC CXX CFLAGS CXXFLAGS CPP CXCPP LDFLAGS #clear flags...
	#make -j$NPROC -f makefile.unix #and start compilation, and restart this, while signatumd not exists...

	#Now, the same, but with cycle.
	echo "start check default openssl"
	echo ""
	if [ ! -f "/usr/bin/openssl" ] ; then
		#if default openssl not installed, install openssl-1.1.1
		echo "/usr/bin/openssl not found, install this:"
		echo ""
		sudo apt-get install -y openssl=1.1.1-1ubuntu2.1~18.04.8 libssl-dev=1.1.1-1ubuntu2.1~18.04.8
		echo "/usr/bin/openssl was been installed"
		echo ""
	fi

	echo "start check openssl1.0"
	echo ""
	if [ ! -f "/usr/lib/ssl1.0/openssl" ] ; then
		#if openssl1.0 not installed, install openssl1.0, libssl1.0.0 and libssl1.0, and use 1.0.2n
		echo "/usr/lib/ssl1.0/openssl not found, install this as v1.0.2n"
		echo ""
		sudo apt-get install -y openssl1.0=1.0.2n-1ubuntu5.6 libssl1.0.0=1.0.2n-1ubuntu5.6 libssl1.0-dev=1.0.2n-1ubuntu5.6
		echo "openssl-1.0.2n was been installed"
		echo ""
	fi

	echo "Check default openssl:"
	which openssl
	#/usr/bin/openssl	#must to be
	echo ""

	echo "Check version of default openssl:"
	openssl version -v
	#OpenSSL 1.1.1  11 Sep 2018 #or another, must to be
	echo ""

	echo "Check version of existing default openssl, by pathway to openssl-file"
	"/usr/bin/openssl" version -v
	#OpenSSL 1.1.1  11 Sep 2018	#or another, must to be
	echo ""

	echo "Check installed openssl1.0 version"
	"/usr/lib/ssl1.0/openssl" version -v
	#OpenSSL 1.0.2n  7 Dec 2017	#must to be, after install
	echo ""

	#continue compilation, in cycle, after this else-if construction...
elif [ "$1" = "2" ] || [ "$1" = "3" ]; then

	if [ "$1" = "2" ]; then
		v="1.0.1g";
	else
		v="1.0.2n"
	fi

	echo "	Mode $1:"
	echo "		Download and install openssl-$v if need, and compile signatumd with this, if not exists."
	echo ""

	#		Set this variables
	#installation dir
	instdir="/usr/local/bin/openssl-$v"
	echo "instdir $instdir"
	echo ""

	unpackdir="$repodir/openssl-$v"
	echo "unpackdir $unpackdir"
	echo ""

	echo "check is exists directory openssl-$v-source"
	if [ ! -d "$repodir/openssl-$v-source" ] ; then
		echo "$repodir/openssl-$v-source not exists, create this"
		mkdir "openssl-$v-source"
		echo "Done."
	else
		echo "$repodir/openssl-$v-source exists".
	fi
	echo ""

	echo "change dir to $repodir/openssl-$v-source"
	cd "$repodir/openssl-$v-source"
	echo ""

	#		Install Openssl

	#set pathway for openssl-archive
	FILE="$repodir/openssl-$v-source/openssl-$v.tar.gz"
	echo "openssl-$v.tar.gz : $FILE"
	echo ""

	echo "check is $FILE exists or not:"
	if [ ! -f "$FILE" ]; then
		#If "openssl-$v.tar.gz" does not exists - download this
		echo "$FILE not exists, download this:"
		wget --no-check-certificate "http://www.openssl.org/source/openssl-$v.tar.gz"
		echo "Done."
	else
		echo "$FILE is already exists"
	fi
	echo ""

	#set pathway for asc-file
	FILE="$repodir/openssl-$v-source/openssl-$v.tar.gz.asc"
	echo "openssl-$v.tar.gz.asc : $FILE"
	echo ""

	echo "check is $FILE exists or not:"
	if [ ! -f "$FILE" ]; then
		#If "openssl-$v.tar.gz" does not exists - download this
		echo "$FILE not exists, download this:"
		wget --no-check-certificate "http://www.openssl.org/source/openssl-$v.tar.gz.asc"
		echo "Done."
	else
		echo "$FILE is already exists"
	fi
	echo ""

	#	Check sha1-hash, and check md5-hash for v1.0.1g, and sha256-hash for v1.0.2n

	#set pathway for file with sha1-hash
	FILE="$repodir/openssl-$v-source/openssl-$v.tar.gz.sha1"
	echo "openssl-$v.tar.gz.sha1 : $FILE"
	echo ""

	echo "check is $FILE exists or not:"
	if [ ! -f "$FILE" ]; then
		#If file does not exists - download this
		echo "$FILE not exists, download it"
		wget --no-check-certificate "http://www.openssl.org/source/openssl-$v.tar.gz.sha1"
	else
		echo "$FILE already exists"
	fi
	echo ""

	#compute sha1 checksum from tarball
	echo "Compute sha1 checksum from tarball:"
	sha1sum "$repodir/openssl-$v-source/openssl-$v.tar.gz"
	#show sha1 hash from .sha1-file, to compare this
	cat "$repodir/openssl-$v-source/openssl-$v.tar.gz.sha1"

	diff="sha1sum openssl-$v.tar.gz | cut -d ' ' -f 1 | diff openssl-$v.tar.gz.sha1 - && echo \"OK\" || echo \"ANOTHER\""
	output=$(eval "$diff")
	echo "sha1 hash of file openssl-$v.tar.gz is $output"

	echo ""

	if [ "$1" = "2" ]; then
		echo "for $v, using .md5 checksum:"
		#set pathway for file with md5-hash for v1.0.1g
		FILE="$repodir/openssl-$v-source/openssl-$v.tar.gz.md5"
		echo "openssl-$v.tar.gz.md5 : $FILE"
		echo ""

		echo "Check .md5-file:"
		if [ ! -f "$FILE" ]; then
			#If file does not exists - download this
			echo "md5-file not exists:"
			wget --no-check-certificate "http://www.openssl.org/source/openssl-$v.tar.gz.md5"
		else
			echo "md5-file already exists"
		fi
		echo ""

		#compute md5 checksum from tarball
		echo "Compute md5 checksum from tarball"
		md5sum "$repodir/openssl-$v-source/openssl-$v.tar.gz"
		cat "$repodir/openssl-$v-source/openssl-$v.tar.gz.md5"


		diff="md5sum openssl-$v.tar.gz | cut -d ' ' -f 1 | diff openssl-$v.tar.gz.md5 - && echo \"OK\" || echo \"ANOTHER\""
		output=$(eval "$diff")
		echo "md5 hash of file openssl-$v.tar.gz is $output"
	else
		echo "for $v use .sha256-file"
		#set pathway for file with sha256-hash for v1.0.2n
		FILE="$repodir/openssl-$v-source/openssl-$v.tar.gz.sha256"
		echo "openssl-$v.tar.gz.sha256 : $FILE"
		echo ""

		echo "Check $FILE:"
		if [ ! -f "$FILE" ]; then
			#If file does not exists - download this
			echo "$FILE not found, download it"
			wget --no-check-certificate "http://www.openssl.org/source/openssl-$v.tar.gz.sha256"
		else
			echo "$FILE already exists"
		fi
		echo ""

		#compute md5 checksum from tarball
		echo "compute sha256sum from tarball:"
		sha256sum "$repodir/openssl-$v-source/openssl-$v.tar.gz"
		#show md5 hash from .md5-file, to compare this
		cat "$repodir/openssl-$v-source/openssl-$v.tar.gz.sha256"

                diff="sha256sum openssl-$v.tar.gz | cut -d ' ' -f 1 | diff openssl-$v.tar.gz.sha256 - && echo \"OK\" || echo \"ANOTHER\""
                output=$(eval "$diff")
                echo "sha256 hash of file openssl-$v.tar.gz is $output"
	fi
	#	end check hashes...
	echo ""

	#set pathway to openssl-file
	FILE="$instdir/bin/openssl"
	echo "openssl-$v , here : $FILE"
	echo ""

	#if file not exists - unpack this, and install openssl
	echo "Check $FILE:"
	if [ ! -f "$FILE" ] ; then
		echo "$FILE not found. Unpack tar.gz and install this:"
		echo ""

		echo "Check is $unpackdir exists:"
		if [ ! -d "$unpackdir" ]; then
			echo "$unpackdir not found, create this:"
			mkdir "$unpackdir"
		else
			echo "$unpackdir already exists."
		fi
		echo ""

		echo "Unpack into $unpackdir:"
		tar -xvzf "$repodir/openssl-$v-source/openssl-$v.tar.gz" -C "$unpackdir/../"
		echo "Done."
		echo ""

		echo "Go to $unpackdir"
		cd "$unpackdir"
		echo ""

		echo "Configure to install $v into $instdir:"
		./config --prefix="$instdir" --openssldir="$instdir" -Wl,-rpath,"$instdir/lib" shared
		echo ""

		echo "Compile $v, using make:"
		make
		echo ""

		if [ "$1" = "3" ] ; then
			#for v1.0.2n, tests must to be passed
			echo "Run test for $v"
			make test
			echo "Done."
			echo ""

			echo "Start install openssl-$v into $instdir:"
			sudo make install
		else
			#make test
			#	for v1.0.1g, there is error in the end, skip this test...
			echo "skip make test for v1.0.1g, and run make install_sw"
			sudo make install_sw
		fi
		echo "Done."
	else
		echo "$FILE found".
	fi
	echo ""

	echo "Go back to $repodir"
	cd "../"
	echo ""


	echo "Check default openssl"
	#check default openssl path
	which openssl
	#	/usr/bin/openssl
	echo ""

	#echo "set this as default openssl"
	#set as default openssl:
	#sudo ln -sf "$instdir/bin/openssl" `which openssl`
	#	old: /usr/bin/openssl
	#echo ""

	#check new default openssl path, again
	echo "check new default openssl path, again"
	which openssl
	#	something or empty
	echo ""

	echo "check default openssl version"
	#check default openssl version
	openssl version -v
	#	something or empty
	echo ""

	echo "check installed openssl version"
	#check installed openssl version
	"$instdir/bin/openssl" version
	#must to be an installed version
	echo ""

	echo "Start compile signatumd with compiled and installed openssl-$v:"
	#		Start compile "signatumd" with compiled and installed "openssl"
	echo ""

	#continue compilation, in cycle, after this else-if construction...
else
	echo "Mode undefined (default mode):"
	echo "	Run default compilation:"
	#run default compilation...
	echo ""

	#################################################################
	# Update Ubuntu and install prerequisites for running Signatum   #
	#################################################################
	echo "update system"
	sudo apt-get update
	echo ""

	#################################################################
	# Build Signatum from source                                     #
	#################################################################
	NPROC=$(nproc)
	echo "nproc: $NPROC"
	echo ""

	#################################################################
	# Install all necessary packages for building Signatum           #
	#################################################################

	#install openssl-1.1.1, if not installed
	#if [ ! -f /usr/bin/openssl ] ; then
	#	sudo apt-get install openssl=1.1.1-1ubuntu2.1~18.04.8 libssl-dev=1.1.1-1ubuntu2.1~18.04.8
	#fi

	echo "check is openssl1.0 installed or not:"
	#install openssl-1.0.2n, if not installed
	if [ ! -f /usr/lib/ssl1.0/openssl ] ; then
		echo "openssl 1.0 not installed, install this:"
		sudo apt-get install -y openssl1.0=1.0.2n-1ubuntu5.6 libssl1.0.0=1.0.2n-1ubuntu5.6 libssl1.0-dev=1.0.2n-1ubuntu5.6
		echo "done"
	fi
	echo ""

	#which openssl
	#	#	/usr/bin/openssl
	#openssl version -v
	#	#	OpenSSL 1.1.1  11 Sep 2018
	#/usr/bin/openssl version -v
	#	#	OpenSSL 1.1.1  11 Sep 2018
	#/usr/lib/ssl1.0/openssl version -v
	#	#	OpenSSL 1.0.2n  7 Dec 2017

	echo "install all necessary packages:"
	sudo apt-get install -y qt4-qmake libqt4-dev libminiupnpc-dev libdb++-dev libdb-dev libcrypto++-dev libqrencode-dev libboost-all-dev build-essential libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libdb++-dev ufw git software-properties-common

	#sudo apt install software-properties-common
	#sudo apt install --reinstall software-properties-common
	sudo add-apt-repository -y ppa:bitcoin/bitcoin

	sudo apt-get update
	sudo apt-get install -y libdb4.8-dev libdb4.8++-dev
	echo "All necessary packages was been installed"
	echo ""

	#continue compilation, in cycle, after this else-if construction...
fi

echo "set signatumd file:"
#set pathway for src/signatumd
FILE="$repodir/src/signatumd"
echo "signatumd-file: $FILE"
echo ""

echo "Go to $repodir/src/ -folder"
cd "$repodir/src/"
echo ""

echo "Start compile signatumd, while this does not exists:"
#do this all, while signatumd is not exists:
while true
do
	echo "check $FILE"
	#if "signatumd" file does not exists - compile this
	if [ ! -f "$FILE" ]; then
		#if "src/signatumd" not found, then compile this
		echo "$FILE does not exists, start compile this:"
		echo ""

	        # "(!)"         Here, maybe, need to reboot, to prevent errors with allocate memory.
	        echo "Here, maybe, need to reboot, to prevent errors with allocate memory."
	        echo ""

	        echo "Press Ctrl+C to exit, and reboot then, or wait 10 sec, to continue..."
	        sleep 10
	        #continue compilation, in cycle, after this else-if construction...

		if [ ! -z "$1" ] ; then
			#Unset all flags
			echo "Unset all flags for not default mode (maybe need to modify this)"
			echo "unset PKG_CONFIG_PATH CC CXX CFLAGS CXXFLAGS CPP CXCPP LDFLAGS"
			unset PKG_CONFIG_PATH CC CXX CFLAGS CXXFLAGS CPP CXCPP LDFLAGS
			echo ""
		fi

		if [ "$1" = "1" ] || [ -z "$1" ]; then
			#set nothing, and just build signatumd
			echo "Do not set flags for default mode and mode 1"
			echo ""
		elif [ "$1" = "2" ] || [ "$1" = "3" ]; then
			set "set flags for mode 2 and mode 3 (maybe need to modify this)"
			#Build "signatumd" with "openssl-1.0.1g" or with "openssl-1.0.2n"
			#Set this
			#	CHANGE TO OWN OPENSSL PATH
			export PKG_CONFIG_PATH="$instdir/lib/pkgconfig"
			export CFLAGS=" -I$instdir/include"
			export CXXFLAGS=" -I$instdir/include"
			export LDFLAGS=" -L$instdir/lib -lssl -L$instdir/lib -lcrypto"
			echo ""
		fi

		#start build src/signatumd, with or without exported flags:
		echo "start compilation"
		make -j$NPROC -f makefile.unix
		echo "Done"

		#if
		#	obj/blah-blah.o: file not recognized: File truncated
		#	collect2: error: ld returned 1 exit status
		#	makefile.unix:198: recipe for target 'signatumd' failed
		#	make: *** [signatumd] Error 1
		#then, solution:
		#	rm -rf obj/blahblah.o
		#	make -j$NPROC -f makefile.unix
	fi
	echo ""

	echo "Start check $FILE"
	if [ -f "$FILE" ]; then
		#if "signatumd" file exists - do not compile this, and show this
		echo "src/signatumd was been sucessfully compiled, and $FILE exists."
		break #exit from cycle
	elif [ ! -f "$FILE" ]; then
		#if file "src/signatumd" still not found, maybe there is some error. Show this, wait, and continue again...
		echo "src/signatumd not found! Try compile this again..."
		echo "If you see this:"
		echo "  obj/blahblah.o: file not recognized: File truncated"
		echo "  collect2: error: ld returned 1 exit status"
		echo "  makefile.unix:198: recipe for target 'signatumd' failed"
		echo "  make: *** [signatumd] Error 1"
		echo ""
		echo "Then, try:"
		echo "  rm -rf src/obj/blahblah.o"
		echo "and run this .sh-file then, again, to re-compile this .o-file, and build src/signatumd"
		echo ""
		echo "start recompilation, after 10 seconds... Or press Ctrl+C, to exit."

		sleep 10 #wait...
		#and continue cycle, again...
	fi
done
echo ""



#now, copy compiled signatumd, into "/usr/bin/signatumd"
echo "copy $FILE to /usr/bin/singatumd"
sudo cp "$repodir/src/signatumd" "/usr/bin/signatumd"
echo ""

################################################################
# Configure to auto start at boot                                      #
################################################################
echo "Configure to autostart at boot:"
file="$HOME/.signatum"
if [ ! -e "$file" ]
then
	mkdir "$HOME/.signatum"
fi
printf '%s\n%s\n%s\n%s\n' 'daemon=1' 'server=1' 'rpcuser=u' 'rpcpassword=p' | tee "$HOME/.signatum/signatum.conf"
file=/etc/init.d/signatum
if [ ! -e "$file" ]
then
	printf '%s\n%s\n' '#!/bin/sh' 'sudo signatumd' | sudo tee /etc/init.d/signatum
	sudo chmod +x /etc/init.d/signatum
	sudo update-rc.d signatum defaults
fi
echo "Done."
echo ""

echo "Run /usr/bin/singatumd"
/usr/bin/signatumd
echo "Done"
echo ""

echo "Signatum has been setup successfully and is running..."

