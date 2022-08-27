
# SETUP TEST
# Setup single test
# Assumes shell variable BMK is set to the fully-qualified
#         Benchmark script name

# TOKEN: Short name for Benchmark: "NT3", "P1B1", etc.
TOKEN=$( basename $( dirname $BMK ) )
show TOKEN
RUNDIR=runs/cr-$TOKEN-1

if [[ -d $RUNDIR ]]
then
  rm -r $RUNDIR
fi

mkdir -pv $RUNDIR
cd        $RUNDIR

# Detect Keras or PyTorch by looking at the Benchmark filename
if [[ $BMK == *keras* ]]
then
  export BACKEND="keras"
elif [[ $BMK == *torch* ]]
then
  export BACKEND="torch"
else
  echo "Could not find Benchmark backend in BMK='$BMK'"
  exit 1
fi

# If a setup script for this Benchmark exists, run it
SETUP=$THIS/setup-$TOKEN.sh
if [[ -f $SETUP ]]
then
  echo "source $SETUP ..."
  source $SETUP
  echo "source $SETUP done."
fi
