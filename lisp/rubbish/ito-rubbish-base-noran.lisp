;; ito-rubbish-base-noran.lisp
;;; 

(myload "ito.lisp")
(load "rubbish-gen-noran.lisp")
(load "load-rubbish-base.lisp")

(defito ito-types ()
  "syntax types"
  (intend-t "atom is a term" (isterm 'abc))
  (intend-t "integer is a term" (isterm 1234))
  (intend-t "float is a term" (isterm 12.34))
  (intend-t "string is a term" (isterm "abcd"))
  (intend-t "(f . args) is a term" (isterm '(f x (g y))))
)

(defito ito-make-literal ()
  "make lid contain props, return lid"
   (let (cid1 lid1 cid2 lids l1 l2)
    (setq cid1 (make-cid 1))
    (setq lid1   (make-lids cid1 '((+ P x))))
    (intend-eq "cid unit" cid1 (cidof (car lid1)))
 
    (setq cid2 (make-cid 2))
    (setq lids (make-lids cid2 '((+ P x)(- Q x y))))
     ;; cid2, l1,l2 are id's
    (setq l1 (car lids))
    (setq l2 (cadr lids))
    (intend-eq "cid 2lit1" cid2 (cidof l1))
    (intend-eq "cid 2lit2" cid2 (cidof l2))
    (intend-equal "lit 2lit1" '(+ P x) (litof l1))
    (intend-equal "lit 2lit2" '(- Q x y) (litof l2))
    (intend-equal "lits of lit*of" '((+ P x)(- Q x y)) (lit*of lids))
  )
)


(defito ito-make-clause ()
  "make-literal should do linking of cid, lids"

  (let 
    (C1 c2)
    (setq C1 (make-clause '(1 () (+ P a))))

    (intend-equal "name of 1" 1   (nameof c1))
    (intend-equal "vars of 1" '() (varsof c1))
    (intend-equal "num body of 1" 1  (length (bodyof c1)))
    (intend-equal "subs of 1" '() (subsof c1))

    (intend-equal "lit of l1.1" '(+ P a) (litof (car (bodyof c1))))
    (intend-eq "cid of l1.1" c1 (cidof (car (bodyof c1))))

    (setq c2 (make-clause '(2 (x y) (+ P a)(- Q x y))))
    (intend-equal "2 name is" 2      (nameof c2))
    (intend-equal "2 num body is" 2 (length (bodyof c2)))
    (intend-equal "2 vars is" '(x. y.) (varsof c2))
    (intend-equal "2 subs is" '()    (subsof c2))

    (intend-equal "lit of l2.1" '(+ P a) (litof (nth 0 (bodyof c2))))
    (intend-eq "cid of l2.1" c2 (cidof (nth 0 (bodyof c2))))
    (intend-equal "lit of l2.2" '(- Q x. y.) (litof (nth 1 (bodyof c2))))
    (intend-eq "cid of l2.2" c2 (cidof (nth 1 (bodyof c2))))
  )
) 

(defito ito-all-base ()
  "tests for base "
  (ito-types)
  (ito-make-literal)
  (ito-make-clause)
)

(ito-all-base)

