#!/bin/sh

if [ $# -ne 1 ]; then
  echo "usage: mujun-run.sh kqcname"
  exit 1
fi

export NNN=$1

sbcl --control-stack-size 1GB <<-EOD
(require :gtrail)
(in-package :rubbish)
(mujun-finder "kqc/mujun/$NNN.kqc")
EOD
(
cd mujun-output
if [ ! -d $NNN ]; then
  mkdir $NNN
fi
cp *.log $NNN
)

