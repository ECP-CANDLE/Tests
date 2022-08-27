
# SETUP NT3

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
