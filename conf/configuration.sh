#!/bin/bash

#####################################################################
# Variables that configure the remote installation of my Ubuntu
# server in Germany. It is now configured for Ubuntu Jaunty 9.04
#####################################################################

#####################################################################
# uncomment the following 2 variables to point to the correct
# partitions
#####################################################################

# the system partition in /dev
export SYS_PARTITION="sda1"

# the swap partition in /dev
export SWP_PARTITION="sda3"

# the kernel that will be installed
export LINUX_KERNEL="linux-image-2.6.32-12-server"

# location of files needed by grub, architecture specific (for 32bit use "i386-pc")
export GRUB_DIR="x86_64-pc"
# drive where the MBR should be installed by GRUB
export GRUB_MBR="hd0"
# partition corresponding to the SYS_PARTITION in GRUB format
export GRUB_DEV="hd1,0"

# user account that will be created during stage two of the process.
export USER_NAME="fedmest"
export USER_HOME="/home/fedmest"

# check http://archive.ubuntu.com/ubuntu/pool/main/d/debootstrap for newer versions
export DEBOOT_STRAP_DEB="debootstrap_1.0.20_all.deb"

# architecture to install (for 32bit use "i386")
export ARCHITECTURE="amd64"

# Ubuntu release to install
export UBUNTU_RELEASE="lucid"

#####################################################################
# network configuration
#####################################################################

# the host name of the target system
export TARGET_HOSTNAME="ubuntu"

# the domain name of the target system
export TARGET_DOMAIN="fedmest.com"

# other names by which the machine is to be known in /etc/hosts
export OTHER_HOSTNAMES=

#####################################################################
# advanced options
#####################################################################

# where to download and extract the bootstap system
export WORKDIR="./workdir"

# where to mount the new temporary on OS on your system
export MOUNTDIR="/mnt/ubuntu"
