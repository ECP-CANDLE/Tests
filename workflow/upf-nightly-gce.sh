#!/bin/bash -eu

echo "UPF NIGHTLY GCE: START " $( date "+%Y-%m-%d %H:%M" )

echo SUPERVISOR=$SUPERVISOR

set -x

swift-t -v
exit

cd $SUPERVISOR/workflows/upf

test/upf-1.sh nt3 gce

echo "UPF NIGHTLY GCE: STOP" $( date "+%Y-%m-%d %H:%M" )
