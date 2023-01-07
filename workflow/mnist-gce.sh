#!/bin/bash
set -eu

echo "MNIST GCE: START " $( date "+%Y-%m-%d %H:%M" )

echo CANDLE_REPO=$CANDLE_REPO

set -x

hostname

cd $CANDLE_REPO/examples/mnist/

pwd
export CANDLE_DATA_DIR=/nfs/gce/globalscratch/jain/Data
ls $CANDLE_DATA_DIR

PATH=/nfs/gce/globalscratch/jain/conda_installs/bin:$PATH
which python

python mnist_candle.py

echo "MNIST GCE: STOP " $( date "+%Y-%m-%d %H:%M" )
