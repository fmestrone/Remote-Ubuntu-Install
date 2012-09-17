#!/bin/bash


. ./inc/functions.sh


# set environment variables

message "Loading environment variables from your configuration options"
. ./conf/configuration.sh
proceed

# By default, the partition variables are not set. Hopefully, this will capture the
# attention of the user and a drive will not be accidentally formatted.

message "Checking whether SYS_PARTITION has been set"
if [ "$SYS_PARTITION" = "" ]; then
	die_with_error
fi
proceed

message "Checking whether SWP_PARTITION has been set"
if [ "$SWP_PARTITION" = "" ]; then
	die_with_error
fi
proceed


# Format the system partition

message "Creating a new ext4 partition on /dev/$SYS_PARTITION"
/sbin/mke2fs -t ext4 -j -q /dev/$SYS_PARTITION
die_on_error
proceed


# Create the swap partition

message "Creating a new swap partition on /dev/$SWP_PARTITION"

swapoff -a
/sbin/mkswap /dev/$SWP_PARTITION
die_on_error

sync; sync; sync
/sbin/swapon /dev/$SWP_PARTITION
die_on_error

proceed


# Make a temporary directory and mount the recently formatted partition to the
# temporary directory. The OS will be physically installed on the partition. The
# directory is used as a mount point into the new system.

message "Creating $MOUNTDIR and mounting /dev/$SYS_PARTITION on it"

if [ ! -e $MOUNTDIR ]; then
	mkdir -p $MOUNTDIR
fi
die_on_error


mount -t ext4 /dev/$SYS_PARTITION $MOUNTDIR
die_on_error


# Copy all of the required script and text files to what will become the root of the
# new OS, so that they will be available after restart
cp *.sh $MOUNTDIR
die_on_error
cp *.cfg $MOUNTDIR
die_on_error
chmod a+x $MOUNTDIR/*.sh
die_on_error

proceed


# Add a few folders to the current path
export PATH=$PATH:$MOUNTDIR/usr/bin:$MOUNTDIR/usr/sbin:$MOUNTDIR/sbin:/usr/sbin:/usr/local/sbin:/sbin


# Creating work directory and cd-ing into it

message "Creating work directory $WORKDIR"
if [ -e $WORKDIR ]; then
	rm -Rf $WORKDIR
fi
mkdir -p $WORKDIR
die_on_error

message "Copy configuration files into $WORKDIR"
cp *.cfg $WORKDIR
die_on_error

message "Cd'ing into $WORKDIR"
cd $WORKDIR
die_on_error

proceed


# Download debootstrap, use the archive tool to extract files, and use tar to extract
# additional files.

message "Downloading $DEBOOT_STRAP_DEB from Ubuntu web archive. This might take a while"

wget -o wget.log http://archive.ubuntu.com/ubuntu/pool/main/d/debootstrap/$DEBOOT_STRAP_DEB # &> /dev/null
die_on_error
proceed

message "Extracting $DEBOOT_STRAP_DEB to your file system"

ar -xf $DEBOOT_STRAP_DEB
die_on_error
tar -zxf data.tar.gz -C /
die_on_error

proceed


# Use debootstrap to kick off the installation.  Change the variables in configuration.sh

message "Using debootstrap to set up your new system. This WILL take a while"

/usr/sbin/debootstrap --arch $ARCHITECTURE $UBUNTU_RELEASE $MOUNTDIR http://archive.ubuntu.com/ubuntu # &> /dev/null
die_on_error
proceed


# At this point the OS is considered installed

message "Base system was installed. Now setting up the network"

# Configuring /etc/network/interfaces

message "Creating $MOUNTDIR/etc/network/interfaces"
cat ./conf/interfaces.cfg > $MOUNTDIR/etc/network/interfaces
die_on_error
proceed


# Configuring /etc/fstab

message "Setting up $MOUNTDIR/etc/fstab"
(
cat <<FSTABTEXT
proc		/proc		proc	defaults			0 0
sysfs		/sys		sysfs	defaults			0 0
devpts		/dev/pts	devpts	defaults			0 0
/dev/$SYS_PARTITION	/		ext3	defaults,errors=remount-ro	0 1
/dev/$SWP_PARTITION	none		swap	sw				0 0
FSTABTEXT
) > $MOUNTDIR/etc/fstab
die_on_error
proceed


# Configuring /etc/hostname

message "Setting up $MOUNTDIR/etc/hostname"
echo $TARGET_HOSTNAME.$TARGET_DOMAIN > $MOUNTDIR/etc/hostname
die_on_error
proceed


# Configuring /etc/hosts

message "Setting up $MOUNTDIR/etc/hosts"
echo 127.0.0.1 localhost $TARGET_HOSTNAME $TARGET_HOSTNAME.$TARGET_DOMAIN $OTHER_HOSTNAMES > $MOUNTDIR/etc/hosts
die_on_error
proceed


# Mount a couple of additional directories needed for chroot

message "Mounting the target /proc, /dev and /dev/pts file systems"
cd /

mount -t proc none $MOUNTDIR/proc
die_on_error
mount -o bind /dev $MOUNTDIR/dev
die_on_error
mount -t devpts devpts $MOUNTDIR/dev/pts
die_on_error

proceed

