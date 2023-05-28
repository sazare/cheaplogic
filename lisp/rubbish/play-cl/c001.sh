#/bin/zsh 

sbcl --control-stack-size 128MB --core rungtrail --script c001.lisp

echo $?


;(require :gtrail)
;(in-package :rubbish)
;(sb-ext:save-lisp-and-die "rungtrail" :executable t)

