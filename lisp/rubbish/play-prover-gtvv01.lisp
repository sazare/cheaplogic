;; play-prover-gtvv01.lisp
(load "load-rubbish.lisp")
(load "rubbish-prover-gtrail.lisp")

;; play provvv01.kqc

(play-prover-gtrail '(1)  "kqc/provers/provvv01.kqc")

;(defparameter a0 (readkqc "kqc/provers/provvv01.kqc"))
;
;(make-lsymlist *llist*)
;
;(defun run ()
;  (logstart)
;  (prover-gtrail '(c1))
;) 
