#!/bin/bash
#Inspired by Alexander Epstein';s "todo" https://github.com/alexanderepstein
set -e

	

# [ Variables ]
TODODIR=~/.todo
TODOARCHIVE=~/.todo/archive
LIST=~/.todo/list.txt


# [ Initializing Folders && Files ]
mkdir -vp $TODODIR
mkdir -vp $TODOARCHIVE
if [ ! -f $LIST ]; then touch $LIST; fi


# [ Functions ]
#----------------------------------------------------
Help()
{
echo '	
[ Todo ]
Description: A Simple program for taking notes.
Usage: todo [parameters] [notes]
	-l		:Print List
	-r #	:Remove Task with number # 
	-A    :Archive the current list with and Saves it to ~/.todo/archive
	-D    :Initialize a todo-list specifically for Today.
'
}
#----------------------------------------------------
function printlist(){
	COUNT=1
	while IFS= read -r line
	do
			echo "[$COUNT] $line"
			((COUNT+=1))
	done < $LIST
}


# =================== #
## [ Main Function ] ##
# =================== #
#	Print current list if no argument is given.
if (( $# < 1 )); then printlist && exit 0 || exit 1; fi
#	Print help
if [[ $1 == help ]]; then Help && exit 0 || exit 1; fi

#	No
NOTES=${*:1}
while getopts "ADlr:" opt; do
	case "$opt" in

		A) 
			if (($# < 3)); then echo 'Usage for Archiving: "todo -S filename"'; fi
			DATE=$(date "+%y%m%d__%A")
			cp $LIST "$TODOARCHIVE/$DATE{_$2}"
			exit 0
			;; 

		D) 			
			DATE=$(date "+%y%m%d__%A")
			DAILYLIST=~/.todo/Dailylist_$DATE
			touch "${TODO}/${DAILYLIST}" && echo "Created ${TODO}${DAILYLIST}"
			exit 0
			;;
		
		r)		
			# if (( $# < 2)); then echo "Usage: todo -r #LINETOREMOVE" && exit 1; fi
			export N=$1
			DELETE="${1##*r}"
			echo "$DELETE"
			sed -i "${DELETE}d" "$LIST"

			if (( $# > 1 )); then
				for row in $(echo ${@:2}); do
					sed -i "${row}d" "$LIST"
				done
			fi
			exit 0
			;;
		*)	
			Help
			exit 1
	esac
done

# Default if no parameter is given is to add whatever comes after "todo" in terminal
echo "$(date "+%H:%M") $NOTES" >> $LIST
