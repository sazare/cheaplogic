;;; ITO for rubbish-tools.lisp

(myload "ito.lisp")
;;(load "load-rubbish.lisp")
;(load "rubbish-tools.lisp")

;; basics
(defito  ito-tools-basics ()
  "isprefix and sameterm sameterms samelitlit"
  (intend-t "gen var has same prefix" (isprefix "X" "X.234"))
  (intend-t "gen var has same prefix" (isprefix 'X 'X.234))
  
  (intend-f "gen var has not same prefix" (isprefix "y" "X.234"))
  (intend-f "gen var has not same prefix" (isprefix 'y 'X.234))
  (intend-t "gen var has not same prefix" (isprefixs '(y x) '(y.222 X.234)))
  
  (intend-ru-sameterm "fvv" '(x y) '(f x y) '(f x.12 y.123))
  ; this should fail (intend-ru-sameterm "f-g" '(x y) '(f x y) '(g x.2 y.23))
  
  (intend-ru-sameterms "v-v" '(x) '(x (f x)) '(x.23 (f x.234)))
  (intend-ru-sameterms "f-v" '(x y) '((f x y) x) '((f x.2 y.23) x.23))
  (intend-ru-sameterms "ff" '(x y) '((f x y) (g x)) '((f x.2 y.23) (g x.23)))
  
  (intend-ru-samelitlit "litlit" '(x) '(+ P x) '(+ P x.234) )
  (intend-ru-samelitlit "litlit" '(x y) '(+ P x (f y)) '(+ P x.234 (f y.233) ))
)

(defito ito-inputclauses ()
  "ito for reading input clauses"

  (defparameter cc1 (readskqc "((1 (x) (+ P x)(+ R a))(2 () (- P a)(- Q a)))"))
  
  (intend-ru-samelit "except gensym term" '(x) '(+ P x) 'l1-1)
  
  (intend-ru-clause "plist check" 'C1 '(l1-1 l1-2) :name 1 :vars '(x))
  (intend-ru-literal "L1-1 in C1" '(x.)  '(+ P x.) 'L1-1 :OLID 'L1-1 :PLID NIL :CID 'C1)
  (intend-ru-literal "L1-2 in C1" () '(+ R a) 'L1-2 :OLID 'L1-2 :PLID NIL :CID 'C1)
  
  (intend-ru-clause "plist check" 'C2 '(l2-1 l2-2) :name 2 :vars '())
  (intend-ru-literal "L2-1 in C2" '()  '(- P a) 'L2-1 :OLID 'L2-1 :PLID NIL :CID 'C2)
  (intend-ru-literal "L2-2 in C2" () '(- Q a) 'L2-2 :OLID 'L2-2 :PLID NIL :CID 'C2)
  
  (remove-prop 'c1 :vars)
  (intend-equal "no :vars" nil (get 'C1 :vars))
  (intend-equal ":name still exists" 1 (get 'C1 :name))
  (remove-prop 'c1 :name)
  (intend-equal "no :name" nil (get 'C1 :name))
  (remove-props 'l1-1)
  (remove-props 'l1-2)
  (intend-equal "no props" nil (symbol-plist 'l1-1))
  (intend-equal "no props" nil (symbol-plist 'l1-2))
  
  (remove-props 'c2)
  (intend-equal "no props" nil (symbol-plist 'c2))
  (remove-props 'l2-1)
  (remove-props 'l2-2)
  (intend-equal "no props" nil (symbol-plist 'l2-1))
  (intend-equal "no props" nil (symbol-plist 'l2-2))
)

(defito ito-proof-trace ()
  "check proof info" 
  (clearbase)
  
  (defparameter cc50 (readskqc "((50 (x z) (+ P x)(+ R a z)) (51 () (- P a)) (52 (w) (- R w b)))"))
  (defparameter r501 (resolve-id (pickl 1 (nth 0 cc50)) (pickl 0 (nth 2 cc50))))
  (defparameter r502 (resolve-id (pickl 0 r501) (pickl 0 (nth 1 cc50))))
  
  (intend-ru-proof "proof of the contra" r502 :resolution '(X) '(A) 'L53-1 'L51-1)
)

(defito ito-tools-all ()
  "ALL ITOS FOR TOOLS"
  (ito-tools-basics)
  (ito-inputclauses) ;; these should go ito-resoid
  (ito-proof-trace) ;; these should go ito-resoid
)

(ito-tools-all)

 
