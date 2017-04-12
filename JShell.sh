#!/bin/bash

#define fn_main_loop function:
function fn_main_loop() {

	declare -a cmd_parts
	exit=0
	
	while [ $exit != 1 ]; do
		
		#read & parse user input from command prompt:
		read -p "JShell>> " cmd
		read -a cmd_parts<<<$cmd
		
		#ensure  the command is not empty:
		if ! [ -z "${cmd}" ]; then
			#call function to execute the command entered:
			fn_execute "${cmd_parts[@]}"
		fi
	done
}

#define fn_execute function:
function fn_execute() {

	#retrieve the array argument:
	full_command=("$@")
	comm="${full_command[0]}"
	
	if [ $num_args -lt 2 ]; then
		
		case $comm in
			ifc | ifconfig)
				fn_ifconfig
				;;
			pw | pwd)
				fn_pwd
				;;
			dt)
				fn_dt
				;;
			ud)
				fn_ud
				;;
			exit | logout)
				exit=1
				;;
			help)
				fn_help
				;;
			clear | clean)
				clear
				;;
			list | ls)
				fn_ls
				;;
			*)
				echo "*Command not recognised, please try again*"
				echo 'Type "help" for a list of available commands'
				;;
		esac
	else
		
		case $comm in
			ifc | ifconfig)
				fn_ifconfig ${full_command[1]}
				;;
			pw | pwd)
				fn_pwd
				;;
			dt)
				fn_dt
				;;
			ud)
				fn_ud
				;;
			exit | logout)
				exit=1
				;;
			help)
				fn_help
				;;
			clear | clean)
				clear
				;;
			list | ls)
				fn_ls ${full_command[1]}
				;;
			*)
				echo "*Command not recognised, please try again*"
				echo 'Type "help" for a list of available commands'
				;;
		esac 
	fi
	
}

#define fn_ifconfig function:
function fn_ifconfig() {

	if [ -z ${1} ]; then
		echo "$(ifconfig)"
	else
		echo "$(ifconfig $1)"
	fi
}

#define fn_pwd function:
function fn_pwd() {

	echo "$(pwd)"
}

#define fn_dt function:
function fn_dt() {

	printf "%(%Y/%m/%d %H:%M:%S)T \n"
}

#define fn_ud function:
function fn_ud() {

	#extract the home directory's iNode into a variable:
	home=( $(ls -id $HOME) )
	
	#extract the group name into a variable:
	group=$(id -gn $USER)
	
	echo "$UID, ${GROUPS[0]}, $USER, $group, $home"
}

#define fn_help function:
function fn_help() {

	clear
	echo "----------------------------------------------------------------"
	echo "Available commands:"
	echo "pwd/pw"
	echo "ifconfig/ifc        - Display network settings for the default interface"
	echo "						- Accepts a single (optional) argument which specifies a"
	echo "							particular interface to display"
	echo "ls					- Lists the contents of the current directory"
	echo "		    			- Accepts a single (optional) argument, comprised of a"
	echo " 							combination of any arguments which are accepted by"
	echo "							the BASH ls command (e.g. -la)"
	echo "dt					- Print the date & time"
	echo "ud					- Print user details in the following format:"
	echo "		  - userId, groupId, username, groupname, iNode of home directory"
	echo "clear/clean		- Clear the screen"
	echo "exit/logout		- Exit the shell"
	echo "----------------------------------------------------------------"
	echo ""
}

#define fn_ls function:
function fn_ls() {

	echo "$(ls $1)"
}

#clear the screen & supply basic info to the user:
clear
echo '--type ""help" for a description of available commands--'
echo '			--type "exit" / "logout" to close the shell--'
echo ""

#call main loop function:
fn_main_loop

exit 1