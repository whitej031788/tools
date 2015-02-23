#!/bin/bash

##Script to run the rmExtend tool against a list of extend_loc

LOGFILE="rmExtend.log"
CRSROOT=/appl/jwhite/16
BIN=$CRSROOT/bin
DATAPATH=$CRSROOT/data
LD_LIBRARY_PATH=$CRSROOT/lib

export CRSROOT BIN DATAPATH LD_LIBRARY_PATH

function pause()
{
	read -n 1 -p "$*"
}

function runprog()
{
	echo $FILE
        for loc in `cat $FILE`
        do
                if [ $DEBUG -eq 1 ]; then
                        echo "Removing record at extended loc $loc" >> $LOGFILE
                        ./rmExtend -s -d -l $loc
                else
                        echo "Removing record at extended loc $loc" >> $LOGFILE
                        ./rmExtend -s -l $loc
                fi
        done
	if [ $DEBUG -eq 0 ]; then
		valextend
	fi
}

function debug() 
{
	echo "     Do you want to run this in debug mode? (y/n)"
	read ans1
	if [ $ans1 = y -o $ans1 = Y ]; then
		DEBUG=1
	elif [ $ans1 = n -o $ans1 = N ]; then
		DEBUG=0
	else
		echo "     That is not a valid answer, exiting"
		exit 1
	fi
	runprog
}

function intro()
{
	echo 
	echo "     This is a script that will run the rmExtend tool against"
	echo "     a file containing a list of extended locations."
	echo
	pause '               Press any key to continue'
	echo
	echo "     This program assumes DATAPATH=/appl/crs/data, and BIN=/appl/crs/bin, CRSROOT=/appl/crs"
	echo "     If this is not correct, please exit the script and modify the script variables DATAPATH, CRSROOT and BIN"
	echo
	pause '               Press any key to continue'
	echo
	echo "     The file name must be passed in as the agrument to the script, IE:"
	echo "     ./extendDel.sh loclist"
	echo "     Where 'loclist' is a file in your current directory with a list of"
	echo "     extendec locations, one location per line. You must also have the "
	echo "     'rmExtend' utility in the same directory as this script."
	echo
	pause '               Press any key to continue'
	echo
	echo "     If you have not passed in the file already, the script will now exit"
	echo "     and allow you to do so. Otherwise we will continue."
	echo
	pause '               Press any key to continue'
}

function valextend()
{
	echo
	echo "     We now must run the validate extended records tool, as removing"
	echo "     extended records requires rebuilding the extended chains"
	echo
	pause '               Press any key to continue'
	$BIN/valextend -l /tmp/valextend.log
}

intro

FILE=$1

if [ "$#" -eq 0 ]; then
	echo 
	echo "     No file passed as argument, exiting"
	exit 1
fi
if [ "$#" -gt 1 ]; then
	echo
	echo "     Too many arguments, can only process one file; exiting"
	exit 1
fi

if [ -e $1 ]; then
	debug
else
	echo
	echo "     The file passed as the argument does not exist, exiting"
	exit 1
fi

echo "     The program is done; see the rmExtend.log, rmExtend.err and rmExtend.change"
echo "     to see which locations were modified. Thank you for using the script."
