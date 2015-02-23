#!/bin/sh
## valid-date - validate date, taking into account leap year rules
## Checks to see if a date entered is valid.

normDate()
{
### normdate - Normalizes month field in date specification
###  to integer for statement processing. 
###   
### Borrowed from the book "Wicked Cool Shell Scripts"
### Modified to fit situation by Von Landfried @ CR Software, Inc.

if [ $# -ne 3 ] ; then
  #echo "Usage: $0 month day year" >&2
  #echo "Try August 3 1962 or 8 3 2002 or 2-1-1980 or 2/1/2005" >&2
  exit 1
fi

year=$3

if [ $3 -lt 99 ] ; then
 # need to make this a four digit year for valid_date.sh to work right 
 # checking for leap years. I know assuming 20** is bad, but who cares
 # I will be dead before somebody notices this problem.
 year=20$3 
fi

if [ $3 -gt 2099 ] ; then
 # The year is greater than 2099, this will probably not work and frankly
 # CRS is probably not around anymore.
 exit 1
fi

if [ -z $(echo $1|sed 's/[[:alpha:]]//g') ]; then
{
 # checks to see if they entered a month with alpha characters
  case $(echo $1|tr '[:upper:]' '[:lower:]') in
    jan* ) month=01    ;;  feb* ) month=02    ;;
    mar* ) month=03    ;;  apr* ) month=04    ;;
    may* ) month=05    ;;  jun* ) month=06    ;;
    jul* ) month=07    ;;  aug* ) month=08    ;;
    sep* ) month=09    ;;  oct* ) month=10    ;;
    nov* ) month=11    ;;  dec* ) month=12    ;;
    * ) exit 1
   esac
}
else
 # month is already an integer, just continue
	twoDigitMonth $1
fi

newdate="$month $2 $year"

}

exceedsDaysInMonth()
{
  # given a month name, return 0 if the specified day value is
  # less than or equal to the max days in the month, 1 otherwise

  case $1 in
    01 ) days=31    ;;  02 ) days=28    ;;
    03 ) days=31    ;;  04 ) days=30    ;;
    05 ) days=31    ;;  06 ) days=30    ;;
    07 ) days=31    ;;  08 ) days=31    ;;
    09 ) days=30    ;;  10 ) days=31    ;;
    11 ) days=30    ;;  12 ) days=31    ;;
    * ) #echo "$0: Unknown month name $1" >&2; 
	exit 1
   esac
   
   if [ $2 -lt 1 -o $2 -gt $days ] ; then
     return 1
   else
     return 0	# all is well
   fi 
}

twoDigitMonth()
{
  # given a integer month, make sure its two digits

  case $1 in
    1 ) month=01    ;;  2 ) month=02    ;;
    3 ) month=03    ;;  4 ) month=04    ;;
    5 ) month=05    ;;  6 ) month=06    ;;
    7 ) month=07    ;;  8 ) month=08    ;;
    9 ) month=09    ;;
    * ) #already two digits, nevermind 
		month=$1
  esac
   
}

twoDigitDays()
{
  # given a integer day, make sure its two digits

  case $1 in
    1 ) day=01    ;;  2 ) day=02    ;;
    3 ) day=03    ;;  4 ) day=04    ;;
    5 ) day=05    ;;  6 ) day=06    ;;
    7 ) day=07    ;;  8 ) day=08    ;;
    9 ) day=09    ;;
    * ) #already two digits, nevermind 
		day=$1
  esac
   
}

isLeapYear()
{    
  # this function returns 0 if a leap year, 1 otherwise
  # The formula for checking whether a year is a leap year is: 
  # 1. years divisible by four are leap years, unless..
  # 2. years also divisible by 100 are not leap years, except...
  # 3. years divisible by 400 are leap years

  year=$1
  if [ "$((year % 4))" -ne 0 ] ; then
    return 1 # nope, not a leap year
  elif [ "$((year % 400))" -eq 0 ] ; then
    return 0 # yes, it's a leap year
  elif [ "$((year % 100))" -eq 0 ] ; then
    return 1
  else
    return 0
  fi 
}

###############################################
###############################################
###############################################
#######------[ Begin main script ]------#######
###############################################
###############################################
###############################################
###############################################

if [ $# -eq 1 ] ; then  # try to compensate for / or - formats
  set -- $(echo $1 | sed 's/[\/\-]/ /g')
fi

if [ $# -ne 3 ] ; then
  #echo "Usage: $0 month day year" >&2
  #echo "Typical input formats are August 3 1962 and 8 3 2002" >&2
  exit 1
fi

# normalize date and split back out returned values

normDate $1 $2 $3
#newdate="$($normdate "$@")"


if [ $? -eq 1 ] ; then
  exit 1	# error condition already reported by normDate
fi

month="$(echo $newdate | cut -d\  -f1)"
  day="$(echo $newdate | cut -d\  -f2)"
 year="$(echo $newdate | cut -d\  -f3)"

# Now that we have a normalized date, let's check to see if the
# day value is logical 


if ! exceedsDaysInMonth $month "$2" ; then
  if [ "$month" = "02" -a $2 -eq 29 ] ; then
    if ! isLeapYear $3 ; then
      #echo "$3 is not a leap year, so Feb doesn't have 29 days" >&2
      exit 1
    fi
  else 
    #echo "$month doesn't have $2 days" >&2
    exit 1
  fi
fi

# Make year two digits, and hope for the best
year="$(echo $year | cut -c3-)"

# Make sure day is two digits
twoDigitDays $day

echo "$month/$day/$year"

exit 0

