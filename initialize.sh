#!/bin/bash
### Variables ###
EPELLOCATION=https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
MYTARGET="$(systemctl get-default)"

### Main ###
#Bring eth0 online and autoconnect
nmcli con up eth0
nmcli con modify eth0 autoconnect yes

#Set Firewall
firewall-cmd --permanent --zone=internal --add-interface=eth0
firewall-cmd --permanent --zone=internal --change-interface=eth0
firewall-cmd --reload

echo "Enter Hostname of Sytem (or blank to skip)"
read MYHOSTNAME
if [[ $MYHOSTNAME != "" ]]; then
	echo "Hostnames change requested, setting to $MYHOSTNAME"
	#hostnamectl set-hostname $MYHOSTNAME
fi

#Update Data
chown root:wheel -R /data
chmod 775 -R /data

#Install EPEL
yum install $EPELLOCATION -y

#If GUI
if [[ $MYTARGET == "graphical.target" ]]; then
	echo "Using graphical target, installing XRDP"
	#Install XRDP
	# yum install xrdp -y
	# firewall-cmd --permanent --new-service=xrdp
	# firewall-cmd --permanent --service=xrdp --add-port=3389/tcp --set-description="Port for XRDP service"
	# firewall-cmd --permanent --zone=internal --add-service=xrdp
	# systemctl enable xrdp.service
	# firewall-cmd --reload
fi

#System Update
yum update -y

echo "Initialization Complete, press any key to reboot or c to skip"
read MYREBOOT
if [[ $MYREBOOT != "c" ]]; then
	reboot
fi

