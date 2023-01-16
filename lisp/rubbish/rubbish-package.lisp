; use local-time for summary
(ql:quickload :local-time)


(in-package :cl-user)

(defpackage :rubbish
  (:use :cl)
  (:export 
    :test-graph
    :*maxcid*
    :readekqc
    :prover-gtrail 
    :play-prover-gtrail
    :*max-clauses*
    :*max-trials*
    :*max-steps*
    :*timeout-sec*
    :lscova
    :print-proof0
    :dump-clause
    :dump-clausex
    )
 )
(in-package :rubbish)

