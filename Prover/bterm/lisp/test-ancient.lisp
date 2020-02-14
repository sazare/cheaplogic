;; test for ancient.lisp

(load "test.lisp")
(load "ancient.lisp")

;; (subst t v expr)

(deftest test-simplesubst*()
  "simple subst*"
  (test-equal "single sigma" 
          '(f y y)
          (subst* '((x . y)) '(f x y))
  )

  (test-equal "double sigma" '(g y (h (f y)))
	    (subst* '((x . y)(z . (f y))) '(g x (h z)))
   )

  (test-equal "cyclic sigma" '(g (g x) (h (f (g x))))
	    (subst* '((x . y)(z . (f y))(y . (g x))) '(g x (h z)))
   )

  (test-notequal "cyclic sigma fail" '(g (g x) (h (f (g x))))
	    (subst* '((x . y)(y . (g x))(z . (f y))) '(g x (h z)))
   )

)

(deftest test-all ()
         (test-set "simple subst*"
           (test-simplesubst*)
           ))

(test-all)


