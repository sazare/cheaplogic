;; play-prover-gt002.lisp
;; 
(load "load-rubbish.lisp")
(load "rubbish-prover-gtrail.lisp")

;; play prov002.kqc 

(play-prover-gtrail '(1)  "kqc/provers/prov002.kqc")

;(defparameter a0 (readkqc "kqc/provers/prov002.kqc"))
;
;(make-lsymlist *llist*)
;
;(defun run ()
;  (logstart)
;  (prover-gtrail '(c1))
;)
