;ito for rubbish-resoid.lisp  (intend-equal "rule is " :reso (ruleof r15))

;; this file should be rewritten by tools

;(myload "ito.lisp")
(load "rubbish-tools.lisp")
(load "load-rubbish.lisp")
;(load "load-rubbish-noran.lisp")

(load "rubbish-resoid.lisp")
(load "rubbish-proof.lisp")


(defito ito-resolve-id ()
  "resolve-id resolve on LID/CID naming"

  (defparameter ccc (readskqc "((1 (x) (+ P x))(2 () (- P a)))"))
  ;(print-clauses ccc)
  ;(dump-clauses ccc)
  (defparameter l11 (pickl 0 (car ccc) ))
  (defparameter l21 (pickl 0 (cadr ccc) ))


;; fail
  (defparameter cc2 (readskqc "((3 (x) (+ Q x))(4 () (- Q a))(5 () (+ P a)))"))
  (defparameter l31 (pickl 0 (car cc2)))
  (defparameter l41 (pickl 0 (cadr cc2) ))
  (defparameter l51 (pickl 0 (caddr cc2) ))

  (intend-equal "resolve-id fail psym mismatch" :FAIL (resolve-id l11 l41))
  (intend-equal "resolve-id fail diff psym diff sing fail" :FAIL (resolve-id l11 l41))

;; success
;; reso to contra
  (defparameter r15 (resolve-id l11 l51))
  (intend-ru-clause "is contradiction" r15 () :name :resolvent )
  (intend-ru-proof "rule is resolution" r15 :RESOLUTION '(X) '(A) 'L1-1 'L5-1 )

;(clearbase)
  (defparameter cc3 (readskqc "((6 (x) (+ P x))(7 () (- P a)))"))
  (defparameter l61 (pickl 0 (car cc3) ))
  (defparameter l71 (pickl 0 (cadr cc3)))

  (defparameter cc4 (readskqc "((8 (x) (+ P x))(9 (y) (- P y)))"))
  (defparameter l81 (pickl 0 (car cc4) ))
  (defparameter l91 (pickl 0 (cadr cc4) ))


  (defparameter r25 (resolve-id l21 l51))
  (intend-ru-clause "identical atoms" r25 () :name :resolvent)
  (intend-ru-proof "proof of c2-1 c5-1" r25 :resolution () () 'L2-1 'L5-1)


  (defparameter r67 (resolve-id l61 l71) )
  (intend-ru-clause "identical atoms" r67 () :name :resolvent)
  (intend-ru-proof "proof of c2-1 c5-1" r67 :resolution () () l61 l71)

  (defparameter r89 (resolve-id l81 l91) )
  (intend-ru-clause "before switch order" r89 () :name :resolvent)
  (intend-ru-proof "proof of c8-1 c9-1" r89 :resolution () () l81 l91)

  (defparameter r98 (resolve-id l91 l81) )
  (intend-ru-clause "switch order of resolve" r98 () :name :resolvent)
  (intend-ru-proof "proof of c9-1 c8-1" r98 :resolution () () l91 l81)

  (clearbase)

  (defparameter cc5 (readskqc "((15 (x) (+ P x)(+ R a))(16 () (- P a)(- Q a)))"))
  (defparameter l101 (pickl 0 (car cc5) ))
  (defparameter l111 (pickl 0 (cadr cc5) ))

  (defparameter rr5 (resolve-id l101 l111))
  
  (intend-ru-clause "resolvent" rr5 '(L17-1 L17-2) :name :resolvent)
  (intend-ru-proof "proof of l15-1 l16-1" rr5 :resolution '(x) '(a) l101 l111)



;(clearbase)
;  (defparameter cc50 (readskqc "((50 (x z) (+ P x)(+ R a z)) (51 () (- P a)) (52 (w) (- R w b)))"))

  (defparameter cc70 (readskqc "((171 (x) (+ P x x)) (172 () (- P a a)))"))
  (defparameter r173 (resolve-id 'l171-1 'l172-1))
  (intend-ru-clause "contradiction c171 and c172" r173 () :name :resolvent)
  (intend-ru-proof "proof of 171 and 172" r173 :resolution () () 'l171-1 'l172-1)

)

(defito ito-resolve-id-all ()
  (ito-resolve-id)
)

(ito-resolve-id-all)


