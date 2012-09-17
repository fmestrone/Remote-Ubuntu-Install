#!/bin/bash


. /_functions.sh


# set environment variables again because we are in a chroot environment

message "Loading environment variables from your configuration options"
. /configuration.sh
proceed


message "Reconfiguring GRUB2"
dpkg-reconfigure grub-pc
die_on_error
proceed


message "Preparing for language and locale set-up"
echo LANG=\"en_US.utf8\" >> /etc/environment
die_on_error
echo LANGUAGE=\"en_US.utf8:en\" >> /etc/environment
die_on_error
apt-get -y install language-pack-en
die_on_error
proceed


message "Reconfiguring time zone and locale"
dpkg-reconfigure tzdata
die_on_error
dpkg-reconfigure locales
die_on_error
proceed


message "Updating the list of sources on your system"
apt-get -y update
die_on_error
proceed


message "Installing the ubuntu-standard package"
apt-get -y install ubuntu-standard
die_on_error
proceed


message "Installing the build-essential package"
apt-get -y install build-essential
die_on_error
proceed


message "Now select the preset installation you would like to make"
tasksel
die_on_error
proceed


message "Checking for new versions of any installed packages"
apt-get -u -y upgrade
die_on_error
proceed


message "Preparing your iptables firewall and setting it to load at boot"
(
cat <<"iptables"
*filter
:INPUT DROP [27:2064]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [2007:270846]
:SSH_CHECK - [0:0]
-A INPUT -p tcp -m tcp --dport 80 -m state --state NEW -j ACCEPT 
-A INPUT -p tcp -m tcp --dport 22 -m state --state NEW -j SSH_CHECK 
-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT 
-A SSH_CHECK -m recent --set --name SSH --rsource 
-A SSH_CHECK -m recent --update --seconds 60 --hitcount 4 --name SSH --rsource -j DROP 
-A SSH_CHECK -j ACCEPT 
COMMIT
iptables
) > /etc/iptables

die_on_error
echo "pre-up iptables-restore < /etc/iptables" >> /etc/network/interfaces
die_on_error
proceed


message "Allowing SSH access to $USER_NAME only and denying root access"
echo "DenyUsers root" >> /etc/ssh/sshd_config
die_on_error
echo "AllowUsers $USER_NAME" >> /etc/ssh/sshd_config
die_on_error
proceed


message "Defining a few convenient alias in /etc/profile"
echo "alias ll='ls -lFh --color=auto'" >> /etc/profile
die_on_error
echo "alias la='ls -lAFh --color=auto'" >> /etc/profile
die_on_error
proceed


message "Cleaning up temporary files"
rm -f /*.cfg
die_on_error
rm -f /*.sh
die_on_error
proceed

