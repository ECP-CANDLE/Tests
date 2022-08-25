#!/bin/bash
set -eu

# CR NT3 1

# Test checkpoint/restart for NT3

echo
echo "START: CR-NT3-1 ..."
echo

THIS=$( readlink --canonicalize $( dirname $0 ) )

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

BENCHMARKS=$( readlink --canonicalize $BENCHMARKS )
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

# Shrink the train/test data by 90% (to 10% of original size)
# Only shrinks if the data already exists-
#      thus, the first run after auto-download will be slow.

DATA_PILOT1=$BENCHMARKS/Data/Pilot1
CSV=$DATA_PILOT1/nt_test2.csv
if [[ -f $CSV ]]
then
  SIZE=$( stat --format "%s" $CSV )
  if (( SIZE > 100000000 )) # 100 MB
  then
    echo "Shrinking test CSV..."
    T=$( mktemp --suffix=.csv --tmpdir=$DATA_PILOT1 nt_test-XXX )
    (
      set -x
      head --lines=28 $CSV > $T
      mv --backup --force $CSV $CSV.orig
      mv $T $CSV
    )
  fi
fi

CSV=$DATA_PILOT1/nt_train2.csv
if [[ -f $CSV ]]
then
  SIZE=$( stat --format "%s" $CSV )
  if (( SIZE > 500000000 )) # 500 MB
  then
    echo "Shrinking train CSV..."
    T=$( mktemp --suffix=.csv --tmpdir=$DATA_PILOT1 nt_train-XXX )
    (
      set -x
      head --lines=112 $CSV > $T
      mv --backup --force $CSV $CSV.orig
      mv $T $CSV
    )
  fi
fi

(
  set -x
  /bin/pwd

  # 1: Fresh run w/ checksums
  python3 $NT3 --epochs 3             \
               --ckpt_checksum True   \
               --ckpt_save_interval 1 \
                           |& tee    run-1.out
  check-output.sh "Epoch 3/3"        run-1.out
  check-output.sh "checksummed:"     run-1.out

  # 2: Restart run w/ checksums
  python3 $NT3 --epochs 5 \
               --ckpt_checksum True \
               --ckpt_save_interval 1 \
               --ckpt_restart_mode "required" \
                                      |& tee run-2.out
  check-output.sh "restarting from epoch: 3" run-2.out
  check-output.sh "Epoch 5/5"                run-2.out
  check-output.sh "checksummed:"             run-2.out

  # 3: Fresh run w/o restart/checksums
  python3 $NT3 --epochs 3                \
               --ckpt_restart_mode "off" \
               --ckpt_checksum False     \
                           |& tee    run-3.out
  check-output.sh -n "restarting"    run-3.out
  check-output.sh -n "checksummed:"  run-3.out
  check-output.sh    "Epoch 3/3"     run-3.out

  # 4: Fresh run, limit checkpoints kept
  rm -rfv runs/cr-nt3-1/save/ckpts/epochs
  python3 $NT3 --epochs 10               \
               --ckpt_restart_mode "off" \
               --ckpt_save_best False    \
               --ckpt_keep_limit 1       \
               --ckpt_checksum False     \
                           |& tee    run-4.out
  check-output.sh -n "restarting:"   run-4.out
  check-output.sh -n "checksummed:"  run-4.out
  check-output.sh    "Epoch 10/10"   run-4.out
  CKPTS=( $( find . -name '*.h5' ) )
  check-count.sh ${#CKPTS[@]} 1 run-4.out "ckpt count is wrong"
)

echo
echo "SUCCESS."
echo
