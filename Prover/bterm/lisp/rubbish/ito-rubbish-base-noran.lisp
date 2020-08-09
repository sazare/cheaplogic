;; ito-rubbish-base.lisp
;;; 

(myload "ito.lisp")
(load "rubbish-gen-noran.lisp")
(load "load-rubbish-base.lisp")

;(defito ito-almostequal ()
;  "equal without gensym difference"
;  (intend-equal "same without gensym" (gensym "X10_1.") (gensym "X10_1."))
;  (intend-equal "diff gensym difference sym" (gensym "X10_1:") (gensym "X10_1."))
;  (intend-equal "gensym" (gensym "X10_1:") (gensym "X10_1:"))
;)

(defito ito-types ()
  "syntax types"
  (intend-t "atom is a term" (isterm 'abc))
  (intend-t "integer is a term" (isterm 1234))
  (intend-t "float is a term" (isterm 12.34))
  (intend-t "string is a term" (isterm "abcd"))
  (intend-t "(f . args) is a term" (isterm '(f x (g y))))
)

(defito ito-addclause ()
  "addclause add S-exp clause to base"

  (let* 
     ((C1 `(:cid C1 :vars (x y) :body (L1_1 L1_2))))
;   (addclause '(1 () (+ P a))))
;   (intend-equal "C1is" '(:vars '() :body '(L1-1:)) C1:)

; (addclause '(2 (x) (+ P a)(- Q x y)))
   (intend-equal "1 body is" '(L1_1 L1_2) (bodyof *c1*))
   (intend-equal "1 bind is" '()   (bindof *c1*))
   (intend-equal "1 subs is" '()   (subsof *c1*))
    )
) 

(defito ito-all-base ()
  "tests for base "
  (ito-types)
;  (ito-almostequal)
;  (ito-addclause)
)

(ito-all-base)

