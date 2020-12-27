;; simplest 
(load "load-rubbish.lisp")
(load "rubbish-prover-gtrail.lisp")

;; play for prover

(defparameter a0 (readkqc "kqc/provers/prov3vv.kqc"))

(make-lsymlist *llist*)

(defun run ()
  (logstart)
  (prover-gtrail '(c1))
  (logshow)
) 
