;; play-prover-gt004.lisp
;; 
(load "load-rubbish.lisp")
(load "rubbish-prover-gtrail.lisp")

;; play prov004.kqc 

(defparameter a0 (readkqc "kqc/provers/prov004.kqc"))

(make-lsymlist *llist*)

(defun run ()
  (logstart)
  (prover-gtrail '(c1))
)