;; simplest 
(load "load-rubbish.lisp")
(load "rubbish-prover-gtrail.lisp")

;; play prov4.kqc has slightly complex one

(defparameter a0 (readkqc "kqc/provers/prov4.kqc"))

(make-lsymlist *llist*)

(defun run ()
  (logstart)
  (prover-gtrail '(c1))
) 