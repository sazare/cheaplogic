;; simplest 
(load "load-rubbish.lisp")
(load "rubbish-prover-gtrail.lisp")

;; play for prover
(play-prover-gtrail '(1)  "kqc/provers/prov2.kqc")

;(defparameter a0 (readkqc "kqc/provers/prov2.kqc"))
;
;(make-lsymlist *llist*)
;
;(defun run ()
;  (prover-gtrail '(c1))
;) 
