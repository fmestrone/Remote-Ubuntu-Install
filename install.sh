#!/bin/bash


. ./inc/functions.sh


. ./conf/configuration.sh


# welcome message and prompt

clear

cat <<"welcome"

WELCOME!

This script will remotely install Ubuntu on your server.

You will need the 'ar' command installed on your system in
order to extract the Debian bootstrap files (if you don't
have it, install it with "sudo apt-get install binutils").

Make sure you edit 'conf/configuration.sh' and verify that
the SYS_PARTITION and SWP_PARTITION variables are pointing
to the correct partitions!

Also verify that all of the other settings are correct
for your system.
welcome

if [ `whoami` != "root" ]; then
	echo
	echo -e "ATTENTION! You must be root to run this script.\nYou will need to enter the root password during Phase 1."
	echo
fi

press_or_quit "Press any key to continue or q to exit now"


# call the first stage of the installation process

clear

echo "UBUNTU REMOTE INSTALL - ENTERING PHASE 1"

sudo ./inc/install1.sh
rv=$?

echo "UBUNTU REMOTE INSTALL - PHASE 1 HAS EXITED"
if [ $rv != 0 ]; then
	die_with_error
fi
proceed

cat <<"phase1"

PHASE 1 COMPLETE!

A very basic base system has been installed.

You are about to enter a chroot'ed environment within
the newly configured Ubuntu system.

The installation script will now run the second phase,
during which an appropriate kernel will be downloaded
and configured, together with OpenSSH and GRUB2.

After this you will be ready to reboot.
phase1

press_or_quit "Phase 1 is complete. Press any key to continue or q to exit now"

clear

echo "UBUNTU REMOTE INSTALL - ENTERING PHASE 2"


# put the shell into chroot environment

sudo /usr/sbin/chroot /mnt/ubuntu /usr/bin/env -i HOME=/root TERM=$TERM PS1='\u:\w\$ ' PATH=/bin:/usr/bin:/sbin:/usr/sbin /bin/bash --login ./inc/install2.sh
rv=$?

echo "UBUNTU REMOTE INSTALL - PHASE 2 HAS EXITED"
if [ $rv != 0 ]; then
	die_with_error
fi
proceed


cat <<"phase2"

PHASE 2 COMPLETE!

A basic base system has been installed.

You are about to reboot into the newly configured
Ubuntu system.

In order for the installation script to run the third
phase, remember to execute '/postinstall.sh' after
logging into the server if it doesn't start automatically.
phase2


press_or_quit "Phase 2 is complete. Press any key to reboot or q to exit now"

sudo shutdown -r now
