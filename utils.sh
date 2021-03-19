
# UTILS SH

show()
# Report variable names with their values
{
  for v in $*
  do
    eval "echo $v: \${$v:-}"
  done
}

log_path()
# Pretty print a colon-separated variable
# Provide the name of the variable (no dollar sign)
{
  echo ${1}:
  local v=${1:-}
  eval echo \$\{$1\:\-\} | tr : '\n' | nl
}

which_check()
{
  if [[ ${#} != 1 ]]
  then
    echo "Provide a PROGRAM!"
    exit 1
  fi
  PROGRAM=$1
  if ! which $PROGRAM
  then
    echo "Could not find $PROGRAM"
    exit 1
  fi
}

