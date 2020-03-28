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
 "subst1 s2 is just a sigma"
 (expect-equal "1 subst1 unmatch s" 'x (subst1 'x '(a . b)))
 (expect-equal "2 subst1 match s" 'b (subst1 'a '(a . b)))
 (expect-equal "3 subst1 unmatch f" '(f x y) (subst1 '(f x y)  '(a . b)))
 (expect-equal "4 subst1 2match" '(f b b) (subst1 '(f a a)  '(a . b)))
 (expect-equal "5 subst1 match in depth but not f" '(f (a x) (h b (g b))) (subst1 '(f (a x)(h a (g a)))  '(a . b)))
)

(deftest test-psubst ()
 "psubst s2 not affect s1's ex, and add s2 to s1 when s2's v is not in s1"
 (expect-equal "1 psubst empty sigma" 'x (psubst 'x '()))
 (expect-equal "2 psubst unmatch s" 'x (psubst 'x '((a . b))))
 (expect-equal "3 psubst match s" 'c (psubst 'x '((x . c))))
 (expect-equal "5 psubst match 2nd s" 'k (psubst 'x '((y . d)(x . k))))
 (expect-equal "6 psubst match first s" 'k (psubst 'x '((y . d)(x . k)(x . u))))

 (expect-equal "7 psubst match 2, 2nd" '(f k k)  (psubst '(f x x) '((y . d)(x . k))))
 (expect-equal "8 psubst match 2nd, in depth" '(f k (h k))  (psubst '(f x (h x)) '((y . d)(x . k))))
 (expect-equal "9 psubst match 2, 2match" '(f k (h d))  (psubst '(f x (h y)) '((y . d)(x . k))))
 (expect-equal "10 psubst match xyx" '(f k (h d k))  (psubst '(f x (h y x)) '((y . d)(x . k))))
 (expect-equal "11 psubst match 2 in detpth" '(f z (h d k))  (psubst '(f z  (h y x)) '((y . d)(x . k))))
 (expect-equal "12 psubst long symbols" '(f z01 (h11 d20 k9))  (psubst '(f z01 (h11 y1 x2)) '((y1 . d20)(x2 . k9))))
 (expect-equal "12 psubst long symbols, long dup sigma" '(f z01 (h11 d20 k9))  (psubst '(f z01 (h11 y1 x2)) '((y1 . d20)(x2 . k9)(x2 . k8)(y1 . aa))))
)

(deftest test-ssubst ()
 "ssubst apply s2 to every s1's ex and add s2 to s1 when s2's v is not in s1"
 (expect-equal "1 ssubst empty sigma s" 'x (ssubst 'x '()))
 (expect-equal "2 ssubst match s" 'a (ssubst 'x '((x . a))))
 (expect-equal "3 ssubst match to fterm" '(f (g z)) (ssubst 'x '((x . (f w))(w . (g z)))))
 (expect-equal "4 ssubst in match x->w->z" '(f (g z)) (ssubst 'x '((x . (f w))(y . a)(w . (g z)))))
 (expect-equal "5 ssubst before dosent affect after sig" '(f w a) (ssubst 'x '((w. (g z))(x . (f w y))(y . a))))
 (expect-equal "6 ssubst w before, after effects med" '(q (f (g z)) a z (h a)) (ssubst '(q x y z w) '((w . (h y))(x . (f w))(y . a)(w . (g z)))))
)

(deftest test-subsub1 ()
 "subsub1 s1 x s2 but s2 is single. added s2 to s1 when s2's var not in s1"
 (expect-equal "1 subsub1 s1 is empty" '((x . a)) (subsub1 '() '(x . a)))
 (expect-equal "2 subsub1 not add and effect same s" '((x . a)) (subsub1 '((x . a)) '(x . b)))
 (expect-equal "3 subsub1 add s2, and affect to s1 on y" '((x . a)(y . c)(z . (f w b))(w . b)) (subsub1 '((x . a)(y . c)(z . (f w y))(w . y)) '(y . b)))
 (expect-equal "4 subsub1 not same sym, just added" '((x . a)(y . b)) (subsub1 '((x . a)) '(y . b)))
 (expect-equal "5 subsub1 add s2, and affect to s1 on y" '((x . a)(z . (f w b))(w . b)(y . b)) (subsub1 '((x . a)(z . (f w y))(w . y)) '(y . b)))
)

(deftest test-insigma ()
 "insigma(v s) tests v in s"
 (expect-f "1 insigma sigma empty" (insigma 'x '()))
 (expect-t "2 insigma v in sigma " (insigma 'x '((x . a))))
 (expect-f "3 insigma not v in sigma" (insigma 'x '((y . a))))
 (expect-t "4 insigma v in sigma many " (insigma 'x '((y . g)(x . a))))
 (expect-f "5 insigma v not in sigma many " (insigma 'z '((y . g)(x . a))))
)

(deftest test-diffsigma ()
 "diffsigma remove same var of s2 from s1"
 (expect-equal "1 diffsigma s1,s2 both empty" () (diffsigma () ()))
 (expect-equal "2 diffsigma s1 empty" () (diffsigma () '((x . a))))
 (expect-equal "3 diffsigma s2 empty" '((x . a)) (diffsigma '((x . a)) ()))
 (expect-equal "4 diffsigma s1,s2 not common" '((x . a)) (diffsigma '((x . a)) '((y . b))))
 (expect-equal "5 diffsigma s1,s2 common" () (diffsigma '((x . a)) '((x . b))))
 (expect-equal "6 diffsigma s2 has common" () (diffsigma '((x . a)) '((x . b)(z . c))))
 (expect-equal "7 diffsigma s2 has common in 3" () (diffsigma '((x . a)) '((y . k)(x . b)(z . c))))
 (expect-equal "8 diffsigma s2 2 removed" '((w . k)) (diffsigma '((y . w)(x . a)(w . k)) '((y . k)(x . b)(z . c))))
 (expect-equal "9 diffsigma s1 all remoed" () (diffsigma '((y . w)(x . a)) '((y . k)(x . b)(z . c))))
)

(deftest test-psubsub ()
 "psubsub s1 add s2 when s2's var not in s1. s1's ex isn't affeced by s2"
 (expect-equal "1 psubsub s1, s2 empty" () (psubsub '() '()))
 (expect-equal "2 psubsub s1 empty" '((x . a)) (psubsub '() '((x . a))))
 (expect-equal "3 psubsub s2 empty" '((x . a)) (psubsub '((x . a)) '()))
 (expect-equal "4 psubsub just add diff syms" '((x . a)(y . b)) (psubsub '((x . a)) '((y . b))))
 (expect-equal "5 psubsub just add 2+1 e has f, s2's e is sym" '((x . a)(z . (h a))(y . b)) (psubsub '((x . a)(z . (h a))) '((y . b))))
 (expect-equal "6 psubsub s2 has 2sigmas just add" '((x . a)(y . b)(z . (f c))) (psubsub '((x . a)) '((y . b)(z . (f c)))))

;; 7 and 8 are out conditioned sigmas
 (expect-equal "7 psubsub without same s" '((x . (h w))(y . (j y))(w . (k y))(z . (f c))) (psubsub '((x . (h w))(y . (j y))(w . (k y))) '((y . b)(z . (f c)))))
 (expect-equal "8 psubsub s2 has 2sigmas without affect on y" '((x . (h w))(w . (k y))(y . b)(z . (f y))) (psubsub '((x . (h w))(w . (k y))) '((y . b)(z . (f y)))))

)

(deftest test-ssubsub ()
 "ssubsub s2 affects s1's ex and added s2 to"
 (expect-equal "1 ssubsub s1,s2 empty " () (ssubst () ()))
 (expect-equal "2 ssubsub s1 empty" '((x . a)(y . (f x))) (ssubst () '((x . a)(y . (f x)))))
 (expect-equal "3 ssubsub s2 empty" '((x . a)(y . (f x))) (ssubst '((z . a)(y . (h a))) ()))
 (expect-equal "4 ssubsub disjoint var s1,s2" '((z . a)(w . (h a))(x . a)(y . (f x))) (ssubst '((z . a)(w . (h a))) '((x . a)(y . (f x)))))
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
  (test-insigma)
  (test-diffsigma)
  (test-psubsub)
  (test-ssubsub)

;  (test-unify)
 )
)

(test-all)

