
echo SETTINGS

# General Settings
export PROCS=4
export PPN=4
export WALLTIME=12:00:00
export NUM_ITERATIONS=3
export POPULATION_SIZE=4

# GA Settings
export GA_STRATEGY='mu_plus_lambda'
export OFFSPRING_PROPORTION=0.5
export MUT_PROB=0.8
export CX_PROB=0.2
export MUT_INDPB=0.8
export CX_INDPB=0.2
export TOURNSIZE=4

# Lambda Settings
# export CANDLE_CUDA_OFFSET=1
export IMPROVE_DATA_DIR=/tmp/weaverr/Data
export CANDLE_DATA_DIR=/tmp/weaverr/Data

# Polaris Settings
# export QUEUE="debug"
# export CANDLE_DATA_DIR=/home/<user>/data_dir

