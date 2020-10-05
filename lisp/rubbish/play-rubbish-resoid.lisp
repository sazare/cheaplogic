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



;;;; pr,-r/p,-p/[]
;; script start

(clearbase)
(defparameter cc50 (readskqc "((50 (x z) (+ P x)(+ R a z)) (51 () (- P a)) (52 (w) (- R w b)))"))
cc50
;(C50.471 C51.474 C52.476)
(dump-clauses cc50)
(defparameter r501 (resolve-id (cadr (bodyof (car cc50))) (car (bodyof (caddr cc50)))))
(defparameter r502 (resolve-id (car (bodyof (car r501))) (car (bodyof (cadr cc50)))))

(dump-clauses *clist*)
(print-proof (car r502))
(print-clause (car r502))

;;;; endof script

;; as results
;* (clearbase)
;NIL
;* (defparameter cc50 (readskqc "((50 (x z) (+ P x)(+ R a z)) (51 () (- P a)) (52 (w) (- R w b)))"))
;CC50
;* cc50
;(C50.471 C51.474 C52.476)
;* (dump-clauses cc50)
;C50.471=(VARS (X Z) NAME 50)
; L50-1.472 (+ P X)
; L50-2.473 (+ R A Z)
;C51.474=(VARS NIL NAME 51)
; L51-1.475 (- P A)
;C52.476=(VARS (W) NAME 52)
; L52-1.477 (- R W B)
;NIL
;* (defparameter r501 (resolve-id 'L51-1.475 'L50-1.472))
;R501
;* r501
;(C53.478 (X Z) (A Z))
;
;* (dump-clause 'C53.478 )
;C53.478=(PROOF (RESO (X Z) (A Z) (L51-1.475 L50-1.472)) VARS (X Z) NAME R)
; L53-R.479 (+ R A Z)
;NIL
;* (defparameter r513 (resolve-id 'L53-R.479 'L52-1.477))
;* r513
;(C54.480 (X Z W) (X B A))
;* *clist*
;(C54.480 C53.478 C52.476 C51.474 C50.471)
;* (dump-clauses *clist*)
;C54.480=(PROOF (RESO (X Z W) (X B A) (L53-R.479 L52-1.477)) VARS (X Z W) NAME R)
;C53.478=(PROOF (RESO (X Z) (A Z) (L51-1.475 L50-1.472)) VARS (X Z) NAME R)
; L53-R.479 (+ R A Z)
;C52.476=(VARS (W) NAME 52)
; L52-1.477 (- R W B)
;C51.474=(VARS NIL NAME 51)
; L51-1.475 (- P A)
;C50.471=(VARS (X Z) NAME 50)
; L50-1.472 (+ P X)
; L50-2.473 (+ R A Z)
;NIL
;* (print-proof 'C54.480)
;C54.480 RESO (X Z W) <- (X B A) : <L53-R.479:L52-1.477> 
;L53-R.479 (X Z).(+ R A Z) C53.478 RESO (X Z) <- (A Z) : <L51-1.475:L50-1.472> 
;L51-1.475 ().(- P A)  input C51.474
;L50-1.472 (X Z).(+ P X)  in  input C50.471
;L52-1.477 (W).(- R W B)  in  input C52.476
;NIL
;* (print-clause 'C54.480)
;C54.480: R (X Z W) NIL
;
;
