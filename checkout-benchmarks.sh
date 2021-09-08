#!/bin/bash
set -eu

set -x

/bin/pwd

if [[ -d Benchmarks ]]
then
  cd Benchmarks
  git pull
else
  git clone https://github.com/ECP-CANDLE/Benchmarks.git
  cd Benchmarks
  # git checkout issue-86 # On branch 'develop' as of 2021-03-31
fi
