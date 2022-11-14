#!/bin/bash
set -eu

echo "MLRMBO NIGHTLY GCE: START " $( date "+%Y-%m-%d %H:%M" )

echo SUPERVISOR=$SUPERVISOR

set -x

hostname

cd $SUPERVISOR/workflows/mlrmbo

pwd

test/test-nightly.sh nt3 gce

echo "MLRMBO NIGHTLY GCE: STOP" $( date "+%Y-%m-%d %H:%M" )
