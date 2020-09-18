;ito for rubbish-resoid.lisp

(myload "ito.lisp")
(load "load-rubbish.lisp")
(load "rubbish-resoid.lisp")

(defparameter ccc (readskqc "((1 (x) (+ P x))(2 () (- P a)))"))
;(print-clauses ccc)
;(dump-clauses ccc)
(defparameter l11 (car (lidsof (car ccc) 0)))
(defparameter l21 (car (lidsof (cadr ccc) 0)))

(defparameter scc "((16 (x) (+ P x)(- Q x x)(+ R (f x)))(17 (x) (- P a)(- P x)))")
(defparameter ccs (readskqc scc))
;(print-literals (bodyof (car ccs)))

(defito ito-resolve-id ()
  "resolve-id resolve on LID/CID naming"

;; fail
  (defparameter cc2 (readskqc "((3 (x) (+ Q x))(4 () (- Q a))(5 () (+ P a)))"))
  (defparameter l31 (car (lidsof (car cc2) 0)))
  (defparameter l41 (car (lidsof (cadr cc2) 0)))
  (defparameter l51 (car (lidsof (caddr cc2) 0)))

  (intend-equal "resolve-id fail psym mismatch" :FAIL (resolve-id l11 l31))
  (intend-equal "resolve-id fail diff psym diff sing fail" :FAIL (resolve-id l11 l41))
  (intend-equal "resolve-id fail same psym same sign caller should distinguish signs" '((X) (A) NIL) (resolve-id l11 l51))

;; success
;; (()()) is (sigma [])
  (defparameter cc3 (readskqc "((6 (x) (+ P x))(7 () (- P a)))"))
  (defparameter l61 (car (lidsof (car cc3) 0)))
  (defparameter l71 (car (lidsof (cadr cc3) 0)))

  (defparameter cc4 (readskqc "((8 (x) (+ P x))(9 (y) (- P y)))"))
  (defparameter l81 (car (lidsof (car cc4) 0)))
  (defparameter l91 (car (lidsof (cadr cc4) 0)))


  (intend-equal "resolved to [](vars sigs resolvent)" '(() () ()) (resolve-id l21 l51))
  (intend-equal "resolved to []" '((x) (a) ()) (resolve-id l61 l71)) 
  (intend-equal "resolved to []" '((x y) (y y) ()) (resolve-id l81 l91))

  (defparameter cc5 (readskqc "((10 (x) (+ P x)(+ R a))(11 () (- P a)(- Q a)))"))
  (defparameter l101 (car (lidsof (car cc5) 0)))
  (defparameter l111 (car (lidsof (cadr cc5) 0)))

  (defparameter rr5 (resolve-id l101 l111))
  (intend-equal "resolve simple clauses var" '(x) (car rr5))
  (intend-equal "resolve simple clauses sig" '(a) (cadr rr5))
  (intend-equal "resolve simple clauses lits" '((+ R a)(- Q a)) (caddr rr5))
)

(defito ito-resolve-id-all ()
  (ito-resolve-id)
)

(ito-resolve-id-all)


