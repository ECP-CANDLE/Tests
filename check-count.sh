#!/bin/bash
set -eu

# CHECK COUNT SH

# Check for a COUNT

ACTUAL=$1  # Number observed
COUNT=$2   # Number expected
FILE=$3    # Test run output file
MSG="$4"   # Extra human-readable error message
if (( ACTUAL != COUNT ))
then
  echo "check-count: ACTUAL='$ACTUAL' != COUNT='$COUNT' in $FILE"
  echo "             $MSG"
  exit 1
fi
