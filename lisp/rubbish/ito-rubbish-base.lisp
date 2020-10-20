;; ito-rubbish-base.lisp
;;; 
(format t "ITO-RUBBISH-BASE IS DESCRIBED AS RUBBISH-BASE-NORAN?~%")

(myload "ito.lisp")
(load "rubbish-gen.lisp")
(load "load-rubbish-base.lisp")

(defito ito-setlid ()
  "setlid sets property of lid"
  (defparameter l1 (setlid 'a 'b 'c '(a b c)))
  (intend-equal "plid is" 'c (plidof 'a))
  (intend-equal "olid is" 'a (olidof 'a))
  (intend-equal "cid is" 'b (cidof 'a))
  (intend-equal "lit is" '(a b c) a)
)
  
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


(defito ito-newvar ()
  "newvar "
  (intend-equal "no number" "ABC" (vrootof (newvar 'abc) ))
  (intend-equal "has number" "ABC" (vrootof (newvar 'abc.123) ))
  (intend-equal "has number" "ABC" (vrootof (newvar 'abc.1) ))
)
(defito ito-newvars ()
  "rename is a substition as vs<-vs, is defined as a new vars list. p-not specific"
 
  (intend-equal "number of vars are same" (length ovs) (length nvs))
  (intend-equal "root of names are same" (basesof ovs) (basesof nvs)) 
  (intend-equal "length of names are +4" (+ (length (symbol-name (car ovs))) 4) (length (symbol-name (car nvs))))
)

;;; ito for full spec relations may be here
(defparameter ovs '(x y))
(defparameter nvs (newvars ovs))


(defito ito-vrootof ()
  "root of var"
  (intend-equal "no number" "ABC" (vrootof 'abc) )
  (intend-equal "has number" "ABC" (vrootof 'abc.123) )
  (intend-equal "has number" "ABC" (vrootof 'abc.1) )
)

(defito ito-newvar ()
  "newvar "
  (intend-equal "no number" "ABC" (vrootof (newvar 'abc) ))
  (intend-equal "has number" "ABC" (vrootof (newvar 'abc.123) ))
  (intend-equal "has number" "ABC" (vrootof (newvar 'abc.1) ))
)
(defito ito-newvars ()
  "rename is a substition as vs<-vs, is defined as a new vars list. p-not specific"
 
  (intend-equal "number of vars are same" (length ovs) (length nvs))
  (intend-equal "root of names are same" (basesof ovs) (basesof nvs)) 
  (intend-equal "length of names are +4" (+ (length (symbol-name (car ovs))) 4) (length (symbol-name (car nvs))))
)

;(defito ito-isolatevs ()
; "isolate vars of resolvent"
;  
;  (setf nc (isolatevs '(x y) '((+ P (f x) (g y))(- Q x (h x y)))))
;  (intend-equal "rename vs with new vs" 
;     		'((+ P (f x)(g y))(- Q x (h x y))) 
;                (subsubp (car nc) (cadr nc) '(x y)))
;)


;;
(defito ito-all-base ()
  "tests for base "
  (ito-setlid)
  (ito-make-clause)
  (ito-oppo)
  (ito-newvar)
  (ito-newvars)
)

(ito-all-base)

