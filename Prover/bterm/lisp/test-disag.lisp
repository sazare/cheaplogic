;;
(load "test.lisp")
(load "play-disag.lisp")


(deftest test-subst1 ()
  "subst1 is subst for primitive" 
  (expect-equal "1 subst1" 'b (subst1 '(x) 'b '(x . a)))
  (expect-equal "2 subst1" 'a (subst1 '() 'x '(x . a)))
  (expect-equal "3 subst1" '(f a) (subst1 '(x) '(f x) '(x . a)))
  (expect-equal "4 subst1" '(f a (h a)) (subst1 '(x) '(f x (h x)) '(x . a)))
) 

(deftest test-substs ()
  "substs is subst sequential"
  (expect-equal "1 substs" 'b (substs '(x) 'b '((x . a))))
  (expect-equal "2 substs" 'a (substs '() 'x '((x . a))))
  (expect-equal "3 substs" '(f a) (substs '(x) '(f x) '((x . a))))
  (expect-equal "4 substs" '(f a (h a)) (substs '(x) '(f x (h x)) '((x . a))))
  (expect-equal "5 substs" '(f b (h a)) (substs '(x) '(f y (h x)) '((x . a)(y . b))))
)

(deftest test-substp ()
  "substp is subst parallel"
  (expect-equal "1 substp" 'b (substp '(x) 'b '(a)))
  (expect-equal "2 substp" 'a (substp '(x) 'x '(a)))
  (expect-equal "3 substp" '(f a) (substp '(x) '(f x) '(a)))
  (expect-equal "4 substp" '(f a (h a)) (substp '(x) '(f x (h x)) '(a)))
  (expect-equal "5 substp" '(f b (h a)) (substp '(x y) '(f y (h x)) '(a b)))
)

(defun myfun ()
  "for my fun"
  (disagree () 'a 'a #'showit)
  (disagree () 'a 'b #'showit)
  (disagree () '(f a) '(g a) #'showit)
  (disagree () '(f a) '(f b) #'showit)
  (disagree '(x) '(f x) '(f b) #'showit)
)

(deftest test-disagree-collect ()
  "disagree collect are tests for disagree"
  (expect-equal "1 disagree" '() (disagree () 'a 'a #'collect))
  (expect-equal "2 disagree" '((a . b)) (disagree () 'a 'b #'collect))
  (expect-equal "3 disagree" 'NO (disagree () '(f a) '(g a) #'collect))
  (expect-equal "4 disagree" '((a . b)) (disagree () '(f a) '(f b) #'collect))
  (expect-equal "5 disagree" '((x . b)) (disagree '(x) '(f x) '(f b) #'collect))
  (expect-equal "6 disagree" '((x . b)) (disagree '(x) '(f x) '(f b) #'collect))
  (expect-equal "7 disagree" '((x . b)(y . a)) (disagree '(x y) '(f x (h y)) '(f b (h a)) #'collect))
  (expect-equal "8 disagree" '((x . (g a))(y . a)) (disagree '(x y) '(f x (h y)) '(f (g a) (h a)) #'collect))
  (expect-equal "9 disagree" '((x . (h y))(y . (g w))) (disagree '(x y) '(f (h y) (h y)) '(f x (h (g w))) #'collect))
) 

(deftest test-disagree-unific ()
  "disagree unific is a unify test"
  (expect-equal "010 disagree" '() (disagree () 'a 'a #'unific))
  (expect-equal "011 disagree" 'NO (disagree () 'a 'b #'unific))
  (expect-equal "012 disagree" 'NO (disagree '(x) 'a 'b #'unific))
  (expect-equal "013 disagree" '((x . (h b))) (disagree '(x) '(f x) '(f (h b)) #'unific))
  (expect-equal "014 disagree" '((x . (g a))(y . a)) (disagree '(x y) '(f x (g x)) '(f y (g a)) #'unific))
)

(test-subst1 )
(test-substs )
(test-substp )
(test-disagree-collect )
(test-disagree-unific )


