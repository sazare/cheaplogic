; use local-time for summary
(ql:quickload :local-time)

(in-package :cl-user)

(defpackage :rubbish
  (:use :cl)
  (:export 
    :*maxcid*
    :readekqc

    :prover-gtrail 
    :play-prover-gtrail
    :*max-clauses*
    :*max-trials*
    :*max-steps*
    :*timeout-sec*
    :print-literal
    :print-literals
    :print-clause
    :print-clauses
    :print-clausex
    :dump-clause
    :dump-clausex
    :show-allparams

    :lscova
    :print-proof0
    :list-proof0
    :pcode
    :p2code
    :ccode
    :list-mgu

    :analyze-pcode
    :analyze-p2code
    :reportc

    :mujun-prover
    *clist*

    *enable-semantics*
    *enable-reduce-syntax* 

;   *max-clauses* 
    *max-clauses*
    *max-contradictions* 
    *max-trials* 
    *max-steps* 
    *timeout-sec*
    )
 )

