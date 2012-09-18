#!/bin/bash


. /inc/functions.sh


# set environment variables again because we are in a chroot environment

message "Loading environment variables from your configuration options"
. /conf/configuration.sh
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


message "Installing the tasksel package for the next step"
apt-get -y install tasksel
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
cat /conf/iptables.cfg > /etc/iptables
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


message "Defining a few convenient aliases in /etc/profile"
echo "alias ll='ls -lFh --color=auto'" >> /etc/profile
die_on_error
echo "alias la='ls -lAFh --color=auto'" >> /etc/profile
die_on_error
proceed


message "Cleaning up temporary files"
rm -Rf /inc
die_on_error
rm -Rf /conf
die_on_error
rm -f /postinstall.sh
die_on_error
proceed

