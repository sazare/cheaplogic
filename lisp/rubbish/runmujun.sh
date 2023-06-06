#!/bin/sh

if [ $# -ne 1 ]; then
  echo "usage: mujun-run.sh kqcname"
  echo "kqc/mujun/kqcname.kqc should be it"
  exit 1
fi

export NNN=$1

sbcl --control-stack-size 1GB <<-EOD
(require :gtrail)
(in-package :rubbish)
(mujun-finder "kqc/mujun/$NNN.kqc" )
EOD
(
cd mujun-output
mkdir $NNN
cp *.log $NNN
)

