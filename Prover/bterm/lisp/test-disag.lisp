;;
(load "test.lisp")
(load "load-disag.lisp")


(deftest test-subst1 ()
  "subst1 is subst for primitive e*x,t" 
  (expect-equal "1 subst1" 'b (subst1  'b 'x 'a))
  (expect-equal "2 subst1" 'a (subst1  'x 'x 'a))
  (expect-equal "3 subst1" '(f a) (subst1  '(f x) 'x 'a))
  (expect-equal "4 subst1" '(f a (h a)) (subst1  '(f x (h x)) 'x 'a))
) 

(deftest test-substs ()
  "substs is subst sequential e*((x . s)(y . t))"
  (expect-equal "1 substs" 'b (substs  'b '((x . a))))
  (expect-equal "2 substs" 'a (substs  'x '((x . a))))
  (expect-equal "3 substs" '(f a) (substs  '(f x) '((x . a))))
  (expect-equal "4 substs" '(f a (h a)) (substs  '(f x (h x)) '((x . a))))
  (expect-equal "5 substs" '(f b (h a)) (substs  '(f y (h x)) '((x . a)(y . b))))
  (expect-equal "6 substs" '(f b (h a)b) (substs  '(f y (h x)y) '((x . a)(y . b))))
)



(deftest test-subsubs1 ()
  "subsubs1 s*(x . e) "
  (expect-equal "1 subsubs1" '((x . b)) (subsubs1  '((x . b)) 'x 'a))
  (expect-equal "2 subsubs1" '((x . b)(y . a)) (subsubs1  '((x . b)) 'y 'a))
  (expect-equal "3 subsubs1" '((x . a)) (subsubs1  '((x . x)) 'x 'a))
  (expect-equal "4 subsubs1" '((z . (f a y))(x . a)) (subsubs1 '((z . (f x y))) 'x 'a))
  (expect-equal "5 subsubs1" '((z . (f a (h x)))(w . a)(y . a)) (subsubs1 '((z . (f y (h x)))(w . y)) 'y 'a))
)

(deftest test-subsubs1h ()
  "subsubs1h s*(x . e) "
  (expect-equal "1 subsubs1h" '((x . b)) (subsubs1h  '((x . b)) 'x 'a nil))
  (expect-equal "2 subsubs1h" '((x . b)(y . a)) (subsubs1h  '((x . b)) 'y 'a nil))
  (expect-equal "3 subsubs1h" '((x . a)) (subsubs1h  '((x . x)) 'x 'a nil))
  (expect-equal "4 subsubs1h" '((z . (f a y))(x . a)) (subsubs1h '((z . (f x y))) 'x 'a nil))
  (expect-equal "5 subsubs1h" '((z . (f a (h x)))(w . a)(y . a)) (subsubs1h '((z . (f y (h x)))(w . y)) 'y 'a nil))
  (expect-equal "6 subsubs1h" '((x . a)(y . b)(w . a)) (subsubs1h '((x . a)(y . b)(w . y)) 'y 'a nil))
)


(deftest test-subsubs1w ()
  "subsubs1w s*(x . e) "
  (expect-equal "1 subsubs1w" '((x . b)) (subsubs1w  '((x . b)) 'x 'a ))
  (expect-equal "2 subsubs1w" '((x . b)(y . a)) (subsubs1w  '((x . b)) 'y 'a ))
  (expect-equal "3 subsubs1w" '((x . a)) (subsubs1w  '((x . x)) 'x 'a))
  (expect-equal "4 subsubs1w" '((z . (f a y))(x . a)) (subsubs1w '((z . (f x y))) 'x 'a ))
  (expect-equal "5 subsubs1w" '((z . (f a (h x)))(w . a)(y . a)) (subsubs1w '((z . (f y (h x)))(w . y)) 'y 'a ))
  (expect-equal "6 subsubs1h" '((x . a)(y . b)(w . a)) (subsubs1w '((x . a)(y . b)(w . y)) 'y 'a ))
)

(deftest test-subsubs ()
  "subsubs s*((x . e)(y . f)) "
  (expect-equal "1 subsubs" '((x . b)) (subsubs  '((x . b)) '((x . a))))
  (expect-equal "2 subsubs" '((x . b)(y . a)) (subsubs  '((x . b)) '((y . a))))
  (expect-equal "3 subsubs" '((x . b)(y . c)(z . d)) (subsubs  '((x . b)(y . c)) '((y . a)(z . d))))
  (expect-equal "4 subsubs" '((x . (f a))(y . (g e))(z . d)) (subsubs  '((x . (f y))(y . (g x))) '((x . e)(y . a)(z . d))))

)
(deftest test-subsubsw ()
  "subsubsw s*((x . e)(y . f)) "
  (expect-equal "1 subsubsw" '((x . b)) (subsubsw  '((x . b)) '((x . a))))
  (expect-equal "2 subsubsw" '((x . b)(y . a)) (subsubsw  '((x . b)) '((y . a))))
  (expect-equal "3 subsubsw" '((x . b)(y . c)(z . d)) (subsubsw  '((x . b)(y . c)) '((y . a)(z . d))))
  (expect-equal "4 subsubsw" '((x . (f a))(y . (g e))(z . d)) (subsubsw  '((x . (f y))(y . (g x))) '((x . e)(y . a)(z . d))))

)

(deftest test-pnot ()
  "pnot don7t change vars, put/get v.e, vars way"
  (expect-equal "1 putpnot" '(b d d) (putpnot '(x y z) '(d d d)  'x 'b))
  (expect-equal "2 putpnot" '(d b d) (putpnot '(x y z) '(d d d)  'y 'b))
  (expect-equal "3 putpnot" '(d d b) (putpnot '(x y z) '(d d d)  'z 'b))
  (expect-equal "4 putpnot" '(d d d) (putpnot '(x y z) '(d d d)  'w 'b))
  (expect-equal "5 putpnot" '(d (f x) d) (putpnot '(x y z) '(d d d)  'y '(f x)))
)

(deftest test-substp1 ()
  "substp1 pnot with vars."
  (expect-equal "1 substp1" '(b d d) (substp1 '(x y z) '(d d d)  'x 'b))
  (expect-equal "2 substp1" '(d b d) (substp1 '(x y z) '(d d d)  'y 'b))
  (expect-equal "3 substp1" '(d d b) (substp1 '(x y z) '(d d d)  'z 'b))
  (expect-equal "4 substp1" '(d d d) (substp1 '(x y z) '(d d d)  'w 'b))
  (expect-equal "5 substp1" '(d (f x) d) (substp1 '(x y z) '(d d d)  'y '(f x)))
)

(deftest test-substp ()
  "substp is subst parallel e*s"
  (expect-equal "1 substp" 'b (substp '(x) 'b '(a)))
  (expect-equal "2 substp" 'a (substp '(x) 'x '(a)))
  (expect-equal "3 substp" '(f a) (substp '(x) '(f x) '(a)))
  (expect-equal "4 substp" '(f a (h a)) (substp '(x) '(f x (h x)) '(a)))
  (expect-equal "5 substp" '(f b (h a)) (substp '(x y) '(f y (h x)) '(a b)))
)


(deftest test-subsubp1 ()
  "subsubp1 s*([x].[e]) "
  (expect-equal "1 subsubp1" '(b y) (subsubp1 '(x y) '(x y) 'x 'b))
  (expect-equal "2 subsubp1" '(x b) (subsubp1 '(x y) '(x y) 'y 'b))
  (expect-equal "3 subsubp1" '(x y) (subsubp1 '(x y) '(x y) 'z 'b))

  (expect-equal "4 subsubp1" '((f c) y) (subsubp1 '(x y) '(x y) 'x '(f c)))
  (expect-equal "5 subsubp1" '((f c) b) (subsubp1 '(x y) '(x b) 'x '(f c)))
  (expect-equal "6 subsubp1" '(b (f b)) (subsubp1 '(x y) '(x (f x)) 'x 'b))

)

(deftest test-subsubp ()
  "subsubp s*((x y) . (s t)) as (x y).(s*(s t)) "

  (expect-equal "1 subsubp" '(a b) (subsubp '(x y) '(x b) '(a y)))
  (expect-equal "2 subsubp" '(a b) (subsubp '(x y) '(x b) '(a y)))
  (expect-equal "3 subsubp" '((f a)(g b)) (subsubp '(x y) '((f x)(g y)) '(a b)))

  (expect-equal "4 subsubp dubious" '((f x)(g x)) (subsubp '(x y) '((f x)(g y)) '(y x)))
)


;(defun myfun ()
;  "for my fun"
;  (disagree () 'a 'a #'showit)
;  (disagree () 'a 'b #'showit)
;  (disagree () '(f a) '(g a) #'showit)
;  (disagree () '(f a) '(f b) #'showit)
;  (disagree '(x) '(f x) '(f b) #'showit)
;)

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



(test-disagree-collect)
(test-subst1)
(test-substs)

(test-subsubs1h)
(test-subsubs1)
(test-subsubs)

(test-subsubs1w)
(test-subsubsw)

(test-pnot)
(test-substp1)
(test-substp)

(test-subsubp1)
(test-subsubp)
(test-disagree-unific)


