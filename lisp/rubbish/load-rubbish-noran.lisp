; rubbish loader

(load "rubbish-gen-noran.lisp")

(load "load-rubbish-base.lisp")
(load "load-rubbish-kqcio.lisp")
(load "load-rubbish-unif.lisp")
(load "load-rubbish-reso.lisp")

(defparameter *sunification* #'unificationsp)
(defparameter *ssubst*  #'substp)
(defparameter *ssubsub* #'subsubp)

(load "rubbish-resoid.lisp")
(load "rubbish-print.lisp")
(load "rubbish-proof.lisp")

