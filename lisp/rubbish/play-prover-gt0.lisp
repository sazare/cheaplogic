;; simplest 
(load "load-rubbish.lisp")
(load "rubbish-prover.lisp")
(load "rubbish-prover-gtrail.lisp")

;; play for prover

(defparameter a0 (readkqc "kqc/provers/prov0.kqc"))

(make-lsymlist *llist*)

(defun run ()
  (prover-gtrail '(c1))
) 
