#!/bin/bash
set -eu

# CHECK OUTPUT SH

# Check for TOKEN in given OUTPUT file
# with nice error message

# Options:
# n: Not = Check that TOKEN is not found

# Defaults
NOT=0

while getopts "n" OPT
do
  case $OPT
  in
    n) NOT=1 ;;
    *) exit 1 ;; # Bash prints an error
  esac
done
shift $(( OPTIND - 1 ))


if (( ${#} != 2 ))
then
  echo "usage: check_output TOKEN OUTPUT"
  exit 1
fi

TOKEN=$1
OUTPUT=$2

SUCCESS=0

if grep -q "$TOKEN" $OUTPUT > /dev/null
then
  if (( NOT ))
  then
    echo "check_output(): ERROR: Found '$TOKEN' in $OUTPUT"
  else
    SUCCESS=1
  fi
else
  if (( NOT ))
  then
    SUCCESS=1
  else
    echo "check_output(): ERROR: Could not find '$TOKEN' in $OUTPUT"
  fi
fi

if (( ! SUCCESS ))
then
  exit 1
fi

# Success
exit 0
