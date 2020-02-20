;; test for unify function

(load "test.lisp")

;; primitives
(deftest test-isvar ()
  (expect-notequal "isvar" NIL (isvar '(x y) 'x))
  (expect-equal "not isvar" NIL (isvar '(x y) 'a))
  (expect-equal "not isvar" NIL (isvar '(x y) '(f x)))
)

;; (subst t v expr)

(deftest test-simplesubst*()
  "simple subst*"
  (expect-equal "single sigma" 
          '(f y y)
          (subst* '((x . y)) '(f x y))
  )

  (expect-equal "double sigma" '(g y (h (f y)))
	    (subst* '((x . y)(z . (f y))) '(g x (h z)))
   )

  (expect-equal "cyclic sigma" '(g (g x) (h (f (g x))))
	    (subst* '((x . y)(z . (f y))(y . (g x))) '(g x (h z)))
   )

  (expect-notequal "cyclic sigma fail" '(g (g x) (h (f (g x))))
	    (subst* '((x . y)(y . (g x))(z . (f y))) '(g x (h z)))
   )

)

(deftest test-disagree()
  "how disagree works"
  (expect-equal "identical atom" '() (disagree 'x 'x))
  (expect-equal "identical " '() (disagree  '(f x y) '(f x y)))
  (expect-equal "identical " '((h z) . x) (disagree '(f (h z) (g y)) '(f x (g z))))
  (expect-equal "identical " '(x . (h x)) (disagree  '(f x (g y)) '(f (h x) (g z))))
  (expect-equal "identical " '((g z) . (h x)) (disagree  '(f (g z) (g y)) '(f (h x) (g z))))
  (expect-equal "identical " '(y . z) (disagree '(f (g y) (g z))  '(f (g z) (g z))))
)

(deftest test-switcher ()
  "how swictcher works, but this should be an implementation"

   (expect-equal "" '(x . a) (switcher '(x y) '(x . a)))
   (expect-equal "" '(x . a) (switcher '(x y) '(a . x)))
   (expect-equal "" '(x . (f z)) (switcher '(x y) '(x . (f z))))
   (expect-equal "" '(x . (f z)) (switcher '(x y) '((f z) . x)))

)

(deftest test-unify ()
  "test unify"
  (expect-equal "identical symbol" '() (unify '(x) 'x 'x))
  (expect-equal "identical symbol" '() (unify '(x) 'a 'a))
  (expect-equal "identical fterm" '() (unify '(x) '(f x) '(f x)))
  (expect-equal "symbol unify" '((x . y)) (unify '(x y) 'x 'y))
  (expect-equal "fterm unify" '((x . (f y))) (unify '(x y) 'x '(f y)))
  (expect-equal "fterm unify" '((x . (f y))) (unify '(x y) '(f y) 'x))
  (expect-equal "fterm unify" '((x . (f y))) (unify '(x y) '(h (f y)) '(h x)))
  (expect-equal "fterm unify" '((x . (f y))) (unify '(x y) '(h x) '(h (f y))))
  (expect-equal "fterm unify" '((x . (f y))(w . a)) (unify '(x y w) '(h x a) '(h (f y) w)))
)

(deftest test-insidep ()
  (expect-equal "not x in x var" NIL (insidep '(x) 'x 'x))
  (expect-equal "not x in x const" NIL (insidep '() 'x 'x))
  (expect-equal "x in f(x)" T (insidep '(x) 'x '(f x)))
  (expect-equal "x in f(g(x))" T (insidep '(x) 'x '(f (g x))))
  (expect-equal "x in f(g(y),h(x))" T (insidep '(x y) 'x '(f (g y)(g x))))
  (expect-equal "x in f(a, g(x))" T (insidep '(x) 'x '(f a (g x))))
  (expect-equal "x in f(y,x)" T (insidep '(x y) 'x '(f y x)))
  (expect-equal "x in f(a,b)" NIL (insidep '(x) 'x '(f a b)))
)

(deftest test-unify-complex ()
  "test unify complicated"
  (expect-equal "fterm unify" '((x . (f y))(w . (f y))) (unify '(x y w) '(h x x) '(h (f y) w)))


)

(deftest test-all ()
  (test-set "ancient uification"
    (test-isvar)
    (test-simplesubst*)
    (test-disagree)
    (test-switcher)
    (test-insidep)
    (test-unify)
  )
)

(test-all)

