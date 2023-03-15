#!/bin/bash
set -eu

echo "MLRMBO NIGHTLY GCE: START " $( date "+%Y-%m-%d %H:%M" )

echo SUPERVISOR=$SUPERVISOR

set -x

hostname

cd $SUPERVISOR/workflows/mlrMBO

pwd
export CANDLE_DATA_DIR=/nfs/gce/globalscratch/jain/Data/Pilot1
ls $CANDLE_DATA_DIR

test/test-nightly.sh nt3 gce

echo "NT3 MLRMBO NIGHTLY GCE: STOP" $( date "+%Y-%m-%d %H:%M" )
