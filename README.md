Remote Ubuntu Install
=====================

You got a dedicated server from the hosting provider of your choice.

You're ready to deploy your products onto your new dedicated server.

But the hosting provider does not offer the latest Ubuntu edition you would like to have...

Here's a little script that will allow you to install Ubuntu onto a dedicated server __remotely__.

Requirements
------------

What you need

- two bootable partitions
  * (1) one to boot into and build the new system from
  * (2) one for the new system
  * when the new system is ready, the script will change the boot drive from the former (1) to the latter (2)
- SSH access to your server
- root or sudo privileges
- the scripts from this project ;-)

