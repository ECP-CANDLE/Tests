#!/bin/bash
set -eu

# CR 1

# Test checkpoint/restart for any Benchmark

if (( ${#} != 2 ))
then
  echo "$0: provide: MODEL_NAME BMK"
  exit 1
fi

# BMK: The Benchmark to run
MODEL_NAME=$1
BMK=$2

OUTPUT=$CANDLE_DATA_DIR/$MODEL_NAME/EXP000/RUN000

echo
echo "START: CR-1 $MODEL_NAME BMK $BMK ..."
echo

source $THIS/utils.sh
source $THIS/setup-test.sh

(
  set -x
  /bin/pwd

  set -o pipefail

  # 1: Fresh run w/ checksums
  python3 $BMK --epochs 3             \
               --ckpt_checksum True   \
               --ckpt_save_interval 1 \
                           |& tee    run-1.out
  check-epoch.sh  3                  run-1.out
  check-output.sh "checksummed:"     run-1.out

  # 2: Restart run w/ checksums
  python3 $BMK --epochs 5 \
               --ckpt_checksum True \
               --ckpt_save_interval 1 \
               --ckpt_restart_mode "required" \
                                      |& tee run-2.out
  check-output.sh "restarting from epoch: 3" run-2.out
  check-epoch.sh  5                          run-2.out
  check-output.sh "checksummed:"             run-2.out

  # 3: Fresh run w/o restart/checksums
  python3 $BMK --epochs 3                \
               --ckpt_restart_mode "off" \
               --ckpt_checksum False     \
                           |& tee    run-3.out
  check-output.sh -n "restarting"    run-3.out
  check-output.sh -n "checksummed:"  run-3.out
  check-epoch.sh     3               run-3.out

  # 4: Fresh run, limit checkpoints kept
  rm -rfv runs/cr-$TOKEN-1/save/ckpts/epochs
  python3 $BMK --epochs 10               \
               --ckpt_restart_mode "off" \
               --ckpt_keep_limit 1       \
               --ckpt_save_interval 1    \
               --ckpt_save_best False    \
               --ckpt_checksum False     \
                           |& tee    run-4.out
  check-output.sh -n "restarting:"   run-4.out
  check-output.sh -n "checksummed:"  run-4.out
  check-epoch.sh     10              run-4.out
  CKPTS=( $( find $OUTPUT -name '*.h5' ) )
  check-count.sh ${#CKPTS[@]} 1 run-4.out "ckpt count is wrong"
)

echo
echo "SUCCESS: CR-1 BMK $BMK"
echo
