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

  python3 $NT3 --epochs 5  |& tee    run-1.out
  check-output.sh "Epoch 5/5"        run-1.out
  # TODO: Check that we did a successful checksum

  python3 $NT3 --epochs 10 |& tee    run-2.out
  check-output.sh "initial_epoch: 5" run-2.out
  check-output.sh "Epoch 10/10"      run-2.out
  # TODO: Check that we did a successful checksum for read+write

  python3 $NT3 --epochs 3                \
               --ckpt_checksum=False     \
               --ckpt_restart_mode="off" \
                           |& tee    run-3.out
  # TODO: Check that we did not restart
  # TODO: Check that we did not try to checksum
  check-output.sh "Epoch 3/3"        run-3.out

)
echo
echo "SUCCESS."
echo
