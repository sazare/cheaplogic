#!/bin/sh

if [ $# -ne 1 ]; then
  echo "usage: mujun-run.sh kqcpath"
  exit 1
fi

export NNN=$1

export base=`basename $NNN`

sbcl --control-stack-size 1GB <<-EOD
(require :gtrail)
(in-package :rubbish)
(mujun-finder "$NNN")
EOD
(
cd mujun-output
if [ ! -d "$base" ]; then
  mkdir "$base"
fi
cp *.log "$base"
)

