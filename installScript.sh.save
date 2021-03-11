#!/bin/bash
http(){
	sudo apt-get install apache2
	sudo ufw allow 'Apache Full'
	sudo systemctl start apache2.service
}

ftp(){
	sudo apt-get install vsftpd
	systemctl start vsftpd
	systemctl enable vsftpd
	sudo ufw allow 20/tcp
	sudo ufw allow 21/tcp
	sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.orig
	sudo nano /etc/vsftpd.conf
	systemctl restart vsftpd
	echo "Installation Done"
}
ssh(){
	sudo apt-get install openssh-server
	sudo systemctl enable ssh
	sudo systemctl start ssh
	sudo ufw allow ssh
}
dhcp(){
	sudo apt-get install isc-dhcp-server
	
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
