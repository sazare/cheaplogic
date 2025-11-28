;;; ITO for rubbish-tools.lisp

;(load "load-rubbish.lisp")
;(load "rubbish-tools.lisp")
;(load "rubbish-props.lisp")

;; basics
(ito:defito  ito-tools-basics ()
  "isprefix and sameterm sameterms samelitlit"
  (ito:intend-t "gen var has same prefix" (isprefix "X" "X.234"))
  (ito:intend-t "gen var has same prefix" (isprefix 'X 'X.234))
  
  (ito:intend-f "gen var has not same prefix" (isprefix "y" "X.234"))
  (ito:intend-f "gen var has not same prefix" (isprefix 'y 'X.234))
  (ito:intend-t "gen var has not same prefix" (isprefixs '(y x) '(y.222 X.234)))
  
  (ito:intend-ru-sameterm "fvv" '(x y) '(f x y) '(f x.12 y.123))
  ; this should fail (ito:intend-ru-sameterm "f-g" '(x y) '(f x y) '(g x.2 y.23))
  
  (ito:intend-ru-sameterms "v-v" '(x) '(x (f x)) '(x.23 (f x.234)))
  (ito:intend-ru-sameterms "f-v" '(x y) '((f x y) x) '((f x.2 y.23) x.23))
  (ito:intend-ru-sameterms "ff" '(x y) '((f x y) (g x)) '((f x.2 y.23) (g x.23)))
  
  (ito:intend-ru-samelitlit "litlit" '(x) '(+ P x) '(+ P x.234) )
  (ito:intend-ru-samelitlit "litlit" '(x y) '(+ P x (f y)) '(+ P x.234 (f y.233) ))
)

(ito:defito ito-inputclauses ()
  "ito for reading input clauses"

  (defparameter cc1 (readskqc "((1 (x) (+ P x)(+ R a))(2 () (- P a)(- Q a)))"))
  
  (ito:intend-ru-samelit "except gensym term" '(x) '(+ P x) 'l1-1)
  
  (ito:intend-ru-clause "plist check" 'C1 '(l1-1 l1-2) :name 1 :vars '(x))
  (ito:intend-ru-literal "L1-1 in C1" '(x.)  '(+ P x.) 'L1-1 :OLID 'L1-1 :PLID NIL :CID 'C1)
  (ito:intend-ru-literal "L1-2 in C1" () '(+ R a) 'L1-2 :OLID 'L1-2 :PLID NIL :CID 'C1)
  
  (ito:intend-ru-clause "plist check" 'C2 '(l2-1 l2-2) :name 2 :vars '())
  (ito:intend-ru-literal "L2-1 in C2" '()  '(- P a) 'L2-1 :OLID 'L2-1 :PLID NIL :CID 'C2)
  (ito:intend-ru-literal "L2-2 in C2" () '(- Q a) 'L2-2 :OLID 'L2-2 :PLID NIL :CID 'C2)
  
  (remove-prop 'c1 :vars)
  (ito:intend-equal "no :vars" nil (get 'C1 :vars))
  (ito:intend-equal ":name still exists" 1 (get 'C1 :name))
  (remove-prop 'c1 :name)
  (ito:intend-equal "no :name" nil (get 'C1 :name))
  (remove-props 'l1-1)
  (remove-props 'l1-2)
  (ito:intend-equal "no props" nil (symbol-plist 'l1-1))
  (ito:intend-equal "no props" nil (symbol-plist 'l1-2))
  
  (remove-props 'c2)
  (ito:intend-equal "no props" nil (symbol-plist 'c2))
  (remove-props 'l2-1)
  (remove-props 'l2-2)
  (ito:intend-equal "no props" nil (symbol-plist 'l2-1))
  (ito:intend-equal "no props" nil (symbol-plist 'l2-2))
)

(ito:defito ito-proof-trace ()
  "check proof info" 
  (clearbase)
  
  (defparameter cc50 (readskqc "((50 (x z) (+ P x)(+ R a z)) (51 () (- P a)) (52 (w) (- R w b)))"))
  (defparameter r501 (resolve-id (pickl 1 (nth 0 cc50)) (pickl 0 (nth 2 cc50))))
  (defparameter r502 (resolve-id (pickl 0 r501) (pickl 0 (nth 1 cc50))))
  
  (ito:intend-ru-proof "proof of the contra" r502 :resolution '(X) '(A) 'L53-1 'L51-1)
)

(ito:defito ito-tools-all ()
  "ALL ITOS FOR TOOLS"
  (ito-tools-basics)
  (ito-inputclauses) ;; these should go ito-resoid
  (ito-proof-trace) ;; these should go ito-resoid
)

(ito-tools-all)

 
