#!/bin/bash -eu

echo "UPF NIGHTLY GCE"

echo SUPERVISOR=$SUPERVISOR

set -x

cd $SUPERVISOR/workflows/upf

./upf-1.sh
