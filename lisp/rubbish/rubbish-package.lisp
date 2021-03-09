(in-package :cl-user)

(defpackage :rubbish
  (:use :cl)
  (:export 
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
;; when (load "rubbish-package.lisp")
;; then *package* is :cl-user not rubbish
;; WHAT DOES THIS MEAN
