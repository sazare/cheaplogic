;; play-prover-gt001.lisp
;; 
(load "load-rubbish.lisp")
(load "rubbish-prover-gtrail.lisp")

;; play prov001.kqc 

(defparameter a0 (readkqc "kqc/provers/prov001.kqc"))

(make-lsymlist *llist*)

(defun run ()
  (logstart)
  (prover-gtrail '(c1))
)
