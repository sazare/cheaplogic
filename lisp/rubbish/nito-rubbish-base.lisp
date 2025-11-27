;; ito-rubbish-base.lisp
;;; 
(format t "ITO-RUBBISH-BASE IS DESCRIBED AS RUBBISH-BASE-NORAN?~%")

(in-package :rubbish)

(ito:defito ito-setlid ()
  "setlid sets property of lid"
  (setf (get 'c :olid) 'd)
  (defparameter l1 (setlid 'a 'b 'c '(a b c)))
  (ito:intend-equal "plid is" 'c (plidof 'a))
  (ito:intend-equal "olid is" 'd (olidof 'a))
  (ito:intend-equal "cid is" 'b (cidof 'a))
  (ito:intend-equal "lit is" '(a b c) a)
)
  
(ito:defito ito-make-clause ()
  "make-clause add S-exp clause to base"

  (let
    (c1 c2)
    (setq c1 (make-clause '(1 () (+ P a))))
    (ito:intend-equal "unit name " 1 (nameof c1))
    (ito:intend-equal "unit vars " '() (varsof c1))
    (ito:intend-equal "unit len body" 1 (length (bodyof c1)))
    
   (setq c2 (make-clause '(2 (x) (+ P a)(- Q x y))))
   (ito:intend-equal "1 name is" 2  (nameof c2))
   (ito:intend-equal "1 body is" 2 (length (bodyof c2)))
   (ito:intend-equal "1 bind is" '(x.)   (varsof c2))
   (ito:intend-equal "1 subs is" '()   (subsof c2))
    )
) 

(ito:defito ito-litof ()
  "litof is eval" 
  (let (c1 c2)
    (setq c1 (make-clause '(1 () (+ P a)(- QQ (f x)(g y)))))
    (ito:intend-equal "lit of +" '(+ P a) (litof 'L1-1))
    (ito:intend-equal "lit of -" '(- QQ (f x)(g y)) (litof 'L1-2))
  )
)
 
  
(ito:defito ito-lsymof ()
  "lsymof lid"
  (let (c1 c2)
    (setq c1 (make-clause '(1 () (+ P a)(- QQ (f x)(g y)))))
    (ito:intend-equal "lsym (+ P a)=" '+P (lsymof 'L1-1))
    (ito:intend-equal "lsym (- QQ (fx)(gy))=" '-QQ (lsymof 'L1-2))
  )
)

(ito:defito ito-oppo ()
  "oppo changes sign"
  
  (ito:intend-equal "oppo o - is " '+ (oppo '-))
  (ito:intend-equal "oppo of + is " '- (oppo '+))
  (ito:intend-equal "oppo of neither + nor - is" nil (oppo 'a))
)

(ito:defito ito-soppo ()
  "soppo changes sign over string"
  (ito:intend-equal "soppo o - is " "+" (soppo "-"))
  (ito:intend-equal "soppo of + is " "-" (soppo "+"))
)

(ito:defito ito-oppolsymof ()
  "soppo changes sign over string"
  (ito:intend-equal "oppolsymof -PQ is" '+PQ (oppolsymof '-PQ))
  (ito:intend-equal "oppolsymof of +QR is" '-QR (oppolsymof '+QR))
)


(ito:defito ito-newvar ()
  "newvar "
  (ito:intend-equal "no number" "ABC" (vrootof (newvar 'abc) ))
  (ito:intend-equal "has number" "ABC" (vrootof (newvar 'abc.123) ))
  (ito:intend-equal "has number" "ABC" (vrootof (newvar 'abc.1) ))
)

(ito:defito ito-newvars ()
  "rename is a substition as vs<-vs, is defined as a new vars list. p-not specific"
  (ito:intend-equal "number of vars are same" (length ovs) (length nvs))
  (ito:intend-equal "root of names are same" (basesof ovs) (basesof nvs)) 
)

;;; ito for full spec relations may be here
(defparameter ovs '(x y))
(defparameter nvs (newvars ovs))


(ito:defito ito-vrootof ()
  "root of var"
  (ito:intend-equal "no number" "ABC" (vrootof 'abc) )
  (ito:intend-equal "has number" "ABC" (vrootof 'abc.123) )
  (ito:intend-equal "has number" "ABC" (vrootof 'abc.1) )
)

(ito:defito ito-newvar ()
  "newvar "
  (ito:intend-equal "no number" "ABC" (vrootof (newvar 'abc) ))
  (ito:intend-equal "has number" "ABC" (vrootof (newvar 'abc.123) ))
  (ito:intend-equal "has number" "ABC" (vrootof (newvar 'abc.1) ))
)
(ito:defito ito-newvars ()
  "rename is a substition as vs<-vs, is defined as a new vars list. p-not specific"
 
  (ito:intend-equal "number of vars are same" (length ovs) (length nvs))
  (ito:intend-equal "root of names are same" (basesof ovs) (basesof nvs)) 
)

;(ito:defito ito-isolatevs ()
; "isolate vars of resolvent"
;  
;  (setf nc (isolatevs '(x y) '((+ P (f x) (g y))(- Q x (h x y)))))
;  (ito:intend-equal "rename vs with new vs" 
;     		'((+ P (f x)(g y))(- Q x (h x y))) 
;                (subsubp (car nc) (cadr nc) '(x y)))
;)

(ito:defito ito-cidfy ()
  "cidfy make cid from name"
  (ito:intend-equal "cid is Cn form" 'C12 (cidfy 12))
)

;;
(ito:defito ito-all-base ()
  "TESTS FOR BASE "
  (ito-cidfy)
  (ito-setlid)
  (ito-make-clause)
  (ito-litof)
  (ito-lsymof)
  (ito-oppo)
  (ito-soppo)
  (ito-oppolsymof)
  (ito-newvar)
  (ito-newvars)
)

(ito-all-base)

