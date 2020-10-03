;; play from 0 to resoid

(load "load-rubbish.lisp")
(load "rubbish-resoid.lisp")

(clearbase)
;(clearproof)

(defparameter k001 (readkqc "kqc/data001.kqc"))

(print-clauses *clist*)
(dump-clauses *clist*)
(print-literals *llist*)


;; cidのvalueがbody, lidのvalueがlit

(defparameter r67 (resolve-id 'L6-1.428 'L7-1.430))


(defparameter rm1 (bodyof (car r67)))

(symbol-plist (car rm1))
;(:PLID L7-2.431 :CID C102.450)
(symbol-plist (cadr rm1))
;(:PLID L7-3.432 :CID C102.450)

(traceplid (car rm1))
;L102-R.451 > L7-2.431 > input
;NIL

(traceplid (cadr rm1))
;L102-R.452 > L7-3.432 > input
;NIL





;; has vars
 (load "ito-rubbish-kqcio.lisp")

(dump-clauses schose001a)
;C1.453=(VARS (W Y) NAME 1)
; L1-1.454 (- P (F Y) W)
; L1-2.455 (+ Q (G W Y))
;C2.456=(VARS (X) NAME 2)
; L2-1.457 (+ P X (F X))
; L2-2.458 (+ Q (G X B))
;
(defparameter r1222 (resolve-id 'l1-1.454 'l2-1.457))
;R1222
r1222
;(C3.459 (W Y X) ((F (F Y)) Y (F Y)))
(dump-clause 'c3.459)
;C3.459=(VARS (Y) NAME R)
; L3-R.460 (+ Q (G (F (F Y)) Y))
; L3-R.461 (+ Q (G (F Y) B))
;NIL
(symbol-plist 'l3-R.460)
;(:PLID L1-2.455 :CID C3.459)
;* (symbol-plist 'l3-r.461)
;(:PLID L2-2.458 :CID C3.459)
;



