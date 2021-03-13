#!/bin/bash
update(){
	sudo apt-get update -y && apt-get upgrade
	}
http(){
	if ! grep -q "^deb .*$the_ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    		sudo add-apt-repository ppa:ondrej/apache2 -y
		update
	fi
	apt-get install apache2 -y
	ufw allow 'Apache Full' 
	systemctl start apache2.service
}

ftp(){
	update
	sudo cp /etc/vsftpd.conf /etc/conf_default -y
	touch /etc/vsftpd.conf
	apt-get install vsftpd -y
	systemctl start vsftpd
	systemctl enable vsftpd
	useradd -m testuser
	password testuser
	mkdir /home/testuser
	ufw allow 20/tcp
	ufw allow 21/tcp
	sed -i '/write_enable/ s/NO/YES' /etc/vsftpd.conf
	systemctl restart vsftpd
	echo "Installation Done"
}
ssh(){	update
	apt-get install openssh-server
	systemctl enable ssh
	systemctl start ssh
	ufw allow ssh
}
dhcp(){ update
	apt-get install isc-dhcp-server -y


}
while  true
do
	echo -e "\e[33m#####################################################\e[0m"
	echo -e "\e[33m#\e[0m            \e[38;5;41mWelcome to Installer Script\e[0m            \e[33m#"
	echo -e "\e[33m#####################################################\e[0m"
	echo " "
	echo -e  "\e[38;5;32m#Author: Jitul#\e[0m"
	echo " "
	echo " "
	echo -e "\e[31mPlease select your option-\e[0m"
	echo " "
	echo -e "\e[34m1) Install HTTP\e[0m"
	echo -e "\e[32m2) Install FTP\e[0m"
	echo -e "\e[36m3) Install SSH\e[0m"
	echo -e "\e[95m4) Install DHCP\e[0m"
	echo -e "\e[96m5) Exit the installer script\e[0m"
	echo " "
	read option

	case "$option" in
		1)echo -e "\e[31mHTTP installation selected.\nPlease wait, processing your installation...\e[0m"
		http

		;;
		2)echo -e "\e[31mFTP installation selected.\nPlease wait, processing your installation...\e[0m"
                ftp
                ;;
		3)echo -e "\e[31mSSH installation selected.\nPlease wait, processing your installation...\e[0m"
                ssh
                ;;
		4)echo -e "\e[31mDHCP installation selected.\nPlease wait, processing your installation...\e[0m"
                dhcp
                ;;
		5)echo -e "\e[31mExit option selected.\nExiting, Please wait...\e[0m"
                exit 0
                ;;
		*)
                echo -e "\e[31mInvalid selection, please try again.\e[0m"
                
                ;;
	esac
done
