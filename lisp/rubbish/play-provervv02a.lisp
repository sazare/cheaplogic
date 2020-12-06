;; rubbish-provervv01.lisp
;;
(load "load-rubbish.lisp")
(load "rubbish-prover.lisp")

;; play for prover

(defparameter a1 (readkqc "kqc/provers/provvv02.kqc"))

(defun run ()
; A (((1 6)(((7 9) 2) 3)(((8 10) 4) 5)))
; B (((((1 (((6 7) 9) 2) 3) 8) 10) 4) 5)
; C ((((((7 9) 2) 3) 6) ((((8 10) 4) 5)) ) 1)
;;; etc...
;case A 
 (defparameter r1 (resolve-id 'l1-1 'l6-1))
 (defparameter r2 (resolve-id  'l7-2 'l9-1))
 (defparameter r3 (resolve-id (lidof r2 2) 'L2-1))
 (defparameter r4 (resolve-id (lidof r3 2)  'l3-1))
 (defparameter r5 (resolve-id (lidof r4 1) (lidof r1 1)))

 (defparameter r6 (resolve-id (lidof r5 1) 'l8-1))
 (defparameter r7 (resolve-id (lidof r6 1) 'l10-1))
 (defparameter r8 (resolve-id (lidof r7 1) 'l4-1))
 (defparameter r9 (resolve-id (lidof r8 1) 'l5-1))

; (fullproof r9)
; (pinfof r9)

 "case A"

)


;* (dump-clausex)
;C10=(VARS (X.428 Y.429) NAME 10)
; L10-1 (+ R1 X.428 Y.429) = (OLID L10-1 PLID NIL CID C10)
; L10-2 (- V1 X.428) = (OLID L10-2 PLID NIL CID C10)
; L10-3 (- V2 Y.429) = (OLID L10-3 PLID NIL CID C10)
;C9=(VARS (X.426 Y.427) NAME 9)
; L9-1 (+ Q1 X.426 Y.427) = (OLID L9-1 PLID NIL CID C9)
; L9-2 (- S1 X.426) = (OLID L9-2 PLID NIL CID C9)
; L9-3 (- S2 Y.427) = (OLID L9-3 PLID NIL CID C9)
;C8=(VARS (X.424 Y.425) NAME 8)
; L8-1 (- F X.424 Y.425) = (OLID L8-1 PLID NIL CID C8)
; L8-2 (- R1 X.424 Y.425) = (OLID L8-2 PLID NIL CID C8)
;C7=(VARS (X.422 Y.423) NAME 7)
; L7-1 (- E X.422 Y.423) = (OLID L7-1 PLID NIL CID C7)
; L7-2 (- Q1 X.422 Y.423) = (OLID L7-2 PLID NIL CID C7)
;C6=(VARS (X.419 Y.420 Z.421) NAME 6)
; L6-1 (- P X.419 Y.420) = (OLID L6-1 PLID NIL CID C6)
; L6-2 (+ E X.419 Y.420) = (OLID L6-2 PLID NIL CID C6)
; L6-3 (+ F Y.420 Z.421) = (OLID L6-3 PLID NIL CID C6)
;C5=(VARS NIL NAME 5)
; L5-1 (+ V2 C) = (OLID L5-1 PLID NIL CID C5)
;C4=(VARS NIL NAME 4)
; L4-1 (+ V1 B) = (OLID L4-1 PLID NIL CID C4)
;C3=(VARS NIL NAME 3)
; L3-1 (+ S2 B) = (OLID L3-1 PLID NIL CID C3)
;C2=(VARS NIL NAME 2)
; L2-1 (+ S1 A) = (OLID L2-1 PLID NIL CID C2)
;C1=(VARS (X.417 Y.418) NAME 1)
; L1-1 (- P X.417 Y.418) = (OLID L1-1 PLID NIL CID C1)
;NIL
;* 
;
