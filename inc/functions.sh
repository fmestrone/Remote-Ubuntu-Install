#!/bin/bash

function die_with_error() {
	echo "      ---> !KO!"
	echo
	sudo umount /dev/$SYS_PARTITION &> /dev/null
	sudo swapoff /dev/$SWP_PARTITION &> /dev/null
	exit 1
}

function die_on_error() {
	if [ $? != 0 ]; then
		die_with_error
	fi
}

function proceed() {
	echo "      ---> OK"
	echo
	read -s -n 1
}

function message() {
	echo -e " - $1..."
}

function press_or_quit() {
	echo
	echo -n "$1   "

	read -s -n 1

	echo
	echo

	if [ "$REPLY" == "q" ]; then
		message "Quitting"
		proceed
		exit 0;
	fi
}
