;;; ITO for rubbish-tools.lisp

(myload "ito.lisp")
(load "ito-rubbish.lisp")
(load "rubbish-tools.lisp")


(intend-t "gen var has same prefix" (isprefix "X" "X.234"))
(intend-f "gen var has not same prefix" (isprefix "y" "X.234"))
 

(defparameter cc1 (readskqc "((1 (x) (+ P x)(+ R a))(2 () (- P a)(- Q a)))"))

;(setatom  C1 '(l8-1 l8-2) :name 8 :vars (x y))
;(setatom  L1-1 '(+ P x) :OLID L8-1 :PLID NIL :CID C8)
;(setatom  L1-2 '(- Q x (f y)) :OLID L8-2 :PLID NIL :CID C8)

;(setatom  C2 '(l8-1 l8-2) :name 8 :vars (x y))
;(setatom  L2-1 '(+ P x) :OLID L8-1 :PLID NIL :CID C8)
;(setatom  L2-2 '(- Q x (f y)) :OLID L8-2 :PLID NIL :CID C8)

;(intend-ru-clause cc5 C1 '(l1-1 l1-2) :name 1 :vars (x y))
;(dump-clause 'c1)


(intend-ru-clause "plist check" 'C1 '(l1-1 l1-2) :name 1 :vars '(x))
(intend-ru-literal "L1-1 in C1"  'L1-1 '(+ P x.) :OLID 'L1-1 :PLID NIL :CID 'C1)
(intend-ru-literal "L1-2 in C1"  'L1-2 '(+ R a) :OLID 'L1-2 :PLID NIL :CID 'C1)

