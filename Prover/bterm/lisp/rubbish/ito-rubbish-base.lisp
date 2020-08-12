;; ito-rubbish-base.lisp
;;; 
(format t "ITO-RUBBISH-BASE IS DESCRIBED AS RUBBISH-BASE-NORAN?~%")

(myload "ito.lisp")
(load "rubbish-gen.lisp")
(load "load-rubbish-base.lisp")


;(defito ito-types ()
;  "syntax types"
;  (intend-t "atom is a term" (isterm 'abc))
;  (intend-t "integer is a term" (isterm 1234))
;  (intend-t "float is a term" (isterm 12.34))
;  (intend-t "string is a term" (isterm "abcd"))
;  (intend-t "(f . args) is a term" (isterm '(f x (g y))))
;)

(defito ito-make-clause ()
  "make-clause add S-exp clause to base"

  (let
    (c1 c2)
    (setq c1 (make-clause '(1 () (+ P a))))
    (intend-equal "unit name " 1 (nameof c1))
    (intend-equal "unit vars " '() (varsof c1))
    (intend-equal "unit len body" 1 (length (bodyof c1)))
    
   (setq c2 (make-clause '(2 (x) (+ P a)(- Q x y))))
   (intend-equal "1 name is" 2  (nameof c2))
   (intend-equal "1 body is" 2 (length (bodyof c2)))
   (intend-equal "1 bind is" '(x)   (varsof c2))
   (intend-equal "1 subs is" '()   (subsof c2))
    )
) 

(defito ito-all-base ()
  "tests for base "
;  (ito-types)
  (ito-make-clause)
)

(ito-all-base)

