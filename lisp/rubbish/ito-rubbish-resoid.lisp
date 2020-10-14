;ito for rubbish-resoid.lisp  (intend-equal "rule is " :reso (ruleof r15))

(myload "ito.lisp")
(load "load-rubbish.lisp")
(load "rubbish-resoid.lisp")
(load "rubbish-proof.lisp")

(clearbase)
(defparameter ccc (readskqc "((1 (x) (+ P x))(2 () (- P a)))"))
;(print-clauses ccc)
;(dump-clauses ccc)
(defparameter l11 (pickl 0 (car ccc) ))
(defparameter l21 (pickl 0 (cadr ccc) ))

(defparameter scc "((16 (x) (+ P x)(- Q x x)(+ R (f x)))(17 (x) (- P a)(- P x)))")
(defparameter ccs (readskqc scc))
;(print-literals (bodyof (car ccs)))

(defito ito-resolve-id ()
  "resolve-id resolve on LID/CID naming"

;; fail
  (defparameter cc2 (readskqc "((3 (x) (+ Q x))(4 () (- Q a))(5 () (+ P a)))"))
  (defparameter l31 (pickl 0 (car cc2)))
  (defparameter l41 (pickl 0 (cadr cc2) ))
  (defparameter l51 (pickl 0 (caddr cc2) ))

  (intend-equal "resolve-id fail psym mismatch" :FAIL (resolve-id l11 l41))
  (intend-equal "resolve-id fail diff psym diff sing fail" :FAIL (resolve-id l11 l41))

  (defparameter r15 (resolve-id l11 l51))
  (intend-equal "resolve-id fail same psym same sign caller should distinguish signs" 
    '(:resolvent () () NIL) (rawclause r15))
  (intend-equal "rule is " :resolution (ruleof r15))
  (intend-equal "sig is x<-a" '((x)(a)) (sigof r15))

;; success
;; (()()) is (sigma [])
;(clearbase)
  (defparameter cc3 (readskqc "((6 (x) (+ P x))(7 () (- P a)))"))
  (defparameter l61 (pickl 0 (car cc3) ))
  (defparameter l71 (pickl 0 (cadr cc3)))

  (defparameter cc4 (readskqc "((8 (x) (+ P x))(9 (y) (- P y)))"))
  (defparameter l81 (pickl 0 (car cc4) ))
  (defparameter l91 (pickl 0 (cadr cc4) ))

  (intend-equal "resolved to [](vars sigs resolvent)" '(:resolvent () () ()) (rawclause (resolve-id l21 l51)))
  (intend-equal "resolved to []" '(:resolvent () () ()) (rawclause (resolve-id l61 l71)) )
  (intend-equal "resolved to []" '(:resolvent (y) () ()) (rawclause (resolve-id l81 l91)))
  (intend-equal "resolved to []" '(:resolvent (x) () ()) (rawclause (resolve-id l91 l81)))

;(clearbase)

  (defparameter cc5 (readskqc "((10 (x) (+ P x)(+ R a))(11 () (- P a)(- Q a)))"))
  (defparameter l101 (pickl 0 (car cc5) ))
  (defparameter l111 (pickl 0 (cadr cc5) ))

  (defparameter rr5 (resolve-id l101 l111))
  
  (intend-equal "resolvent's var is" '() (varsof rr5))
  (intend-equal "resolvent's name is" :resolvent (nameof rr5))
  (intend-equal "sig of l101, l111" '((x)(a)) (sigof rr5))
  (intend-equal "resolve simple clauses lits" '((+ R a)(- Q a)) (rawlits (bodyof rr5)))
  (intend-equal "resolve simple clauses full" '(:resolvent () () ((+ R a)(- Q a))) (rawclause rr5))

;(clearbase)
;  (defparameter cc50 (readskqc "((50 (x z) (+ P x)(+ R a z)) (51 () (- P a)) (52 (w) (- R w b)))"))

)

(defito ito-resolve-id-all ()
  (ito-resolve-id)
)

(ito-resolve-id-all)


