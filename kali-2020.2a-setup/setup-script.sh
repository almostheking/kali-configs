#!/bin/bash
# This script was generated as I configured and personalized my VMWare image of Kali 2020.2a.
# Therefore, it isn't gauranteed to work on any other version Kali Linux.


# function to determine if wget is legit
function validate_url () {
	if [[ `wget -S --spider $1  2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then 
		echo "true"
	fi
}

if [[ "$EUID" =ne 0  ]]; then
	echo "Run as root"
	exit
fi

apt update

# Install and configure Syncthing as a user service in systemd
if [[ -f /etc/systemd/system/syncthing.service ]]; then
	
	echo "Syncthing is already installed."
	
	if [[ `systemctl is-active --quiet syncthing` -ne 0 ]]; then
		echo "Syncthing is not running. Look into that?"
	fi

else
	
	apt install syncthing

	if `validate_url "https://raw.githubusercontent.com/syncthing/syncthing/main/etc/linux-systemd/user/syncthing.service" >/dev/null`; then
		wget https://raw.githubusercontent.com/syncthing/syncthing/main/etc/linux-systemd/user/syncthing.service -O syncthing.service
	else
		echo "SYNCTHING SERVICE DOWNLOAD FAILED!"
	fi

	chmod 644 syncthing.service && mv syncthing.service /etc/systemd/system/.

	systemctl enable syncthing@kali.service && systemctl start syncthing@kali.service
fi

