; rubbish loader

(load "rubbish-essential.lisp")

(load "load-rubbish-gen.lisp")

(load "load-rubbish-base.lisp")
(load "load-rubbish-kqcio.lisp")
(load "load-rubbish-unif.lisp")
(load "load-rubbish-reso.lisp")

(defparameter *sunification* #'unificationsp)
(defparameter *ssubst*  #'substp)
(defparameter *ssubsub* #'subsubp)

(load "rubbish-statistics.lisp") ; for resoid
(load "rubbish-resoid.lisp")
(load "rubbish-print.lisp")
(load "rubbish-proof.lisp")

(load "rubbish-prover.lisp")
(load "rubbish-prover-gtrail.lisp")

(load "rubbish-log.lisp")

