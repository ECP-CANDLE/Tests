
# FIND BENCHMARKS

# Find and export the BENCHMARKS directory

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

export BENCHMARKS=$( realpath $BENCHMARKS )
show BENCHMARKS
