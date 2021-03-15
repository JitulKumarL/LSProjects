#!/bin/bash
update(){
	sudo apt-get update -y && apt-get upgrade -y
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
	apt install vsftpd
	service vsftpd status
	ufw allow OpenSSH
	ufw allow 20/tcp
	ufw allow 21/tcp
	ufw allow 40000:50000/tcp
	ufw allow 990/tcp
	ufw enable
	ufw status
	
	echo "Enter Username for FTP:"
	read UNAME
	sudo adduser $UNAME
	sed -i '$a DenyUsers ftpuser' /etc/ssh/sshd_config
	service sshd restart
	usermod -d /var/www ftpuser
	chown ftpuser:ftpuser /var/www/html
	mv /etc/vsftpd.conf /etc/vsftpd.conf.bak

	echo "listen=NO\n
	listen_ipv6=YES\n
	anonymous_enable=NO\n
	local_enable=YES\n
	write_enable=YES\n
	local_umask=022\n
	dirmessage_enable=YES\n
	use_localtime=YES\n
	xferlog_enable=YES\n
	connect_from_port_20=YES\n
	chroot_local_user=YES\n
	secure_chroot_dir=/var/run/vsftpd/empty\n
	pam_service_name=vsftpd\n
	force_dot_files=YES\n
	pasv_min_port=40000\n
	pasv_max_port=50000\n"> /etc/vsftpd.conf

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
	apt-get install net-tools
	apt-get install isc-dhcp-server -y
	ifconfig
	echo "Enter the interface for listening DHCP requests:"
        read INTERFACE
        sed -i -e 's/INTERFACESv4=""/INTERFACESv4="'"$INTERFACE"'"/' /etc/default/isc-dhcp-server


	echo "Enter Domain Name to be configured"
	read DOMAIN_NAME
	echo "Enter Name-Server1 IP Address:"
	read NS1
	echo "Enter Name-Server2 IP Address"
	read NS2
	sed -i '10s/.*/option domain-name "'"$DOMAIN_NAME"'";/' /etc/dhcp/dhcpd.conf
	sed -i '11s/.*/option domain-name-servers '$NS1','$NS2';/' /etc/dhcp/dhcpd.conf
	sed -i '24s/#authoritative/authoritative/' /etc/dhcp/dhcpd.conf
	echo "Enter subnet:"
	read SUBNET
	echo "Enter netmask:"
	read NETMASK
	sed -i '53s/.*/subnet '$SUBNET' netmask '$NETMASK' {/' /etc/dhcp/dhcpd.conf
	echo "Enter Range- Start IP:"
	read RANGE1
	echo "Enter Range- Last IP:"
	read RANGE2
	sed -i '54s/.*/  range '$RANGE1' '$RANGE2';/' /etc/dhcp/dhcpd.conf
	echo "Enter Internal Domain name server ip:"
	read NSI1
	sed -i '55s/.*/  option domain-name-servers '$NSI1';/' /etc/dhcp/dhcpd.conf
	echo "Enter internal DNS:"
	read IDN
	sed -i '56s/.*/  option domain-name "'"$IDN"'";/' /etc/dhcp/dhcpd.conf
	echo "Enter Subnet-mask:"
	read SNMASK
	sed -i '57s/.*/  option subnet-mask '$SNMASK';/' /etc/dhcp/dhcpd.conf
	echo "Router IP:"
	read IPR
	sed -i '58s/.*/  option routers '$IPR';/' /etc/dhcp/dhcpd.conf
	echo "Enter Broadcast address:"
	read BID
	sed -i '59s/.*/  option broadcast-address '$BID';/' /etc/dhcp/dhcpd.conf
	sed -i '60s/#  default-lease-time/  default-lease-time/' /etc/dhcp/dhcpd.conf
	echo "Enter max lease time:"
	read MXLEASE
	sed -i '61s/.*/  max-lease-time '$MXLEASE';/' /etc/dhcp/dhcpd.conf
	sed -i '62s/#}/}/' /etc/dhcp/dhcpd.conf

	systemctl start isc-dhcp-server
	systemctl enable isc-dhcp-server
	ufw allow in on $INTERFACE from any port 68 to any port 67 udp
	systemctl restart isc-dhcp-server
	systemctl status isc-dhcp-server

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
