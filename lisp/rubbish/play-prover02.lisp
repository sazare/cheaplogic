
;; play for prover

(load "load-rubbish.lisp")
(load "rubbish-prover.lisp")

(defparameter a2 (readkqc "kqc/provers/prov002.kqc"))

(defun run ()

(dump-clauses a2)
 (defparameter r30 (resolve-id 'l21-3 'l24-1))
 (defparameter r31 (resolve-id 'l25-1 (lidof r30 3)))
 (defparameter r32 (resolve-id 'l22-1 (lidof r31 1)))
 (defparameter r33 (resolve-id 'l23-1 (lidof r32 1)))
 (defparameter r34 (resolve-id 'l26-1 (lidof r33 1)))
)
