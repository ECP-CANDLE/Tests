#!/bin/bash
set -eu

echo "UPF NIGHTLY GCE: START " $( date "+%Y-%m-%d %H:%M" )

echo SUPERVISOR=$SUPERVISOR

set -x

hostname

cd $SUPERVISOR/workflows/upf

pwd

test/upf-1.sh nt3 gce

echo "UPF NIGHTLY GCE: STOP" $( date "+%Y-%m-%d %H:%M" )
