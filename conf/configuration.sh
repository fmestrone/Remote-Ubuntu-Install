#!/bin/bash

#####################################################################
# Basic Configuration
#
# you MUST configure the values in the following three variables to
# point to the desired partitions on your system and then uncomment
# them for the script to pick up the values
#####################################################################

# the partition (relative to /dev) where the final system will be installed
#export SYS_PARTITION="sda3"

# the partition (relative to /dev) where the swap partition will be created
#export SWP_PARTITION="sda2"

# user account that will be created during stage two of the process.
#export USER_NAME="federico"


#####################################################################
# Network Configuration
#
# you MUST configure the values in the following three variables to
# point to the desired partitions on your system and then uncomment
# them for the script to pick up the values
#####################################################################

# the host name of the target system
#export TARGET_HOSTNAME="server"

# the domain name of the target system
#export TARGET_DOMAIN="yourdomain.com"

# other names by which the machine is to be known in /etc/hosts
export OTHER_HOSTNAMES=


#####################################################################
# Variables that configure your remote installation of an Ubuntu
# server. Currently configured for Ubuntu Precise Pangolin 12.04
#####################################################################

# the kernel that will be installed (check /proc/version to find out what is running on your system)
# note that in 12.04 the server kernel has been merged into the generic one
export LINUX_KERNEL="linux-image-3.2.0-23-generic"

# the home folder for the username set up above
export USER_HOME="/home/$USER_NAME"

# check http://archive.ubuntu.com/ubuntu/pool/main/d/debootstrap for newer versions
export DEBOOT_STRAP_DEB="debootstrap_1.0.42_all.deb"

# architecture to install (for 32bit use "i386")
export ARCHITECTURE="amd64"

# Ubuntu release to install (list is at http://releases.ubuntu.com)
export UBUNTU_RELEASE="precise"

# [not used at the moment] location of files needed by grub, architecture specific (for 32bit use "i386-pc")
#export GRUB_DIR="x86_64-pc"
# [not used at the moment] drive where the MBR should be installed by GRUB
#export GRUB_MBR="hd0"
# [not used at the moment] partition corresponding to the SYS_PARTITION in GRUB format
#export GRUB_DEV="hd1,0"


#####################################################################
# advanced options
#####################################################################

# where to download and extract the bootstap system
export WORKDIR="/home/$USER_NAME/workdir"

# where to mount the new temporary on OS on your system
export MOUNTDIR="/mnt/ubuntu"

# if true, this will make the script stop and ask to press a key after each step
export ALWAYS_PRESS_KEY=false
