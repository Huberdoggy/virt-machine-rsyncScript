#!/bin/bash

#Script to organize completed labs and automate the process of moving the file/s to host

clear
figlet -c "Welcome To Kyle's Automated File Moving Program"

echo "Please Select:

A. Move Completed Labs To Host Windows Machine
B. List Current Lab Upload Files In Stu's Documents Folder
D. Remove Old Duplicate Zips from Root's Home Directory
Q. Quit
"
read -p "Enter selection [A, B, D or Q] > "

	case "$REPLY" in
		q|Q)	echo "Program terminated."
				exit
				;;
		b|B)	echo "Documents Folder Has: " 
				find /home/stu08/Documents -type f -name 'Lab_*' | nl
				;;
		a|A)	echo "Enter IP Address of the preffered Host and Rsync will attempt a transfer using auto supplied password credentials for your convenience: "
				read IP_ADDRESS
				port=22
				connection_timeout=5
				status=`nmap $IP_ADDRESS -Pn -p $port | egrep -io 'open|closed|filtered'`
				if [ $status == "open" ] && [ $IP_ADDRESS == "my static IP here" ]; then
					echo "Transferring completed Zips over secure connection to host machine at $IP_ADDRESS..."
					sshpass -f /root/secrets.txt rsync -a --ignore-existing /home/stu08/Documents/Lab_* huberdoggy@$IP_ADDRESS:/c/Users/huberdoggy/Documents/completed-labs
				elif [ $IP_ADDRESS != "my static IP here" ] && [ $status == "open" ]; then
					echo "SSH connection to $IP_ADDRESS over port $port IS possible, but Rsync might not be configured"
				elif [ $status == "filtered" ]; then
					echo "SSH connection to $IP_ADDRESS over port $port is possible but blocked"
				elif [ $status == "closed" ]; then
					echo "SSH connection to $IP_ADDRESS over port $port is NOT possible"
				else
					echo "Unable to get port $port status from $IP_ADDRESS"
				fi
				;;
		d|D)	echo "Finding and clearing duplicate files from Root's home dir..."
				find /root/ -maxdepth 1 -type f -name 'Lab_*' -exec rm -vi {} \;
				;;
		*)		echo "I don't recognize that option" >&2
				exit 1
				;;
	esac
