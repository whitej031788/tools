#!/bin/bash

LD_LIBRARY_PATH=/appl/crs/lib
DATAPATH=/appl/crs/data
TERMCAP=/appl/crs/etc/termcap
BIN=/appl/crs/bin

export LD_LIBRARY_PATH DATAPATH TERMCAP BIN

run_prog()
{
	$BIN/cbrebuild -f -i $1
}

get_unit()
{
	echo "               REPAIR COLLECTION UNIT"
	echo 
	echo
	echo "This is a tool to fix an indivual collection units chains and pointers"
	echo
	echo "This will fix issues regarding incorrect chain scan results and endless"
	echo "loops when scanning"
	echo
	echo "Please input the collection unit you want to repair, or enter 'q' to quit"
	read answer
	if [ $answer = "q" -o $answer = "Q" ]; then
		exit
	else
		echo "You entered $answer"
		echo "Is that correct? (y/n)"
		read sure
		if [ $sure = "y" -o $sure = "Y" ]; then
			run_prog $answer
		else
			get_unit
		fi
	fi
}

get_unit
