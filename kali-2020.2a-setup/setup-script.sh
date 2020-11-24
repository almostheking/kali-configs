#!/bin/bash
# This script was generated as I configured and personalized my VMWare image of Kali 2020.2a.
# Therefore, it isn't gauranteed to work on any other version Kali Linux.


# function to determine if wget is legit.
function validate_url () {
	if [[ `wget -S --spider $1  2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then 
		echo "true"
	fi
}

if [[ "$EUID" -ne 0  ]]; then
	echo "Run as root"
	exit
fi

# Create a bunch of standard directories
mkdir -p /home/kali/{work,tools/{win/{scripts,binaries},lin/{scripts,binaries},webshells}}

chown -R kali:kali /home/kali/work/ /home/kali/tools/

# Preliminary update
apt update

# Install GitHub scripts and tools
# 1. LinEnum.sh
# 2. Reverse Shell Generator (rsg.py)
# 3. Linux Smart Enumeration (lse.sh)
# 4. Linux Exploit Suggester 2
# 5. nmapAutomator
# 6. Autorecon
# 7. Invoke-PowerShell.ps1
# 8. Windows Exploit Suggester
# 9. winPEAS.exe
# 10. pspy
# 11. SUID3NUM

git clone https://github.com/rebootuser/LinEnum.git /home/kali/tools/lin/scripts/LinEnum
git clone https://github.com/mthbernardes/rsg.git /home/kali/tools/lin/scripts/rsg
ln -s /home/kali/tools/lin/scripts/rsg/rsg /usr/local/bin
git clone https://github.com/diego-treitos/linux-smart-enumeration.git /home/kali/tools/lin/scripts/linux-smart-enumeration
git clone https://github.com/jondonas/linux-exploit-suggester-2.git /home/kali/tools/lin/scripts/linux-exploit-suggester-2
ln -s /home/kali/tools/lin/scripts/linux-exploit-suggester-2/linux-exploit-suggester-2.pl /usr/local/bin
git clone https://github.com/21y4d/nmapAutomator.git /home/kali/tools/lin/scripts/nmapAutomator
ln -s /home/kali/tools/lin/scripts/nmapAutomator/nmapAutomater.sh /usr/local/bin
git clone https://github.com/Tib3rius/AutoRecon.git /home/kali/tools/lin/scripts/AutoRecon
apt-get install -y python3-pip && pip3 install -r /home/kali/tools/lin/scripts/AutoRecon/requirements.txt
apt install -y seclists curl enum4linux gobuster nbtscan nikto nmap onesixtyone oscanner smbclient smbmap smtp-user-enum snmp sslscan sipvicious tnscmd10g whatweb wkhtmltopdf
ln -s /home/kali/tools/lin/scripts/AutoRecon/src/autorecon/autorecon.py /usr/local/bin
wget https://raw.githubusercontent.com/samratashok/nishang/master/Shells/Invoke-PowerShellTcp.ps1 -O /home/kali/tools/win/scripts/Invoke-PowerShellTcp.ps1
git clone https://github.com/AonCyberLabs/Windows-Exploit-Suggester.git /home/kali/tools/lin/scripts/Windows-Exploit-Suggester
ln -s /home/kali/tools/lin/scripts/Windows-Exploit-Suggester/windows-exploit-suggester.py /usr/local/bin
wget https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite/raw/master/winPEAS/winPEASexe/winPEAS/bin/x86/Release/winPEAS.exe -O /home/kali/tools/win/binaries/winPEAS_x86.exe
wget https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite/raw/master/winPEAS/winPEASexe/winPEAS/bin/x64/Release/winPEAS.exe -O /home/kali/tools/win/binaries/winPEAS_x64.exe
wget https://github.com/DominicBreuker/pspy/releases/download/v1.2.0/pspy32s -O /home/kali/tools/lin/binaries/pspy32s
wget https://github.com/DominicBreuker/pspy/releases/download/v1.2.0/pspy64s -O /home/kali/tools/lin/binaries/pspy64s
git clone https://github.com/Anon-Exploiter/SUID3NUM.git /home/kali/tools/lin/scripts/SUID3NUM

# Make sure kali owns the tools
chown -R kali:kali /home/kali/tools

# Install and configure Syncthing as a user service in systemd
#if [[ -f /etc/systemd/system/syncthing.service ]]; then
#	
#	echo "Syncthing is already installed."
#	
#	if [[ `systemctl is-active --quiet syncthing` -ne 0 ]]; then
#		echo "Syncthing is not running. Look into that?"
#	fi
#
#else
#	
#	apt install -y syncthing
#
#	if `validate_url "https://raw.githubusercontent.com/syncthing/syncthing/main/etc/linux-systemd/user/syncthing.service" >/dev/null`; then
#		wget https://raw.githubusercontent.com/syncthing/syncthing/main/etc/linux-systemd/user/syncthing.service -O syncthing.service
#	else
#		echo "SYNCTHING SERVICE DOWNLOAD FAILED!"
#	fi
#
#	chmod 644 syncthing.service && mv syncthing.service /etc/systemd/system/.
#
#	systemctl enable syncthing@kali.service && systemctl start syncthing@kali.service
#
#	echo "Now you should MANUALLY CONFIGURE SYNCTHING TO PORT OVER YOUR EMACS."
#fi

# Install and configure emacs
#which emacs >/dev/null 2>&1
#
#if [[ $? == 0 ]]; then
#	
#	echo "Emacs is already installed."
#	
#	if [[ -f /home/kali/.emacs ]]; then
#		echo "And it looks like you already have an .emacs file setup. Taking no further action."
#	else
#		echo "But it doesn't look like your .emacs is setup correctly. Check your config."
#	fi
#else
#	apt install -y emacs
#
#	mkdir /home/kali/emacs
#
#	echo "Creating symlink for your .emacs file. IT WILL NOT WORK UNTIL YOU MANUALLY CONFIGURE FILE SHARES IN SYNCTHING!"
#	ln -s /home/kali/emacs/.emacs /home/kali/.emacs
#fi

# Build out resource web server (apache that holds scripts and other useful files for quick exploit/post-exploit access during engagements)
mkdir -p /var/www/html/{wiglaf,leif}
cp /home/kali/tools/win/binaries/winPEAS_x86.exe /var/www/html/wiglaf/winPEAS_x86.exe
cp /home/kali/tools/win/binaries/winPEAS_x64.exe /var/www/html/wiglaf/winPEAS_x64.exe
cp /home/kali/tools/win/scripts/InvokePowerShellTcp.ps1 /var/www/html/wiglaf/InvokePowerShellTcp.ps1
cp /home/kali/tools/lin/scripts/linux-smart-enumeration/lse.sh /var/www/html/leif/lse.sh
cp /home/kali/tools/lin/scripts/LinEnum/LinEnum.sh /var/www/html/leif/LinEnum.sh
cp /home/kali/tools/lin/binaries/pspy32s /var/www/html/leif/pspy32s
cp /home/kali/tools/lin/binaries/pspy64s /var/www/html/leif/pspy64s
cp /home/kali/tools/lin/scripts/SUID3NUM/suid3num.py/var/www/html/leif/suid3num.py
systemctl start apache2
systemctl enable apache2

# Ensure legacy SMB works correctly
sed -i.bak '/\[global\]/a\\n   client min protocol=NT1\n   hide dot files=no\n   hide special files=no\n   hide unreadable=no\n   hide unwriteable files=no' /etc/samba/smb.conf

# Setup tmux
git clone https://github.com/almostheking/.tmux.git /home/kali/.tmux
ln -s -f /home/kali/.tmux/.tmux.conf /home/kali/.tmux.conf
cp /home/kali/.tmux/.tmux.conf.local /home/kali/.
git clone https://github.com/tmux-plugins/tpm /home/kali/.tmux/plugins/tpm
chown -R kali:kali /home/kali/.tmux/
chown kali:kali /home/kali/.tmux.conf.local
/home/kali/.tmux/plugins/tpm/bin/install_plugins.sh

# Parting tips (must be done manually)
echo -e "\n\t\t\tAlways remember...\n"
echo -e "Change that password..."
echo -e "\tChange that hostname (hosts and hostname and reboot)..."
echo -e "\t\tEat your veggies."
