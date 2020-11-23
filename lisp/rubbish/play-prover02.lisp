
;; play for prover

(load "load-rubbish.lisp")
(load "rubbish-prover.lisp")

(defparameter a2 (readkqc "kqc/provers/prov002.kqc"))

(defun run ()

(dump-clauses a2)

)
