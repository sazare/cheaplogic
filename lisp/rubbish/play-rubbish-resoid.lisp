; play from 0 to resoid

(load "load-rubbish.lisp")
;(load "rubbish-resoid.lisp")

;(clearbase)
;(clearproof)

(defparameter k001 (readekqc "kqc/data001.kqc"))

(print-clauses *clist*)
(dump-clauses *clist*)
(print-literals *llist*)


;; cidのvalueがbody, lidのvalueがlit

(defparameter r67 (resolve-id 'L6-1 'L7-1))

(defparameter rm1 (bodyof r67))

(symbol-plist (car rm1))
;(:OLID L7-2 :PLID L7-2 :CID C101)

(symbol-plist (cadr rm1))
;(:OLID L7-3 :PLID L7-3 :CID C101)

(traceplid (car rm1))
;L102-R.451 > L7-2.431 > input
;NIL

(traceplid (cadr rm1))
;L102-R.452 > L7-3.432 > input
;NIL

(print-literals rm1)
;L101-1 ().(+ Q A B) 
;L101-2 ().(- P A B) 

(dumpcs)
;C101=(PROOF (RESO NIL NIL (L6-1 L7-1)) VARS NIL NAME R)
; L101-1 (+ Q A B)
; L101-2 (- P A B)
;C100=(VARS (X Y) NAME 100)
; L100-1 (- P X Y)
; L100-2 (+ Q X Y)
; L100-3 (- R X Y)
;C11=(VARS NIL NAME 11)
; L11-1 (+ P C A)
;C10=(VARS NIL NAME 10)
; L10-1 (- Q B C)
;C9=(VARS NIL NAME 9)
; L9-1 (+ R A B)
;C8=(VARS (X Y Z) NAME 8)
; L8-1 (- R X Y)
; L8-2 (+ Q Y Z)
; L8-3 (- P Z X)
;C7=(VARS NIL NAME 7)
; L7-1 (- R A C)
; L7-2 (+ Q A B)
; L7-3 (- P A B)
;C6=(VARS NIL NAME 6)
; L6-1 (+ R A C)
;C5=(VARS (X) NAME 5)
; L5-1 (+ R X X)
;C4=(VARS (Y) NAME 4)
; L4-1 (+ P B Y)
;C3=(VARS (Y) NAME 3)
; L3-1 (+ P A Y)
;C2=(VARS (X Y) NAME 2)
; L2-1 (- Q X Y)
;C1=(VARS (Y) NAME 1)
; L1-1 (- Q A Y)
;NIL

(defparameter rm2 (resolve-id 'L101-1  'L1-1))
(dump-clause 'c102)
;C102=(PROOF (RESO (Y) (B) (L101-1 L1-1)) VARS NIL NAME R)
; L102-1 (- P A B)

(defparameter rm3 (resolve-id 'L102-1 'L3-1))
rm3
;C103
(dump-clause 'c103)
;C103=(PROOF (RESO (Y) (B) (L102-1 L3-1)) VARS NIL NAME R)
;NIL

(traceplid 'l102-1)
;L102-1 > L101-2 > L7-3 > input
;NIL

(tracep 'l102-1)
;L102-1:(OLID L7-3 PLID L101-2 CID C102)
;L101-2:(OLID L7-3 PLID L7-3 CID C101)
;L7-3:(OLID L7-3 PLID NIL CID C7)
;NIL





;; has vars
;;;; pr,-r/p,-p/[]
;; script start

(clearbase)
(defparameter cc50 (readskqc "((50 (x z) (+ P x)(+ R a z)) (51 () (- P a)) (52 (w) (- R w b)))"))
cc50
;(C50 C51 C52)

 (dump-clauses cc50)
;C50=(VARS (X Z) NAME 50)
; L50-1 (+ P X)
; L50-2 (+ R A Z)
;C51=(VARS NIL NAME 51)
; L51-1 (- P A)
;C52=(VARS (W) NAME 52)
; L52-1 (- R W B)

(defparameter r501 (resolve-id (pickl 1 (nth 0 cc50)) (pickl 0 (nth 2 cc50))))
(defparameter r502 (resolve-id (pickl 0 r501) (pickl 0 (nth 1 cc50))))

(print-clause r502)

(dumpcs)

(print-proof r502)




;;;
;; just reading check

(defparameter k2 (readekqc "kqc/data002.kqc"))


