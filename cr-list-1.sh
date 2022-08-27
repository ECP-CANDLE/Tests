#!/bin/bash
set -eu

# CR LIST 1

# List of CR=Checkpoint/Restart tests to run
# Assumes BENCHMARKS is in the environment

echo "CR LIST: START ..."
echo

export THIS=$( realpath $( dirname $0 ) )
source $THIS/setup-tests.sh

CR_LIST=(
  $BENCHMARKS/Pilot1/NT3/nt3_baseline_keras2.py
  $BENCHMARKS/Pilot1/P1B1/p1b1_baseline_pytorch.py
)

for BMK in ${CR_LIST[@]}
do
  $THIS/cr-1.sh $BMK
done

echo
echo "CR LIST: DONE."
