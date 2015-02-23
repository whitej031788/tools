#!/bin/bash

ROOT=/appl/jwhite/16
DATAPATH=$ROOT/data
LD_LIBRARY_PATH=$ROOT/lib
MONTHEND=0
DAYOFMONTH=$(date +%d)
#echo $DAYOFMONTH
if [ "$DAYOFMONTH" = "01" ]; then
	MONTHEND=1
fi

MONTHEND=0
#echo $MONTHEND
if [ "$MONTHEND" -eq "0" ]; then
echo "   Start reb_analysis: `date '+%m/%d/%y %H:%M:%S'`"
$ROOT/bin/reb_analysis -cv
echo "   End reb_analysis: `date '+%m/%d/%y %H:%M:%S'`"
fi
