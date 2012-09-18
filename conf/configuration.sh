#!/bin/bash

#####################################################################
# you MUST configure the values in the following two variables to
# point to the desired partitions on your system and then uncomment
# them for the script to pick up the values
#####################################################################

# the partition (relative to /dev) where the final system will be installed
export SYS_PARTITION="sdb1"

# the partition (relative to /dev) where the swap partition will be created
export SWP_PARTITION="sda5"

#####################################################################
# Variables that configure your remote installation of an Ubuntu
# server. Currently configured for Ubuntu Precise Pangolin 12.04
#####################################################################

# the kernel that will be installed (check /proc/version to find out what is running on your system)
# note that in 12.04 the server kernel has been merged into the generic one
export LINUX_KERNEL="linux-image-3.2.0-23-generic"

# location of files needed by grub, architecture specific (for 32bit use "i386-pc") [not used at the moment]
#export GRUB_DIR="x86_64-pc"
# drive where the MBR should be installed by GRUB
#export GRUB_MBR="hd0"
# partition corresponding to the SYS_PARTITION in GRUB format
#export GRUB_DEV="hd1,0"

# user account that will be created during stage two of the process.
export USER_NAME="fedmest"
export USER_HOME="/home/fedmest"

# check http://archive.ubuntu.com/ubuntu/pool/main/d/debootstrap for newer versions
export DEBOOT_STRAP_DEB="debootstrap_1.0.42_all.deb"

# architecture to install (for 32bit use "i386")
export ARCHITECTURE="amd64"

# Ubuntu release to install (list is at http://releases.ubuntu.com)
export UBUNTU_RELEASE="precise"

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
export WORKDIR="/home/fedmest/workdir"

# where to mount the new temporary on OS on your system
export MOUNTDIR="/mnt/ubuntu"

# if true, this will make the script stop and ask to press a key after each step
export ALWAYS_PRESS_KEY=true
