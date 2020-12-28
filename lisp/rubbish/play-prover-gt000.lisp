;; play-prover-gt000.lisp
;; 
(load "load-rubbish.lisp")
(load "rubbish-prover-gtrail.lisp")

;; play prov000.kqc 

(defparameter a0 (readkqc "kqc/provers/prov000.kqc"))

(make-lsymlist *llist*)

(defun run ()
  (logstart)
  (prover-gtrail '(c1))
)
