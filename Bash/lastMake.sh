#!/bin/sh

export PATH=/usr/local/bin:$PATH
LOG=/home/jwhite/logs/lastMake.log
LLOG=/home/jwhite/logs/make.log
ERR=/home/jwhite/logs/lastMake.err
ECHO="/bin/echo -e"
DNULL=/dev/null
BASE=/home/jwhite
L=$BASE/trunk/base/lib
K=kitkut
S=$BASE/trunk/base/src
M=$BASE/trunk/modules

##------------------------------------------------------------------------------
## function to set the date and time
setDate()
{
YEAR=`date +%y`		# This is the year (99)
MONTH=`date +%m`	# This is the month in short format (01, etc)
DAY=`date +%d`		# This is the day in short format (01, etc)
HOUR=`date +%H`		# Time is hour (24)
MIN=`date +%M`		# Time is min (24)
SEC=`date +%S`		# Time is seconds (60)
DNAME=`date +%a`	# This is the day as Sun/Sat...

return
}

setDate
>$ERR
setDate

$ECHO "Begin Make At $MONTH/$DAY/$YEAR at $HOUR:$MIN:$SEC\c" >> $LLOG

$ECHO "Begin Last Make At $MONTH/$DAY/$YEAR at $HOUR:$MIN:$SEC\c" >> $LOG

##for i in $L $S $L14 $S14 $C14 $L9 $S9; do
for i in $L $S $M; do
	cd $i
	make -k 1>>$LOG 2>>$ERR
done

for j in $L $S $M; do
	cd $j
	for i in `find . -print | grep "\.o$"`; do
		if [ -f $i ]; then
			rm -f $i 1>$DNULL 2>>$ERR
		fi
	done
done

setDate
$ECHO " -- End Last At $MONTH/$DAY/$YEAR at $HOUR:$MIN:$SEC" >> $LOG
$ECHO " -- End At $MONTH/$DAY/$YEAR at $HOUR:$MIN:$SEC" >> $LLOG
