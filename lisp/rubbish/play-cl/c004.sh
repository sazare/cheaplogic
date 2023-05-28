#!/bin/zsh

sbcl --control-stack-size 128MB --core runc004 --script c004.lisp --end-toplevel-options "((x) (+ P x))" "kqc/mujun/mj001.kqc" 


;
;(sb-ext:save-lisp-and-die "runc004" :executable t)

