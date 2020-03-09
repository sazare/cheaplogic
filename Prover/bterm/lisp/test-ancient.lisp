;; test unify for ancient

(load "load-ancient.lisp")

(load "test.lisp")
;; primitives
(deftest test-isvar ()
  (expect-notequal "1 isvar" NIL (isvar '(x y) 'x))
  (expect-equal "2 not isvar" NIL (isvar '(x y) 'a))
  (expect-equal "3 not isvar" NIL (isvar '(x y) '(f x)))
)

;; (subst t v expr)

(deftest test-simplesubst*()
  "simple subst*"
  (expect-equal "1 single sigma" 
          '(f y y)
          (subst* '((x . y)) '(f x y))
  )
  (expect-equal "2 double sigma" '(g y (h (f y)))
	    (subst* '((x . y)(z . (f y))) '(g x (h z)))
   )

  (expect-equal "3 cyclic sigma" '(g (g x) (h (f (g x))))
	    (subst* '((x . y)(z . (f y))(y . (g x))) '(g x (h z)))
   )

  (expect-notequal "4 cyclic sigma fail" '(g (g x) (h (f (g x))))
	    (subst* '((x . y)(y . (g x))(z . (f y))) '(g x (h z)))
   )

  (expect-equal "5 seq subst depends on the order of sigma(after)"
          '(g (f a) a)
          (subst* '((x . (f y))(y . a)) '(g x y))
  )
  (expect-notequal "6 subst depends on the order of sigma(before) never happen. but ok with unify"
          '(g (f a) a)
          (subst* '((y . a)(x . (f y))) '(g x y))
  )

)

(deftest test-disagree()
  "how disagree works"
  (expect-equal "1 identical atom" '() (disagree 'x 'x))
  (expect-equal "2 identical " '() (disagree  '(f x y) '(f x y)))
  (expect-equal "3 identical " '((h z) . x) (disagree '(f (h z) (g y)) '(f x (g z))))
  (expect-equal "4 identical " '(x . (h x)) (disagree  '(f x (g y)) '(f (h x) (g z))))
  (expect-equal "5 identical " '((g z) . (h x)) (disagree  '(f (g z) (g y)) '(f (h x) (g z))))
  (expect-equal "6 identical " '(y . z) (disagree '(f (g y) (g z))  '(f (g z) (g z))))
)

(deftest test-switcher ()
  "how swictcher works, but this should be an implementation"

   (expect-equal "1 " '(x . a) (switcher '(x y) '(x . a)))
   (expect-equal "2 " '(x . a) (switcher '(x y) '(a . x)))
   (expect-equal "3 " '(x . (f z)) (switcher '(x y) '(x . (f z))))
   (expect-equal "4 " '(x . (f z)) (switcher '(x y) '((f z) . x)))

)

(deftest test-insidep ()
  (expect-equal "1 not x in x var" NIL (insidep  'x 'x))
  (expect-equal "2 not x in x const" NIL (insidep  'a 'x))
  (expect-equal "3 x in f(x)" T (insidep  'x '(f x)))
  (expect-equal "4 x in f(y,x)" T (insidep  'x '(f y x)))
  (expect-equal "5 x in f(a,b)" NIL (insidep  'x '(f a b)))
  (expect-equal "6 x in f(g(x))" T (insidep  'x '(f (g x))))
  (expect-equal "7 x in f(g(y),h(x))" T (insidep  'y '(f (g y)(g x))))
  (expect-equal "8 x in f(g(y),h(x))" T (insidep  'x '(f (g y)(g x))))
  (expect-equal "9 x in f(a, g(x))" T (insidep  'x '(f a (g x))))
)

(deftest test-unify ()
  "test unify"
  (expect-equal "1 identical symbolv" '() (unify '(x) 'x 'x))
  (expect-equal "2 identical symbolc" '() (unify '(x) 'a 'a))
  (expect-equal "3 identical fterm" '() (unify '(x) '(f x) '(f x)))
  (expect-equal "4 symbol unify" '((x . y)) (unify '(x y) 'x 'y))
  (expect-equal "5 fterm unify1" '((x . (f y))) (unify '(x y) 'x '(f y)))
  (expect-equal "6 fterm unify2" '((x . (f y))) (unify '(x y) '(f y) 'x))
  (expect-equal "7 fterm unify3" '((x . (f y))) (unify '(x y) '(h (f y)) '(h x)))
  (expect-equal "8 fterm unify4" '((x . (f y))) (unify '(x y) '(h x) '(h (f y))))
  (expect-equal "9 fterm unify5" '((w . a)(x . (f y))) (unify '(x y w) '(h x a) '(h (f y) w)))

;;; What I should test??
  (expect-equal "10 order of e make y to a?" '((x . (f a))(y . a)) (unify '(x y) '(f a x) '(f y (f y))))
  (expect-equal "11 order of e keep y?" '((x . (f a))(y . a)) (unify '(x y) '(f x a) '(f (f y) y)))

  (expect-equal "12 " '((x . (g a))(y . a)) (unify '(x y) '(f x a) '(f (g y) y)))
  (expect-equal "13 " '((x . (g a))(y . a)) (unify '(x y) '(f a x) '(f y (g y))))
)


(deftest test-unify-complex ()
  "test unify complicated"
  (expect-equal "1 fterm unify" '((w . (f y))(x . (f y))) (unify '(x y w) '(h x x) '(h (f y) w)))
  (expect-equal "2 right to left" '((x . (g (h w)))(y . (h w))) (unify '(x y w) '(f (h w) x) '(f y (g y))))
  (expect-equal "3 single step of unif for left to right" '((x . (g y))) (unify '(x y ) '(f x) '(f (g y))))
  (expect-equal "4 left to right(need par subst)" '((x . (g (h w)))(y . (h w))) (unify '(x y w) '(f x (h w)) '(f (g y) y)))
)

(deftest test-sunify ()
  "test sunify"
  (expect-equal "1 identical symbolv" '() (sunify '(x) 'x 'x))
  (expect-equal "2 identical symbolc" '() (sunify '(x) 'a 'a))
  (expect-equal "3 identical fterm" '() (sunify '(x) '(f x) '(f x)))
  (expect-equal "4 symbol sunify" '((x . y)) (sunify '(x y) 'x 'y))
  (expect-equal "5 fterm sunify1" '((x . (f y))) (sunify '(x y) 'x '(f y)))
  (expect-equal "6 fterm sunify2" '((x . (f y))) (sunify '(x y) '(f y) 'x))
  (expect-equal "7 fterm sunify3" '((x . (f y))) (sunify '(x y) '(h (f y)) '(h x)))
  (expect-equal "8 fterm sunify4" '((x . (f y))) (sunify '(x y) '(h x) '(h (f y))))
  (expect-equal "9 fterm sunify5" '((w . a)(x . (f y))) (sunify '(x y w) '(h a x) '(h w (f y))))
  (expect-equal "10 fterm sunify5" '((x . (f y))(w . a)) (sunify '(x y w) '(h x a) '(h (f y) w)))
)

;; sunify is sequential unify. it needs sequential substitution
(deftest test-sunify-complex ()
  "test sunify complicated"
  (expect-equal "1 fterm sunify" '((x . (f y))(w . (f y))) (sunify '(x y w) '(h x x) '(h (f y) w)))
  (expect-equal "2 right to left" '((y . (h w))(x . (g (h w)))) (sunify '(x y w) '(f (h w) x) '(f y (g y))))
  (expect-equal "3 single step of unif for left to right" '((x . (g y))) (sunify '(x y ) '(f x) '(f (g y))))
  (expect-equal "4 left to right" '((x . (g y))(y . (h w))) (sunify '(x y w) '(f x (h w)) '(f (g y) y)))

;;; What I should test??
  (expect-equal "5 order of e make y to a?" '((y . a)(x . (f a))) (sunify '(x y) '(f a x) '(f y (f y))))

  (expect-equal "6 order of e keep y?" '((x . (f y))(y . a)) (sunify '(x y) '(f x a) '(f (f y) y)))

;;; unify correct
  (expect-equal "7 unify(5) correct" T (equal (subst* '((y . a)(x . (f a))) '(f a x))
                                              (subst* '((y . a)(x . (f a))) '(f y (f y)))))
  (expect-equal "8 unify(6) correct" T (equal (subst* '((x . (f y))(y . a)) '(f x a))
                                               (subst* '((x . (f y))(y . a)) '(f (f y) y))))

;;; args changed but be ok.
  (expect-equal "9 2 different sigmas are same?" T (equal (subst* '((y . a)(x . (f a))) '(f a x))
                                                          (subst* '((x . (f y))(y . a)) '(f a x))))

  (expect-equal "10 2 different sigmas are same?" T (equal (subst* '((y . a)(x . (f a))) '(f y (f y)))
                                                          (subst* '((x . (f y))(y . a)) '(f y (f y)))))

  (expect-notequal "11 " '((x . (g a))(y . a)) (sunify '(x y) '(f x a) '(f (g y) y)))
  (expect-equal "11n " '((x . (g y))(y . a)) (sunify '(x y) '(f x a) '(f (g y) y)))
  (expect-equal "12 " '((y . a)(x . (g a))) (sunify '(x y) '(f a x) '(f y (g y))))
  (expect-equal "13 11's mgu is not 12's mgu. but it's a mgu" T 
                             (equal (subst* '((x . (g y))(y . a)) '(f x a))
                                    (subst* '((x . (g y))(y . a)) '(f (g y) y))))
)

(deftest test-all ()
  (test-set "ancient uification"
    (test-isvar)
    (test-simplesubst*)
    (test-disagree)
    (test-switcher)
    (test-insidep)
    (test-unify)
    (test-unify-complex)
    (test-sunify)
    (test-sunify-complex)
  )
)

(test-all)

