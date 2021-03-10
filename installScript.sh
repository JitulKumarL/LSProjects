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
	echo "#####################################"
	echo "#    Welcome to Installer Script    #"
	echo "#####################################"
	echo " "
	echo "Please select your option-"
	echo "1) install HTTP"
	echo "2) install FTP"
	echo "3) install SSH"
	echo "4) install DHCP"
	echo "5) Exit the installer script"
	read option
	
	case "$option" in
		1)echo "HTTP installation selected."
		echo "Please wait, processing your installation..."
		http
		
		;;
		2)echo "FTP installation selected."
                echo "Please wait, processing your installation..."
                ftp
                ;;
		3)echo "SSH installation selected."
                echo "Please wait, processing your installation..."
                ssh
                ;;
		4)echo "DHCP installation selected."
                echo "Please wait, processing your installation..."
                dhcp
                ;;
		5)echo "Exit option selected."
                echo "Exiting, Please wait..."
                exit 0
                ;;
		*)
                echo "Invalid selection, please try again."
                
                ;;
	esac
done
