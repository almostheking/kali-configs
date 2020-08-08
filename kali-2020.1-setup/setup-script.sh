#!/bin/bash

#change password

# pull down and install custom bashrc
mv /home/kali/.bashrc /home/kali/.bashrc.bak
wget https://raw.githubusercontent.com/almostheking/kali-2020.1-setup/master/.bashrc -O /home/kali/.bashrc
chown kali:kali /home/kali/.bashrc

#modify secure path to include /opt
sed 's/\:\/bin\"/\:\/bin\:\/opt\"/g' /etc/sudoers

#create /opt and /home directories
mkdir -p /opt/{installs,binaries/{pspy,JuicyPotato,Churrasco,accesschk/old},scripts/{enum-win,enum-lin,reverse-shells},webshells/php}
mkdir -p /home/kali/{shares/goog,work,quick-grabs/{win-pkg,lin-pkg}}
chown -R kali:kali /home/kali/shares
chown -R kali:kali /home/kali/work
chown -R kali:kali /home/kali/quick-grabs
mkdir /mnt/usb

#install software via apt
apt-get update && sudo apt-get install -y evolution python3-virtualenv python-pip python3-pip ffmpeg obs-studio powershell-empire joomscan xclip rclone sipvicious tnscmd10g wkhtmltopdf curl enum4linux gobuster nbtscan nikto nmap onesixtyone oscanner smbclient smbmap smtp-user-enum sslscan whatweb gcc-9-base libc6-dev-i386 mingw-w64 seclists

#install github packages and configure accessibility
git clone https://github.com/rebootuser/LinEnum /opt/scripts/enum-lin/.

git clone https://github.com/Tib3rius/AutoRecon /opt/installs/AutoRecon
ln -s /opt/installs/AutoRecon/src/autorecon/autorecon.py /opt/autorecon
pip3 install -r /opt/installs/AutoRecon/requirements.txt

git clone https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite /opt/privilege-escalation-awesome-scripts-suite/
mv /opt/privilege-escalation-awesome-scripts-suite/winPEAS /opt/binaries/
mv /opt/privilege-escalation-awesome-scripts-suite/linPEAS /opt/scripts/
rm -rf /opt/privilege-escalation-awesome-scripts-suite

git clone https://github.com/sleventyeleven/linuxprivchecker /opt/scripts/linuxprivchecker

git clone https://github.com/mzet-/linux-exploit-suggester /opt/installs/linux-exploit-suggester
ln -s /opt/installs/linux-exploit-suggester/linux-exploit-suggester.sh /opt/lin-exploit-sugg

git clone https://github.com/jondonas/linux-exploit-suggester-2 /opt/installs/linux-exploit-suggester-2
ln -s /opt/installs/linux-exploit-suggester-2/linux-exploit-suggester-2.pl /opt/lin-exploit-sugg2

wget https://github.com/DominicBreuker/pspy/releases/download/v1.2.0/pspy32 -O /opt/binaries/pspy/pspy32
wget https://github.com/DominicBreuker/pspy/releases/download/v1.2.0/pspy64 -O /opt/binaries/pspy/pspy64
wget https://github.com/DominicBreuker/pspy/releases/download/v1.2.0/pspy32s -O /opt/binaries/pspy/pspy32s
wget https://github.com/DominicBreuker/pspy/releases/download/v1.2.0/pspy64s -O /opt/binaries/pspy/pspy64s

git clone https://github.com/pentestmonkey/unix-privesc-check /opt/scripts/unix-privesc-check

git clone https://github.com/Anon-Exploiter/SUID3NUM /opt/scripts/SUID3NUM

git clone https://github.com/diego-treitos/linux-smart-enumeration /opt/scripts/linux-smart-enumeration

wget https://web.archive.org/web/20080530012252/http://live.sysinternals.com/accesschk.exe -O /opt/binaries/AccessChk/accesschk/old/accesschk.exe
wget https://download.sysinternals.com/files/AccessChk.zip -O /opt/binaries/accesschk/AccessChk.zip
unzip /opt/binaries/accesschk/AccessChk.zip -d /opt/binaries/accesschk/

git clone https://github.com/M4ximuss/Powerless /opt/scripts/Powerless

git clone https://github.com/PowerShellMafia/PowerSploit /opt/scripts/PowerSploit

git clone https://github.com/AonCyberLabs/Windows-Exploit-Suggester /opt/installs/Windows-Exploit-Suggester
ln -s /opt/installs/Windows-Exploit-Suggester/windows-exploit-suggester.py /opt/win-exploit-sugg

git clone https://github.com/pentestmonkey/windows-privesc-check /opt/binaries/windows-privesc-check

git clone https://github.com/Tib3rius/windowsprivchecker /opt/scripts/windowsprivchecker

git clone https://github.com/wireghoul/dotdotpwn /opt/installs/dotdotpwn
ln -s /opt/installs/dotdotpwn/dotdotpwn.pl /opt/dotdotpwn

git clone https://github.com/mthbernardes/rsg /opt/installs/rsg
ln -s /opt/installs/rsg/rsg /opt/rsg

git clone https://github.com/WhiteWinterWolf/wwwolf-php-webshell /opt/webshells/php/wwwolf-php-webshell

mv JuicyPotato.exe /opt/binaries/JuicyPotato/JuicyPotato.exe
mv JuicyPotatox86.exe /opt/binaries/JuicyPotato/JuicyPotatox86.exe
mv churrasco.exe /opt/binaries/Churrasco/churrasco.exe

#tmux setup
git clone https://github.com/almostheking/.tmux.git /home/kali/.tmux
ln -s -f /home/kali/.tmux/.tmux.conf /home/kali/.tmux.conf
cp /home/kali/.tmux/.tmux.conf.local /home/kali/.
git clone https://github.com/tmux-plugins/tpm /home/kali/.tmux/plugins/tpm
chown -R kali:kali /home/kali/.tmux/
chown kali:kali /home/kali/.tmux.conf.local
/home/kali/.tmux/plugins/tpm/bin/install_plugins.sh

#mod smb.conf to support SMBv1 and viewing all files
sed -i.bak '/\[global\]/a\\n   client min protocol=NT1\n   hide dot files=no\n   hide special files=no\n   hide unreadable=no\n   hide unwriteable files=no' /etc/samba/smb.conf

#setup rclone
#rclone config
#create systemd service to auto mount goog - https://www.jamescoyle.net/how-to/3116-rclone-systemd-startup-mount-script
cat <<EOF > /etc/systemd/system/rclone.service
# /etc/systemd/system/rclone.service
[Unit]
Description=Google Drive (rclone)
AssertPathIsDirectory=/home/kali/shares/goog
After=plexdrive.service

[Service]
Type=simple
ExecStart=/usr/bin/rclone mount \\
        --config=/home/kali/.config/rclone/rclone.conf \\
        --allow-other \\
        --cache-tmp-upload-path=/tmp/rclone/upload \\
        --cache-chunk-path=/tmp/rclone/chunks \\
        --cache-workers=8 \\
        --cache-writes \\
        --cache-dir=/tmp/rclone/vfs \\
        --cache-db-path=/tmp/rclone/db \\
        --no-modtime \\
        --drive-use-trash \\
        --stats=0 \\
        --checkers=16 \\
        --bwlimit=40M \\
        --dir-cache-time=60m \\
        --cache-info-age=60m goog:/ /home/kali/shares/goog
ExecStop=/bin/fusermount -u /home/kali/shares/goog
Restart=always
RestartSec=10

[Install]
WantedBy=default.target
EOF
systemctl enable rclone
ln -s /home/kali/shares/goog/htb /home/kali/htb
ln -s /home/kali/shares/goog/vulnhub /home/kali/vulnhub

printf "\nREBOOT TO START THE RCLONE SERVICE"
printf "\nCHANGE YOUR PASSWORD"
printf "\nRUN rclone config as kali - name the drive "goog" to jive with this script.\n"
printf "\nINSTALL DROPBOX"
