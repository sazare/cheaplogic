;; ito for alpha
;; how to write these ito in consice and complete
;; notation [vi<-ei,...]

(myload "ito.lisp")

(load "load-alpha-prim-snot.lisp")

(format t "[alpha is a implementation of subst and subsub variations and snotation]~%")

(defito ito-isvar ()
 "itos for isvar"
 (intend-f "1 isnotavar" (isvar () 'x))
 (intend-f "2 isnotavar" (isvar '(y z) 'x))
 (intend-t "3 isavar" (isvar '(x y z) 'x))
 (intend-t "4 isavar" (isvar '(y x z) 'x))
 (intend-t "5 isavar" (isvar '(y z x) 'x))
)

(defito ito-prims ()
 "itos for primitives"
 (intend-equal "1 vof" 'a (vof '(a . b)))
 (intend-equal "2 exof" 'b (exof '(a . b)))
 (intend-equal "3 exof" '(f b) (exof '(a . (f b))))
 (intend-t "4 issym"  (issym 'x))
 (intend-f "5 issym"  (issym '(f x)))
 (intend-equal "6 sigma" '(a . (f g)) (sigma 'a '(f g)))
 (intend-equal "7 fof" 'f (fof '(f a)))
 (intend-equal "8 e*of" '(x (h a)) (e*of '(f x (h a))))
 (intend-equal "9 e*of" () (e*of '(f)))
 (intend-equal "10 form" '(f x y) (form 'f '(x y)))
)

(defito ito-subst1s ()
 "subst1s s2 is just a sigma"
 (intend-equal "1 subst1s unmatch s" 'x (subst1s 'x '(a . b)))
 (intend-equal "2 subst1s match s" 'b (subst1s 'a '(a . b)))
 (intend-equal "3 subst1s unmatch f" '(f x y) (subst1s '(f x y)  '(a . b)))
 (intend-equal "4 subst1s 2match" '(f b b) (subst1s '(f a a)  '(a . b)))
 (intend-equal "5 subst1s match in depth but not f" '(f (a x) (h b (g b))) (subst1s '(f (a x)(h a (g a)))  '(a . b)))
)

(defito ito-psubsts ()
 "psubsts s2 not affect s1's ex, and add s2 to s1 when s2's v is not in s1"
 (intend-equal "1 psubsts empty sigma" 'x (psubsts 'x '()))
 (intend-equal "2 psubsts unmatch s" 'x (psubsts 'x '((a . b))))
 (intend-equal "3 psubsts match s" 'c (psubsts 'x '((x . c))))
 (intend-equal "5 psubsts match 2nd s" 'k (psubsts 'x '((y . d)(x . k))))
 (intend-equal "6 psubsts match first s" 'k (psubsts 'x '((y . d)(x . k)(x . u))))

 (intend-equal "7 psubsts match 2, 2nd" '(f k k)  (psubsts '(f x x) '((y . d)(x . k))))
 (intend-equal "8 psubsts match 2nd, in depth" '(f k (h k))  (psubsts '(f x (h x)) '((y . d)(x . k))))
 (intend-equal "9 psubsts match 2, 2match" '(f k (h d))  (psubsts '(f x (h y)) '((y . d)(x . k))))
 (intend-equal "10 psubsts match xyx" '(f k (h d k))  (psubsts '(f x (h y x)) '((y . d)(x . k))))
 (intend-equal "11 psubsts match 2 in detpth" '(f z (h d k))  (psubsts '(f z  (h y x)) '((y . d)(x . k))))
 (intend-equal "12 psubsts long symbols" '(f z01 (h11 d20 k9))  (psubsts '(f z01 (h11 y1 x2)) '((y1 . d20)(x2 . k9))))
 (intend-equal "12 psubsts long symbols, long dup sigma" '(f z01 (h11 d20 k9))  (psubsts '(f z01 (h11 y1 x2)) '((y1 . d20)(x2 . k9)(x2 . k8)(y1 . aa))))
)

(defito ito-ssubsts ()
 "ssubsts apply s2 to every s1's ex and add s2 to s1 when s2's v is not in s1"
 (intend-equal "1 ssubsts empty sigma s" 'x (ssubsts 'x '()))
 (intend-equal "2 ssubsts match s" 'a (ssubsts 'x '((x . a))))
 (intend-equal "3 ssubsts match to fterm" '(f (g z)) (ssubsts 'x '((x . (f w))(w . (g z)))))
 (intend-equal "4 ssubsts in match x->w->z" '(f (g z)) (ssubsts 'x '((x . (f w))(y . a)(w . (g z)))))
 (intend-equal "5 ssubsts before dosent affect after sig" '(f w a) (ssubsts 'x '((w. (g z))(x . (f w y))(y . a))))
 (intend-equal "6 ssubsts w before, after effects med" '(q (f (g z)) a z (h a)) (ssubsts '(q x y z w) '((w . (h y))(x . (f w))(y . a)(w . (g z)))))
)

(defito ito-subsub1s ()
 "subsub1s s1 x s2 but s2 is single. added s2 to s1 when s2's var not in s1"
 (intend-equal "1 subsub1s s1 is empty" '((x . a)) (subsub1s '() '(x . a)))
 (intend-equal "2 subsub1s not add and effect same s" '((x . a)) (subsub1s '((x . a)) '(x . b)))
 (intend-equal "3 subsub1s add s2, and affect to s1 on y" '((x . a)(y . c)(z . (f w b))(w . b)) (subsub1s '((x . a)(y . c)(z . (f w y))(w . y)) '(y . b)))
 (intend-equal "4 subsub1s not same sym, just added" '((x . a)(y . b)) (subsub1s '((x . a)) '(y . b)))
 (intend-equal "5 subsub1s add s2, and affect to s1 on y" '((x . a)(z . (f w b))(w . b)(y . b)) (subsub1s '((x . a)(z . (f w y))(w . y)) '(y . b)))
)

(defito ito-insigmas ()
 "insigmas(v s) itos v in s"
 (intend-f "1 insigmas sigma empty" (insigmas 'x '()))
 (intend-t "2 insigmas v in sigma " (insigmas 'x '((x . a))))
 (intend-f "3 insigmas not v in sigma" (insigmas 'x '((y . a))))
 (intend-t "4 insigmas v in sigma many " (insigmas 'x '((y . g)(x . a))))
 (intend-f "5 insigmas v not in sigma many " (insigmas 'z '((y . g)(x . a))))
)

(defito ito-diffsigmas ()
 "diffsigmas remove same var of s2 from s1"
 (intend-equal "1 diffsigmas s1,s2 both empty" () (diffsigma () ()))
 (intend-equal "2 diffsigmas s1 empty" () (diffsigma () '((x . a))))
 (intend-equal "3 diffsigmas s2 empty" '((x . a)) (diffsigma '((x . a)) ()))
 (intend-equal "4 diffsigmas s1,s2 not common" '((x . a)) (diffsigma '((x . a)) '((y . b))))
 (intend-equal "5 diffsigmas s1,s2 common" () (diffsigma '((x . a)) '((x . b))))
 (intend-equal "6 diffsigmas s2 has common" () (diffsigma '((x . a)) '((x . b)(z . c))))
 (intend-equal "7 diffsigmas s2 has common in 3" () (diffsigma '((x . a)) '((y . k)(x . b)(z . c))))
 (intend-equal "8 diffsigmas s2 2 removed" '((w . k)) (diffsigma '((y . w)(x . a)(w . k)) '((y . k)(x . b)(z . c))))
 (intend-equal "9 diffsigmas s1 all remoed" () (diffsigma '((y . w)(x . a)) '((y . k)(x . b)(z . c))))
)

(defito ito-psubsubs ()
 "psubsubs s1 add s2 when s2's var not in s1. s1's ex isn't affeced by s2"
 (intend-equal "1 psubsubs s1, s2 empty" () (psubsubs '() '()))
 (intend-equal "2 psubsubs s1 empty" '((x . a)) (psubsubs '() '((x . a))))
 (intend-equal "3 psubsubs s2 empty" '((x . a)) (psubsubs '((x . a)) '()))
 (intend-equal "4 psubsubs just add diff syms" '((x . a)(y . b)) (psubsubs '((x . a)) '((y . b))))
 (intend-equal "5 psubsubs just add 2+1 e has f, s2's e is sym" '((x . a)(z . (h a))(y . b)) (psubsubs '((x . a)(z . (h a))) '((y . b))))
 (intend-equal "6 psubsubs s2 has 2sigmas just add" '((x . a)(y . b)(z . (f c))) (psubsubs '((x . a)) '((y . b)(z . (f c)))))

;; 7 and 8 are out conditioned sigmas
 (intend-equal "7 psubsubs without same s" '((x . (h w))(y . (j y))(w . (k y))(z . (f c))) (psubsubs '((x . (h w))(y . (j y))(w . (k y))) '((y . b)(z . (f c)))))
 (intend-equal "8 psubsubs s2 has 2sigmas without affect on y" '((x . (h w))(w . (k y))(y . b)(z . (f y))) (psubsubs '((x . (h w))(w . (k y))) '((y . b)(z . (f y)))))

)

(defito ito-ssubsubs ()
 "ssubsubs s2 affects s1's ex and added s2 to. "
 (intend-equal "1 ssubsubs s1,s2 empty " () (ssubsubs () ()))
 (intend-equal "2 ssubsubs s1 empty" '((x . a)(y . (f x))) (ssubsubs () '((x . a)(y . (f x)))))
 (intend-equal "3 ssubsubs s2 empty" '((z . a)(y . (h a))) (ssubsubs '((z . a)(y . (h a))) ()))
 (intend-equal "4 ssubsubs disjoint var s1,s2" '((z . a)(w . (h a))(x . a)(y . (f x))) (ssubsubs '((z . a)(w . (h a))) '((x . a)(y . (f x)))))
)

(defito ito-all ()
  (ito-set "primitives snotation"
    (ito-isvar)
    (ito-prims)
    (ito-subst1s)
    (ito-psubsts)
    (ito-ssubsts)
    (ito-subsub1s)
    (ito-insigmas)
    (ito-diffsigmas)
    (ito-psubsubs)
    (ito-ssubsubs)
  )
)

(ito-all)

