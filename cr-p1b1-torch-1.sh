#!/bin/bash
set -eu

# CR P1B1 Torch 1

# Test checkpoint/restart for P1B1 PyTorch

echo
echo "START: CR-P1B1-TORCH-1 ..."
echo

export THIS=$( realpath $( dirname $0 ) )
source $THIS/setup-tests.sh

export CANDLE_DATA_DIR=/nfs/gce/globalscratch/jain/Data
export CANDLE_OUTPUT_DIR=$BENCHMARKS/Pilot1/P1B1/

BMK=$BENCHMARKS/Pilot1/P1B1/p1b1_baseline_pytorch.py

$THIS/cr-1.sh $BMK

echo
echo "SUCCESS."
echo
