;; ito unify for classic

(load "load-classic.lisp")

(myload "ito.lisp")


(defito ito-isvar ()
  (intend-notequal "1 isvar" NIL (isvar '(x y) 'x))
  (intend-equal "2 not isvar" NIL (isvar '(x y) 'a))
  (intend-equal "3 not isvar" NIL (isvar '(x y) '(f x)))
)

(defito ito-psubst()
  "ito subst"
  (intend-equal "1 no match" 'w (psubst '() 'w))
  (intend-equal "2 no match" 'w (psubst '((y . x)(z . x)) 'w))
  (intend-equal "3 match y" 'x (psubst '((y . x)(z . x)) 'y))
  (intend-equal "4 match z" 'x (psubst '((y . x)(z . x)) 'z))

  (intend-equal "5 match y to f(x)" '(f x) (psubst '((y . (f x))(z . x)) 'y))
  (intend-equal "6 match z to f(x)" '(f x) (psubst '((y . x)(z . (f x))) 'z))
)

(defito ito-psubst*()
  "ito psubst*"

  (intend-equal "1 single sigma" 
          '(f y y)
          (psubst* '((x . y)) '(f x y))
  )
  (intend-equal "2 double sigma" '(g y (h (f y)))
	    (psubst* '((x . y)(z . (f y))) '(g x (h z)))
   )
  (intend-equal "3 cyclic sigma" '(g y (h (f y)))
	    (psubst* '((x . y)(z . (f y))(y . (g x))) '(g x (h z)))
   )
  (intend-equal "4 cyclic sigma fail" '(g y (h (g x)(f y)))
	    (psubst* '((x . y)(y . (g x))(z . (f y))) '(g x (h y z)))
   )
  (intend-equal "5 seq psubst dont depends on the order of sigma(after)"
          '(g (f y) a)
          (psubst* '((x . (f y))(y . a)) '(g x y))
  )
  (intend-equal "6 psubst depends on the order of sigma(before) never happen. but ok with unify"
          '(g (f y) a)
          (psubst* '((y . a)(x . (f y))) '(g x y))
  )

)

(defito ito-disagree()
  "how disagree works"
  (intend-equal "1 identical atom" '() (disagree 'x 'x))
  (intend-equal "2 identical " '() (disagree  '(f x y) '(f x y)))
  (intend-equal "3 identical " '((h z) . x) (disagree '(f (h z) (g y)) '(f x (g z))))
  (intend-equal "4 identical " '(x . (h x)) (disagree  '(f x (g y)) '(f (h x) (g z))))
  (intend-equal "5 identical " '((g z) . (h x)) (disagree  '(f (g z) (g y)) '(f (h x) (g z))))
  (intend-equal "6 identical " '(y . z) (disagree '(f (g y) (g z))  '(f (g z) (g z))))
)

(defito ito-switcher ()
  "how swictcher works, but this should be an implementation"
   (intend-equal "1 " '(x . a) (switcher '(x y) '(x . a)))
   (intend-equal "2 " '(x . a) (switcher '(x y) '(a . x)))
   (intend-equal "3 " '(x . (f z)) (switcher '(x y) '(x . (f z))))
   (intend-equal "4 " '(x . (f z)) (switcher '(x y) '((f z) . x)))

)

(defito ito-insidep ()
  "insidep works"
  (intend-equal "1 not x in x var" NIL (insidep  'x 'x))
  (intend-equal "2 not x in x const" NIL (insidep  'a 'x))
  (intend-equal "3 x in f(x)" T (insidep  'x '(f x)))
  (intend-equal "4 x in f(y,x)" T (insidep  'x '(f y x)))
  (intend-equal "5 x in f(a,b)" NIL (insidep  'x '(f a b)))
  (intend-equal "6 x in f(g(x))" T (insidep  'x '(f (g x))))
  (intend-equal "7 x in f(g(y),h(x))" T (insidep  'y '(f (g y)(g x))))
  (intend-equal "8 x in f(g(y),h(x))" T (insidep  'x '(f (g y)(g x))))
  (intend-equal "9 x in f(a, g(x))" T (insidep  'x '(f a (g x))))
)

(defito ito-unify ()
  "ito unify on symbol"
  (intend-equal "1 identical symbolv" '() (unify '(x) 'x 'x))
  (intend-equal "2 identical symbolc" '() (unify '(x) 'a 'a))
)
(defito ito-unify-se ()
  "ito unify on symbol with expression"
  (intend-equal "1 identical fterm" '() (unify '(x) '(f x) '(f x)))
  (intend-equal "2 symbol unify" '((x . y)) (unify '(x y) 'x 'y))
  (intend-equal "3 fterm unify1" '((x . (f y))) (unify '(x y) 'x '(f y)))
  (intend-equal "4 fterm unify2" '((x . (f y))) (unify '(x y) '(f y) 'x))
  (intend-equal "5 fterm unify3" '((x . (f y))) (unify '(x y) '(h (f y)) '(h x)))
  (intend-equal "6 fterm unify4" '((x . (f y))) (unify '(x y) '(h x) '(h (f y))))

  (intend-equal "7 fterm unify5" '((w . a)(x . (f y))) (unify '(x y w) '(h x a) '(h (f y) w)))
)
(defito ito-unify-inside-ok ()
  "ito unify on inside ok"
  (intend-equal "1 unmatch syms" 'NO (unify '(x) 'a 'b))
  (intend-equal "2 unmatch sym-term" 'NO (unify '(x) 'a '(f x)))
  (intend-equal "3 unmatch term-sym" 'NO (unify '(x) '(f x) 'b))
  (intend-equal "4 unmatch f-g" 'NO (unify '(x y) '(f x) '(g y)))
  (intend-equal "5 unmatch f-g in h" 'NO (unify '(x y) '(h (f x)) '(h (g y))))
)

;(defito ito-unify-inside-ng ()
;
;  (intend-equal "5 fterm unify inside" '((y . (f y))) (unify '(y) 'y '(f y)))
;
;
;;;; What I should ito??
;  (intend-equal "10 order of e make y to a?" '((x . (f a))(y . a)) (unify '(x y) '(f a x) '(f y (f y))))
;  (intend-equal "11 order of e keep y?" '((x . (f a))(y . a)) (unify '(x y) '(f x a) '(f (f y) y)))
;
;  (intend-equal "12 " '((x . (g a))(y . a)) (unify '(x y) '(f x a) '(f (g y) y)))
;  (intend-equal "13 " '((x . (g a))(y . a)) (unify '(x y) '(f a x) '(f y (g y))))
;)

;(defito ito-unify-complex ()
;  "ito unify complicated"
;  (intend-equal "1 fterm unify" '((w . (f y))(x . (f y))) (unify '(x y w) '(h x x) '(h (f y) w)))
;  (intend-equal "2 right to left" '((x . (g (h w)))(y . (h w))) (unify '(x y w) '(f (h w) x) '(f y (g y))))
;  (intend-equal "3 single step of unif for left to right" '((x . (g y))) (unify '(x y ) '(f x) '(f (g y))))
;  (intend-equal "4 left to right(need par subst)" '((x . (g (h w)))(y . (h w))) (unify '(x y w) '(f x (h w)) '(f (g y) y)))
;)
;
;(defito ito-sunify ()
;  "ito sunify"
;  (intend-equal "1 identical symbolv" '() (sunify '(x) 'x 'x))
;  (intend-equal "2 identical symbolc" '() (sunify '(x) 'a 'a))
;  (intend-equal "3 identical fterm" '() (sunify '(x) '(f x) '(f x)))
;  (intend-equal "4 symbol sunify" '((x . y)) (sunify '(x y) 'x 'y))
;  (intend-equal "5 fterm sunify1" '((x . (f y))) (sunify '(x y) 'x '(f y)))
;  (intend-equal "6 fterm sunify2" '((x . (f y))) (sunify '(x y) '(f y) 'x))
;  (intend-equal "7 fterm sunify3" '((x . (f y))) (sunify '(x y) '(h (f y)) '(h x)))
;  (intend-equal "8 fterm sunify4" '((x . (f y))) (sunify '(x y) '(h x) '(h (f y))))
;  (intend-equal "9 fterm sunify5" '((w . a)(x . (f y))) (sunify '(x y w) '(h a x) '(h w (f y))))
;  (intend-equal "10 fterm sunify5" '((x . (f y))(w . a)) (sunify '(x y w) '(h x a) '(h (f y) w)))
;)
;
;;; sunify is sequential unify. it needs sequential substitution
;(defito ito-sunify-complex ()
;  "ito sunify complicated"
;  (intend-equal "1 fterm sunify" '((x . (f y))(w . (f y))) (sunify '(x y w) '(h x x) '(h (f y) w)))
;  (intend-equal "2 right to left" '((y . (h w))(x . (g (h w)))) (sunify '(x y w) '(f (h w) x) '(f y (g y))))
;  (intend-equal "3 single step of unif for left to right" '((x . (g y))) (sunify '(x y ) '(f x) '(f (g y))))
;  (intend-equal "4 left to right" '((x . (g y))(y . (h w))) (sunify '(x y w) '(f x (h w)) '(f (g y) y)))
;
;;;; What I should ito??
;  (intend-equal "5 order of e make y to a?" '((y . a)(x . (f a))) (sunify '(x y) '(f a x) '(f y (f y))))
;
;  (intend-equal "6 order of e keep y?" '((x . (f y))(y . a)) (sunify '(x y) '(f x a) '(f (f y) y)))
;
;;;; unify correct
;  (intend-equal "7 unify(5) correct" T (equal (subst* '((y . a)(x . (f a))) '(f a x))
;                                              (subst* '((y . a)(x . (f a))) '(f y (f y)))))
;  (intend-equal "8 unify(6) correct" T (equal (subst* '((x . (f y))(y . a)) '(f x a))
;                                               (subst* '((x . (f y))(y . a)) '(f (f y) y))))
;
;;;; args changed but be ok.
;  (intend-equal "9 2 different sigmas are same?" T (equal (subst* '((y . a)(x . (f a))) '(f a x))
;                                                          (subst* '((x . (f y))(y . a)) '(f a x))))
;
;  (intend-equal "10 2 different sigmas are same?" T (equal (subst* '((y . a)(x . (f a))) '(f y (f y)))
;                                                          (subst* '((x . (f y))(y . a)) '(f y (f y)))))
;
;  (intend-notequal "11 " '((x . (g a))(y . a)) (sunify '(x y) '(f x a) '(f (g y) y)))
;  (intend-equal "11n " '((x . (g y))(y . a)) (sunify '(x y) '(f x a) '(f (g y) y)))
;  (intend-equal "12 " '((y . a)(x . (g a))) (sunify '(x y) '(f a x) '(f y (g y))))
;  (intend-equal "13 11's mgu is not 12's mgu. but it's a mgu" T 
;                             (equal (subst* '((x . (g y))(y . a)) '(f x a))
;                                    (subst* '((x . (g y))(y . a)) '(f (g y) y))))
;)


(defito ito-all ()
  (ito-set "ancient uification"
    (ito-isvar)
    (ito-psubst)
    (ito-psubst*)
    (ito-disagree)
    (ito-switcher)
    (ito-insidep)
    (ito-unify)
    (ito-unify-se)
    (ito-unify-inside-ok)
;    (ito-unify-complex)
;    (ito-sunify)
;    (ito-sunify-complex)
  )
)

(ito-all)

