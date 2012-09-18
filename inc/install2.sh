#!/bin/bash


. ./inc/functions.sh


# set environment variables again because we are in a chroot environment

message "Loading environment variables from your configuration options"
. ./conf/configuration.sh
proceed


message "Setting password for root user"
passwd -l root
dpkg-reconfigure --default-priority passwd
die_on_error
proceed


message "Adding default user account for user name $USER_NAME"
adduser --home $USER_HOME $USER_NAME
die_on_error
proceed


message "Setting up /etc/sudoers"
(
cat <<SUDOERSTXT
# /etc/sudoers
#
# This file MUST be edited with the 'visudo' command as root.
#
# See the man page for details on how to write a sudoers file.
#

Defaults	env_reset

# Host alias specification

# User alias specification

# Cmnd alias specification

# User privilege specification
root	ALL=(ALL) ALL

# Uncomment to allow members of group sudo to not need a password
# (Note that later entries override this, so you might need to move
# it further down)
# %sudo ALL=NOPASSWD: ALL

# Members of the admin group may gain root privileges
$USER_NAME ALL=(ALL) ALL
SUDOERSTXT
) > /etc/sudoers
die_on_error
proceed


message "Setting up /etc/apt/sources.list"
(
cat <<SOURCESTXT
deb http://us.archive.ubuntu.com/ubuntu $UBUNTU_RELEASE main multiverse restricted universe
deb http://us.archive.ubuntu.com/ubuntu $UBUNTU_RELEASE-updates main multiverse restricted universe
deb http://us.archive.ubuntu.com/ubuntu $UBUNTU_RELEASE-security main multiverse restricted universe
deb http://us.archive.ubuntu.com/ubuntu $UBUNTU_RELEASE-backports main multiverse restricted universe
SOURCESTXT
) > /etc/apt/sources.list
die_on_error
proceed


# tzdata must be configured before running an update of the sources,
# otherwise gpg signature checking will fail.
message "Setting up time zone information for your sistem"
dpkg-reconfigure tzdata
die_on_error
proceed


message "Updating the list of sources on your system"
apt-get -y update
die_on_error
proceed


message "Installing $LINUX_KERNEL"
apt-get -y install $LINUX_KERNEL
die_on_error
proceed


message "Installing the OpenSSH server daemon"
apt-get -y install openssh-server
die_on_error
proceed


message "Installing the binutils, zip, unzip, and vim packages"
apt-get -y install binutils zip unzip vim
die_on_error
proceed


message "Installing GRUB2"
apt-get -y install grub-pc
die_on_error
proceed


message "Checking for new versions of any installed packages"
apt-get -u -y upgrade
die_on_error
proceed

# if you need to reconfigure Grub2 after this
# use blkid to find out UUIDs of drives, then
#  dpkg-reconfigure grub-pc
# then change /mnt/ubuntu/boot/grub/grub.cfg with the UUID you want
