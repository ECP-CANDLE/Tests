
source_cfg -v cfg-my-settings.sh

export CANDLE_MODEL_TYPE="SINGULARITY"
export MODEL_NAME=~/Singularity/images/DeepTTC.sif
# export MODEL_NAME=/software/improve/images/DeepTTC.sif  #Lambda
# export MODEL_NAME=/lus/grand/projects/CSC249ADOA01/images/<model>.sif  #Polaris
export PARAM_SET_FILE=hyperparams.json
