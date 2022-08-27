#!/bin/bash
set -eu

# CR P1B1 Torch 1

# Test checkpoint/restart for P1B1 PyTorch

echo
echo "START: CR-P1B1-TORCH-1 ..."
echo

export THIS=$( realpath $( dirname $0 ) )
source $THIS/setup-tests.sh

BMK=$BENCHMARKS/Pilot1/P1B1/p1b1_baseline_pytorch.py

$THIS/cr-1.sh $BMK

echo
echo "SUCCESS."
echo
