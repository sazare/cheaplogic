;; test for alpha
;; how to write these test in consice and complete

(load "test.lisp")

(load "load-alpha.lisp")

(format t "alpha is a implementation of subst and subsub variations~%")

(deftest test-isvar ()
 "tests for isvar"
 (expect-f "1 isnotavar" (isvar () 'x))
 (expect-f "2 isnotavar" (isvar '(y z) 'x))
 (expect-t "3 isavar" (isvar '(x y z) 'x))
 (expect-t "4 isavar" (isvar '(y x z) 'x))
 (expect-t "5 isavar" (isvar '(y z x) 'x))
)

(deftest test-prims ()
 "tests for primitives"
 (expect-equal "1 vof" 'a (vof '(a . b)))
 (expect-equal "2 exof" 'b (exof '(a . b)))
 (expect-equal "3 exof" '(f b) (exof '(a . (f b))))
 (expect-t "4 issym"  (issym 'x))
 (expect-f "5 issym"  (issym '(f x)))
 (expect-equal "6 sigma" '(a . (f g)) (sigma 'a '(f g)))
 (expect-equal "7 fof" 'f (fof '(f a)))
 (expect-equal "8 e*of" '(x (h a)) (e*of '(f x (h a))))
 (expect-equal "9 e*of" () (e*of '(f)))
 (expect-equal "10 form" '(f x y) (form 'f '(x y)))
)

(deftest test-subst1 ()
 "test for subst1"
 (expect-equal "1 subst1" 'x (subst1 'x '(a . b)))
 (expect-equal "2 subst1" 'b (subst1 'a '(a . b)))
 (expect-equal "3 subst1" '(f x y) (subst1 '(f x y)  '(a . b)))
 (expect-equal "4 subst1" '(f b b) (subst1 '(f a a)  '(a . b)))
 (expect-equal "5 subst1" '(f (a x) (h b (g b))) (subst1 '(f (a x)(h a (g a)))  '(a . b)))
)

(deftest test-psubst ()
 "test for psubst"
 (expect-equal "1 psubst" 'x (psubst 'x '()))
 (expect-equal "2 psubst" 'x (psubst 'x '((a . b))))
 (expect-equal "3 psubst" 'c (psubst 'x '((x . c))))
 (expect-equal "4 psubst" 'x (psubst 'x '((y . d))))
 (expect-equal "5 psubst" 'k (psubst 'x '((y . d)(x . k))))
 (expect-equal "6 psubst" 'k (psubst 'x '((y . d)(x . k)(x . u))))

 (expect-equal "7 psubst" '(f k k)  (psubst '(f x x) '((y . d)(x . k))))
 (expect-equal "8 psubst" '(f k (h k))  (psubst '(f x (h x)) '((y . d)(x . k))))
 (expect-equal "9 psubst" '(f k (h d))  (psubst '(f x (h y)) '((y . d)(x . k))))
 (expect-equal "10 psubst" '(f k (h d k))  (psubst '(f x (h y x)) '((y . d)(x . k))))
 (expect-equal "11 psubst" '(f z (h d k))  (psubst '(f z  (h y x)) '((y . d)(x . k))))
 (expect-equal "12 psubst" '(f z01 (h11 d20 k9))  (psubst '(f z01 (h11 y1 x2)) '((y1 . d20)(x2 . k9))))
 (expect-equal "12 psubst" '(f z01 (h11 d20 k9))  (psubst '(f z01 (h11 y1 x2)) '((y1 . d20)(x2 . k9)(x2 . k8)(y1 . aa))))
)

(deftest test-ssubst ()
 "test for ssubst"
 (expect-equal "1 ssubst" 'x (ssubst 'x '()))
 (expect-equal "2 ssubst" 'a (ssubst 'x '((x . a))))
 (expect-equal "3 ssubst" '(f (g z)) (ssubst 'x '((x . (f w))(w . (g z)))))
 (expect-equal "4 ssubst" '(f (g z)) (ssubst 'x '((x . (f w))(y . a)(w . (g z)))))
 (expect-equal "5 ssubst" '(f w a) (ssubst 'x '((w. (g z))(x . (f w y))(y . a))))
 (expect-equal "6 ssubst" '(q (f (g z)) a z (h a)) (ssubst '(q x y z w) '((w . (h y))(x . (f w))(y . a)(w . (g z)))))
)

(deftest test-subsub1 ()
 "tests for subsub1"
 (expect-equal "1 subsub1" '((x . a)) (subsub1 '() '(x . a)))
 (expect-equal "2 subsub1" '((x . a)) (subsub1 '((x . a)) '(x . b)))
 (expect-equal "3 subsub1" '((y . b)) (subsub1 '() '(y . b)))
 (expect-equal "4 subsub1" '((x . a)(y . b)) (subsub1 '((x . a)) '(y . b)))
 (expect-equal "5 subsub1" '((x . a)(z . (f w b))(w . b)(y . b)) (subsub1 '((x . a)(z . (f w y))(w . y)) '(y . b)))
)

(deftest test-psubsub ()
 "tests for psubsub"
 (expect-equal "1 psubsub" () (psubsub '() '()))
 (expect-equal "2 psubsub" '((x . a)) (psubsub '() '((x . a))))
 (expect-equal "3 psubsub" '((x . a)) (psubsub '((x . a)) '()))
 (expect-equal "4 psubsub" '((x . a)(y . b)) (psubsub '((x . a)) '((y . b))))
 (expect-equal "5 psubsub" '((x . a)(z . (h a))(y . b)) (psubsub '((x . a)(z . (h a))) '((y . b))))
 (expect-equal "6 psubsub" '((x . a)(y . b)(z . (f c))) (psubsub '((x . a)) '((y . b)(z . (f c)))))

)


;
;(deftest test-unify ()
; "tests for unify"
; (expect-equal "equal make null sigma" () (unify '() 'a 'a))
; (expect-equal "equal make null sigma" ((a . a)) (unify '(a) 'a 'a))
; (expect-equal "equal make null sigma" ((x . x)) (unify '(x) 'a 'a))
; (expect-equal "equal make null sigma" 'NO (unify '() 'a 'b))
; (expect-equal "equal make null sigma" 'NO (unify '(x y) 'a 'b))
;
;)

(deftest test-all()
 (test-set "alpha unification"
  (test-isvar)
  (test-prims)
  (test-subst1)
  (test-psubst)
  (test-ssubst)
  (test-subsub1)
  (test-psubsub)


;  (test-unify)
 )
)

(test-all)

