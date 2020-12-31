;; ITO for prover.lisp
;(myload "ito.lisp"
(load "rubbish-tools.lisp")

(defito ito-olid-corr ()
  "after resolve olid keep "
  (defparameter a1 (readskqc "((1 () (+ A a)(+ B a)(+ C a)(+ D a)(+ E a))(2 () (- A a)) (3 () (- B a))(4 ()(- C a))(5 ()(- D a))(6 () (- E a)))"))

  (defparameter r7 (resolve-id 'L1-1 'L2-1))
  (defparameter r8 (resolve-id 'L7-1 'L3-1))
  (defparameter r9 (resolve-id 'L8-1 'L4-1))
  (defparameter r10 (resolve-id 'L9-1 'L5-1))
  (defparameter r11 (resolve-id 'L10-1 'L6-1))

  (intend-ru-literal "L7-1 in C7" '() '(+ B a) 'L7-1 :OLID 'L1-2 :PLID 'L1-2 :CID 'C7)
  (intend-ru-literal "L7-2 in C7" '() '(+ C a) 'L7-2 :OLID 'L1-3 :PLID 'L1-3 :CID 'C7)
  (intend-ru-literal "L7-3 in C7" '() '(+ D a) 'L7-3 :OLID 'L1-4 :PLID 'L1-4 :CID 'C7)
  (intend-ru-literal "L7-4 in C7" '() '(+ E a) 'L7-4 :OLID 'L1-5 :PLID 'L1-5 :CID 'C7)

  (intend-ru-literal "L8-1 in C8" '() '(+ C a) 'L8-1 :OLID 'L1-3 :PLID 'L7-2 :CID 'C8)
  (intend-ru-literal "L8-2 in C8" '() '(+ D a) 'L8-2 :OLID 'L1-4 :PLID 'L7-3 :CID 'C8)
  (intend-ru-literal "L8-3 in C8" '() '(+ E a) 'L8-3 :OLID 'L1-5 :PLID 'L7-4 :CID 'C8)

  (intend-ru-literal "L9-1 in C9" '() '(+ D a) 'L9-1 :OLID 'L1-4 :PLID 'L8-2 :CID 'C9)
  (intend-ru-literal "L9-2 in C9" '() '(+ E a) 'L9-2 :OLID 'L1-5 :PLID 'L8-3 :CID 'C9)

  (intend-ru-literal "L10-1 in C10" '() '(+ E a) 'L10-1 :OLID 'L1-5 :PLID 'L9-2 :CID 'C10)


  (defparameter r12 (resolve-id 'L8-2 'L5-1))

  (intend-ru-literal "L12-1 in C12" '() '(+ C a) 'L12-1 :OLID 'L1-3 :PLID 'L8-1 :CID 'C12)
  (intend-ru-literal "L12-2 in C12" '() '(+ E a) 'L12-2 :OLID 'L1-5 :PLID 'L8-3 :CID 'C12)

)

(defito ito-prover-all ()
  "ALL ITOS for PROVER"
  (ito-olid-corr)
)

(ito-prover-all)

