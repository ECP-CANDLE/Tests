#!/usr/bin/env bash

# JENKINS INSTALL CANDLE SH
# Installs candle_lib under GCE Jenkins
# https://jenkins-gce.cels.anl.gov/job/CANDLE_candle_lib

. ~/.profile
pwd
set +x

# Set up Conda:
. /nfs/gce/software/custom/linux-ubuntu18.04-x86_64/anaconda3/rolling/etc/profile.d/conda.sh
which conda
conda env list
conda activate /nfs/gce/globalscratch/jain/conda_installs
cd ../candle_lib

# Do the installation
set -x
pwd
pip install .
