#!/bin/bash
set -eu

# CR NT3 1

# Test checkpoint/restart for NT3

echo
echo "START: CR-NT3-1 ..."
echo

export THIS=$( readlink --canonicalize $( dirname $0 ) )
source $THIS/setup-tests.sh

set -x
BMK=$BENCHMARKS/Pilot1/NT3/nt3_baseline_keras2.py

$THIS/cr-1.sh nt3 $BMK
