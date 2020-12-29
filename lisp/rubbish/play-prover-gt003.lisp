;; play-prover-gt003.lisp
;; 
(load "load-rubbish.lisp")
(load "rubbish-prover-gtrail.lisp")

;; play prov003.kqc 
(play-prover-gtrail '(1)  "kqc/provers/prov003.kqc")

;(defparameter a0 (readkqc "kqc/provers/prov003.kqc"))
;
;(make-lsymlist *llist*)
;
;(defun run ()
;  (logstart)
;  (prover-gtrail '(c1))
;)
