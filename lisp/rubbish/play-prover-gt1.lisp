;; simplest 
(load "load-rubbish.lisp")
(load "rubbish-prover-gtrail.lisp")

;; play for prover

(defparameter a0 (readkqc "kqc/provers/prov1.kqc"))

(make-lsymlist *llist*)

(defun run ()
  (prover-gtrail '(c1))
) 
