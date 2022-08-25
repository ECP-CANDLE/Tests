#!/bin/bash
set -eu

# CR P1B1 Torch 1

# Test checkpoint/restart for P1B1 PyTorch

echo
echo "START: CR-P1B1-TORCH-1 ..."
echo

THIS=$( realpath $( dirname $0 ) )

if [[ -d $THIS/../Benchmarks ]]
then
  BENCHMARKS=$THIS/../Benchmarks
elif [[ -d $THIS/Benchmarks ]]
then
  BENCHMARKS=$THIS/Benchmarks
else
  echo "Could not find Benchmarks!"
  exit 1
fi

BENCHMARKS=$( realpath $BENCHMARKS )
P1B1=$BENCHMARKS/Pilot1/P1B1/p1b1_baseline_pytorch.py

echo "THIS: $THIS"
PATH=$THIS:$PATH

source $THIS/utils.sh

echo "PWD:  $( /bin/pwd )"
show  BENCHMARKS

source $THIS/py-settings.sh

python $THIS/check_tf.py
echo

RUNDIR=runs/cr-p1b1-torch-1

if [[ -d $RUNDIR ]]
then
  rm -r $RUNDIR
fi

mkdir -pv $RUNDIR
cd        $RUNDIR

(
  set -x
  /bin/pwd

  # 1: Fresh run w/ checksums
  python3 $P1B1 --epochs 3                    \
                --ckpt_checksum True          \
                --ckpt_save_interval 1        \
                              |& tee run-1.out
  check-output.sh "Epoch: 2 Average" run-1.out
  check-output.sh "checksummed:"     run-1.out

  # 2: Restart run w/ checksums
  python3 $P1B1 --epochs 5                     \
                --ckpt_checksum True           \
                --ckpt_save_interval 1         \
                --ckpt_restart_mode "required" \
                                      |& tee run-2.out
  check-output.sh "restarting from epoch: 3" run-2.out
  check-output.sh "Epoch: 4 Average"         run-2.out
  check-output.sh "checksummed:"             run-2.out

  # 3: Fresh run w/o checksums
  python3 $P1B1 --epochs 3               \
               --ckpt_restart_mode "off" \
               --ckpt_checksum False     \
                                 |& tee run-3.out
  check-output.sh -n "restarting"       run-3.out
  check-output.sh -n "checksummed:"     run-3.out
  check-output.sh    "Epoch: 2 Average" run-3.out

  # 4: Fresh run, limit checkpoints kept
  rm -rfv runs/cr-p1b1-1/save/ckpts/epochs
  python3 $P1B1 --epochs 10              \
               --ckpt_restart_mode "off" \
               --ckpt_save_best False    \
               --ckpt_keep_limit    1    \
               --ckpt_save_interval 1    \
               --ckpt_checksum False     \
                           |& tee    run-4.out
  check-output.sh -n "restarting:"   run-4.out
  check-output.sh -n "checksummed:"  run-4.out
  check-output.sh    "Epoch: 9 Average"   run-4.out
  CKPTS=( $( find . -name '*.h5' ) )
  check-count.sh ${#CKPTS[@]} 1 run-4.out "ckpt count is wrong"
)

echo
echo "SUCCESS."
echo
