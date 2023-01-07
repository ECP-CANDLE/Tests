#!/usr/bin/env bash

# CANDLE LIB PYTEST SH
# Tests candle_lib under GCE Jenkins: just runs pytest
# https://jenkins-gce.cels.anl.gov/job/CANDLE_candle_lib

. /nfs/gce/software/custom/linux-ubuntu18.04-x86_64/anaconda3/rolling/etc/profile.d/conda.sh
which conda
conda env list
conda activate /nfs/gce/globalscratch/jain/conda_installs
cd ../candle_lib

# run tests
export CANDLE_DATA_DIR=/nfs/gce/globalscratch/jain/Data
echo "CANDLE_DATA_DIR is set to: '$CANDLE_DATA_DIR'"
set -x
python -m pytest
