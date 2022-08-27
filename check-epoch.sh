#!/bin/bash
set -eu

# CHECK EPOCH SH

# Check for epoch number in given OUTPUT file
#       for appropriate environment variable BACKEND="keras"|"torch"
#       with nice error message

if (( ${#} != 2 ))
then
  echo "usage: check_output EPOCH OUTPUT"
  exit 1
fi

# The epoch we want to find:
EPOCH=$1
# The model training output we are looking at:
OUTPUT=$2

# Assume failure:
SUCCESS=0

# Construct a backend-specific string pattern to find
if [[ $BACKEND == "keras" ]]
then
  printf -v PATTERN "Epoch %i/%i" $EPOCH $EPOCH
elif [[ $BACKEND == "torch" ]]
then
  (( EPOCH = EPOCH - 1 ))  # PyTorch epochs start at 0
  printf -v PATTERN "Epoch: %i Average" $EPOCH
fi

# Look for the pattern!
if check-output.sh "$PATTERN" $OUTPUT
then
  SUCCESS=1
fi

if (( ! SUCCESS ))
then
  echo "check-epoch.sh: epoch not found: " $EPOCH
  exit 1
fi

# Success
exit 0
