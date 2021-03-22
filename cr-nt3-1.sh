#!/bin/bash
set -eu

# CR NT3 1

# Test checkpoint/restart for NT3

echo
echo "START: CR-NT3-1 ..."
echo

THIS=$(       readlink --canonicalize $( dirname $0 ) )
BENCHMARKS=$( readlink --canonicalize $THIS/../Benchmarks )
NT3=$BENCHMARKS/Pilot1/NT3/nt3_baseline_keras2.py

echo "THIS: $THIS"
PATH=$THIS:$PATH

source $THIS/utils.sh

echo "PWD:  $( /bin/pwd )"
show  BENCHMARKS

source $THIS/py-settings.sh

python $THIS/check_tf.py
echo

RUNDIR=runs/cr-nt3-1

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
  python3 $NT3 --epochs 5 --ckpt_checksum True |& tee    run-1.out
  check-output.sh "Epoch 5/5"        run-1.out
  check-output.sh "checksummed:"     run-1.out

  # 2: Restart run w/ checksums
  python3 $NT3 --epochs 10 --ckpt_checksum True |& tee    run-2.out
  check-output.sh "initial_epoch: 5" run-2.out
  check-output.sh "Epoch 10/10"      run-2.out
  check-output.sh "checksummed:"     run-2.out

  # 3: Fresh run w/o checksums
  python3 $NT3 --epochs 3                \
               --ckpt_restart_mode "off" \
                           |& tee    run-3.out
  check-output.sh -n "restarting:"   run-3.out
  check-output.sh -n "checksummed:"  run-3.out
  check-output.sh    "Epoch 3/3"     run-3.out

  # 4: Fresh run, limit checkpoints kept
  rm -rfv runs/cr-nt3-1/save/ckpts/epochs
  python3 $NT3 --epochs 10               \
               --ckpt_restart_mode "off" \
               --ckpt_save_best False    \
               --ckpt_keep_limit 4       \
                           |& tee    run-4.out
  check-output.sh -n "restarting:"   run-4.out
  check-output.sh -n "checksummed:"  run-4.out
  check-output.sh    "Epoch 10/10"   run-4.out
  check-output.sh    "Epoch 10/10"   run-4.out
  CKPTS=( $( find . -name '*.h5' ) )
  check-count.sh ${#CKPTS[@]} 4 run-4.out "ckpt count is wrong"
)

echo
echo "SUCCESS."
echo
