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
  (expect-equal "5 substs" '(f b (h a)) (substs  '(f y (h x)) '((x . a)(y . b))))
)

;; substp1 
;;(deftest test-substp1 ()
;;  "substp1 is subst for primitive e*((x).(t))" 
;;  (expect-equal "1 substp1" 'b (substp1 '(x) 'b '((x) . (a))))
;;  (expect-equal "2 substp1" 'a (substp1 '() 'x '((x) . (a))))
;;  (expect-equal "3 substp1" '(f a) (substp1 '(x) '(f x) '((x) . (a))))
;;  (expect-equal "4 substp1" '(f a (h a)) (substp1 '(x) '(f x (h x)) '((x) . (a))))
;;) 

(deftest test-psubst ()
  "substp is subst parallel e*s"
  (expect-equal "1 psubst" 'b (psubst '(x) 'b '((x).(a))))
  (expect-equal "2 psubst" 'a (psubst '(x) 'x '((x).(a))))
  (expect-equal "3 psubst" '(f a) (psubst '(x) '(f x) '((x).(a))))
  (expect-equal "4 psubst" '(f a (h a)) (psubst '(x) '(f x (h x)) '((x).(a))))
  (expect-equal "5 psubst" '(f b (h a)) (psubst '(x y) '(f y (h x)) '((x y).(a b))))
)

(deftest test-substp ()
  "psubst is subst parallel (x y).(e*(t d))"
  (expect-equal "1 substp" 'b (substp '(x) 'b '(a)))
  (expect-equal "2 substp" 'a (substp '(x) 'x '(a)))
  (expect-equal "3 substp" '(f a) (substp '(x) '(f x) '(a)))
  (expect-equal "4 substp" '(f a (h a)) (substp '(x) '(f x (h x)) '(a)))
  (expect-equal "5 substp" '(f b (h a)) (substp '(x y) '(f y (h x)) '(a b)))
)

(deftest test-subsubs1 ()
  "subsubs1 s*(x . e) "
  (expect-equal "1 subsubs1" '((x . b)) (subsubs1  '((x . b)) 'x 'a))
  (expect-equal "2 subsubs1" '((x . b)(y . a)) (subsubs1  '((x . b)) 'y 'a))
  (expect-equal "3 subsubs1" '((x . a)) (subsubs1  '((x . x)) 'x 'a))
  (expect-equal "4 subsubs1" '((z . (f a y))(x . a)) (subsubs1 '((z . (f x y))) 'x 'a))
  (expect-equal "5 subsubs1" '((z . (f a (h x)))(w . a)(y . a)) (subsubs1 '((z . (f y (h x)))(w . y)) 'y 'a))
)

;(deftest test-subsubs ()
;  "subsubs s*((x . e)(y . f)) "
;
;)

;(deftest test-subsubp1 ()
;  "subsubp1 s*((x) . (e)) "
;; no  (expect-equal "1 subsubp1" '((x y).(a b)) (subsubp1 '(x y) '((x y).(x b)) '((x).(a))))
;;  (expect-equal "1 subsubp1" '((x y).(b a)) (subsubp1 '(x y) '((x y).(x b)) '((x y).(a y))))
;; too complicated  (expect-equal "1 subsubp1" '(a b) (subsubp1 '(x y) '(x b) '(x . a)))
;
;  (expect-equal "1 subsubp1" '(a b) (subsubp1 '(x y) '(x b) '(x . a)))
;
;;  (expect-equal "1 subsubp1" '((f c) b) (subsubp1 '(x y) '(x b) '(x . (f c))))
;;  (expect-equal "1 subsubp1" '((f b) b) (subsubp1 '(x y) '(x b) '(x . (f y))))
;
;;  (expect-equal "1 subsubp1" 'b (subsubp1 '(x y) '((x y).(x x)) '(x . a)))
;;  (expect-equal "1 subsubp1" 'b (subsubp1 '(x y) '((y).(x)) '(x).(a))))
;;  (expect-equal "1 subsubp1" 'b (subsubp1 '(x y) '((x y).(x y)) '((y).(a))))
;)
;
;(deftest test-subsubp ()
;  "subsubp s*((x y) . (s t)) as (x y).(s*(s t)) "
;
;  (expect-equal "1 subsubp1" '(a b) (subsubp1 '(x y) '(x b) '(a y)))
;)
;
;
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
(test-subsubs1)
;(test-subsubs)

(test-psubst)
(test-substp)
;(test-subsubp1)
;(test-subsubp)
;(test-disagree-unific)
