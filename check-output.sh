#!/bin/bash
set -eu

# CHECK OUTPUT SH

if (( ${#} != 2 ))
then
  echo "usage: check_output TOKEN OUTPUT"
  exit 1
fi

TOKEN=$1
OUTPUT=$2

if grep -q "$TOKEN" $OUTPUT > /dev/null
then
  # Success!
  exit 0
fi

# Else, report error message
echo "check_output(): Could not find '$TOKEN' in $OUTPUT"
exit 1
