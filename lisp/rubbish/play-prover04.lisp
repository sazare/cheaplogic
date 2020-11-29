;; prov004 has some proof do same

(load "load-rubbish.lisp")
(load "rubbish-prover.lisp")

(defparameter a3 (readkqc "kqc/provers/prov004.kqc"))

(defparameter *lsyms* (make-lsymlist *llist*))

(defun run ()
;(A (((((((L3-2 L4-1) L2-2) L1-3) L4-1) L6-1) L5-1)))
;same (A (((((((((((3-2 4-1) 1) 2-2) 1) 1-3) 2) 4-1)1) 6-1)1) 5-1))

 (defparameter r1 (resolve-id 'l3-2 'l4-1))
 (defparameter r2 (resolve-id (lidof r1 1) 'L2-2))
 (defparameter r3 (resolve-id (lidof r2 1) 'L1-3))
 (defparameter r4 (resolve-id (lidof r3 2) 'L4-1))
 (defparameter r5 (resolve-id (lidof r4 1) 'L6-1))
 (defparameter r6 (resolve-id (lidof r5 1) 'L5-1))

(dump-clausex)

 (print-proof0 r6)
; (pinfof r6)
; ((L6-2 L5-1) (L1-1 L6-1) (L1-2 L4-1) (L2-1 L1-3) (L3-1 L2-2) (L3-2 L4-1))
; (pcode r6)
; "((L6-2 L5-1) (L1-1 L6-1) (L1-2 L4-1) (L2-1 L1-3) (L3-1 L2-2) (L3-2 L4-1))"

)

