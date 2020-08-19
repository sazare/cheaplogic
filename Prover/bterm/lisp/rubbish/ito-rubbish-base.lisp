;; ito-rubbish-base.lisp
;;; 
(format t "ITO-RUBBISH-BASE IS DESCRIBED AS RUBBISH-BASE-NORAN?~%")

(myload "ito.lisp")
(load "rubbish-gen.lisp")
(load "load-rubbish-base.lisp")

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

(defito ito-oppo ()
  "oppo changes sign"
  
  (intend-equal "oppo o - is " '+ (oppo '-))
  (intend-equal "oppo of + is " '- (oppo '+))
  (intend-equal "oppo of neither + nor - is" nil (oppo 'a))
)


(defito ito-all-base ()
  "tests for base "
  (ito-oppo)
  (ito-make-clause)
)

(ito-all-base)

