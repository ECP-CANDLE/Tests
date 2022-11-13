#!/usr/bin/env bash
. ~/.profile
pwd
set +x
export CANDLE_DATA_DIR=/nfs/gce/globalscratch/jain/Data
. /nfs/gce/software/custom/linux-ubuntu18.04-x86_64/anaconda3/rolling/etc/profile.d/conda.sh
which conda
conda env list
conda activate /nfs/gce/globalscratch/jain/conda_installs
cd ../candle_lib
pip install .
# run tests
echo "CANDLE_DATA_DIR is set to: ", $CANDLE_DATA_DIR
python -m pytest