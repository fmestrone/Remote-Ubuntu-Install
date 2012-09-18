#!/bin/bash


. /inc/functions.sh


. /conf/configuration.sh


# welcome message and prompt

clear

cat <<"welcome"

WELCOME!

This script will set up your newly installed Ubuntu system.

It will download and install the essential packages you
need for your server, update all packages added so far and
allow you to configure locales and time zones.

Once this script terminates the system will be rebooted,

At that point, your Ubuntu installation should be ready for
you to use...
welcome

if [ `whoami` != "root" ]; then
	echo
	echo -e "ATTENTION! You must be root to run this script.\nYou will need to enter the root password during Phase 3."
	echo
fi

press_or_quit "Press any key to continue or q to exit now"


# call the first stage of the installation process

clear

echo "UBUNTU REMOTE INSTALL - ENTERING PHASE 3"

sudo /inc/install3.sh
rv=$?

echo "UBUNTU REMOTE INSTALL - PHASE 3 HAS EXITED"
if [ $rv != 0 ]; then
	die_with_error
fi
proceed

cat <<"phase3"

PHASE 3 COMPLETE!

Your Ubuntu system is ready.

Reboot one last time and you're done.
phase3

press_or_quit "Phase 3 is complete. Press any key to reboot or q to exit now"

sudo shutdown -r now

