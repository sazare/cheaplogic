;; ito for alpha
;; how to write these ito in consice and complete
;; notation [vi<-ei,...]
(format t "~%NOT WORK~%")
(quit)

(myload "ito.lisp")

(load "load-alpha-pnot.lisp")

(format t "[alpha is a implementation of subst and subsub variations with p notation]~%")

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
;; ptype of subst1p
 (intend-equal "1 vsof" '(a) (vof '((a).(b))))
 (intend-equal "2 exof" '(b) (exof '((a).(b))))
 (intend-equal "3 exof" '((f b)) (exof '((a) . ((f b)))))

 (intend-t "4 issym"  (issym 'x))
 (intend-f "5 issym"  (issym '(f x)))

 (intend-equal "6 sigma" '(a . (f g)) (sigma 'a '(f g)))

 (intend-equal "7 fof" 'f (fof '(f a)))
 (intend-equal "8 e*of" '(x (h a)) (e*of '(f x (h a))))
 (intend-equal "9 e*of" () (e*of '(f)))
 (intend-equal "10 form" '(f x y) (form 'f '(x y)))
)

(defito ito-subst1p ()
 "subst1p s2 is just a sigma"
 (intend-equal "1 subst1p unmatch s" 'x (subst1 'x '((a) . (b))))
 (intend-equal "2 subst1p match s" 'b (subst1 'a '((a) . (b))))
 (intend-equal "3 subst1p unmatch f" '(f x y) (subst1 '(f x y)  '((a) . (b))))
 (intend-equal "4 subst1p 2match" '(f b b) (subst1 '(f a a)  '((a) . (b))))
 (intend-equal "5 subst1p match in depth but not f" '(f (a x) (h b (g b))) (subst1 '(f (a x)(h a (g a)))  '((a) . (b))))
)

(defito ito-psubstp ()
 "psubstp s2 not affect s1's ex, and add s2 to s1 when s2's v is not in s1"
 (intend-equal "1 psubstp empty sigma is (().())" 'x (psubstp 'x '(().())))
 (intend-equal "1x psubstp empty sigma also be ((x).(x))" 'x (psubstp 'x '((x).(x))))
 (intend-equal "2 psubstp unmatch s" 'x (psubstp 'x '((a) . (b))))
 (intend-equal "3 psubstp match single s" 'c (psubstp 'x '((x) . (c))))
 (intend-equal "5 psubstp match 2nd s" 'k (psubstp 'x '((y x) . (d k))))
 (intend-equal "6 psubstp match 1st s" 'd (psubstp 'y '((y x) . (d k))))

 (intend-equal "7 psubstp match 2, 2nd" '(f k k)  (psubstp '(f x x) '((y x) . (d k))))
 (intend-equal "8 psubstp match 2nd, in depth" '(f k (h k))  (psubstp '(f x (h x)) '((y x) . (d k))))

 (intend-equal "9 psubstp match 2, 2match" '(f k (h d))  (psubstp '(f x (h y)) '((y x) . (d k))))
 (intend-equal "10 psubstp match xyx" '(f k (h d k))  (psubstp '(f x (h y x)) '((y x) . (d k))))
 (intend-equal "11 psubstp match 2 in detpth" '(f z (h d k))  (psubstp '(f z  (h y x)) '((y x) . (d k))))
 (intend-equal "12 psubstp long symbols" '(f z01 (h11 d20 k9))  (psubstp '(f z01 (h11 y1 x2)) '((y1 x2) . (d20 k9))))
 (intend-equal "13 psubstp long symbols, long dup sigma. prerequisit not confirmed" '(f z01 (h11 d20 k9))  (psubstp '(f z01 (h11 y1 x2)) '((y1 x2 y1 x2) . (d20 k9 y1 aa))))
)

(defito ito-ssubstp ()
 "ssubstp apply s2 to every s1's ex and add s2 to s1 when s2's v is not in s1. [a b]<-... a,b has order"
 (intend-equal "1 ssubstp empty sigma s" 'x (ssubstp 'x '(().())))
 (intend-equal "1x ssubstp empty sigma s" 'x (ssubstp 'x '((x).(x))))
 (intend-equal "2 ssubstp match s" 'a (ssubstp 'x '((x).(a))))
 (intend-equal "3 ssubstp match to fterm" '(f (g z)) (ssubstp 'x '((x w).((f w) (g z)))))
 (intend-equal "4 ssubstp in match x->w->z" '(f (g z)) (ssubstp 'x '((x y w).((f w) a (g z)))))
 (intend-equal "5 ssubstp before dosent affect after sig" '(f w a) (ssubstp 'x '((w x y).((g z) (f w y) a))))
 (intend-equal "6 ssubstp w before, after effects med" '(q (f (g z)) a z (h a)) (ssubstp '(q x y z w) '((w x y w).((h y) (f w) a (g z)))))
)

(defito ito-subsub1p ()
 "subsub1p s1 x s2 but s2 is single. added s2 to s1 when s2's var not in s1. symbols appended??"
 (intend-equal "1 subsub1p s1 is empty" '((x).(a)) (subsub1p '(().()) '((x).(a))))
 (intend-equal "2 subsub1p not add and effect same s" '((x).(a)) (subsub1p '((x).(a)) '((x).(b))))
 (intend-equal "3 subsub1p add s2, and affect to s1 on y" '((x y z w).(a c (f w b) b)) (subsub1p '((x y z w).(a c (f w y) y)) '((y).(b))))
 (intend-equal "4 subsub1p not same sym, just added" '((x y).(a b)) (subsub1p '((x).(a)) '((y).(b))))
 (intend-equal "5 subsub1p add s2, and affect to s1 on y" '((x z w y).(a (f w b) b b)) (subsub1p '((x z w y).(a (f w y) y)) '((y).(b))))
)

(defito ito-insigmap ()
 "insigmap(v s) itos v in s"
 (intend-f "1 insigmap sigma empty" (insigmap 'x '()))
 (intend-t "2 insigmap v in sigma " (insigmap 'x '((x).(a))))
 (intend-f "3 insigmap not v in sigma" (insigmap 'x '((y).(a))))
 (intend-t "4 insigmap v in sigma many " (insigmap 'x '((y x).(g a))))
 (intend-f "5 insigmap v not in sigma many " (insigmap 'z '((y x).(g a))))
)


(defito ito-psubsubp ()
 "psubsubp s1 add s2 when s2's var not in s1. s1's ex isn't affeced by s2"
 (intend-equal "1 psubsubp s1, s2 empty" '(().()) (psubsubp '(().()) '(().())))
 (intend-equal "1 psubsubp s1, s2 empty" '((x).(x)) (psubsubp '((x))) '(().()))
 (intend-equal "1 psubsubp s1, s2 empty" '((x).(x)) (psubsubp '(().()) '((x).(x))))
 (intend-equal "1 psubsubp s1, s2 empty" '((x).(x)) (psubsubp '((x).(x)) '((x).(x))))
 (intend-equal "2 psubsubp s1 empty" '((x).(a)) (psubsubp '(().()) '((x).(a))))
 (intend-equal "3 psubsubp s2 empty" '((x).(a)) (psubsubp '((x).(a)) '(().())))
 (intend-equal "3 psubsubp s2 empty" '((x).(a)) (psubsubp '((x).(a)) '((x).(a))))

 (intend-equal "4 psubsubp just add diff syms" '((x y).(a b)) (psubsubp '((x).(a)) '((y).(b))))
 (intend-equal "5 psubsubp just add 2+1 e has f, s2's e is sym" '((x z y).(a (h a) b)) (psubsubp '((x z y).(a (h a))) b))
 (intend-equal "6 psubsubp s2 has 2sigmas just add" '((x y z).(a b (f c))) (psubsubp '((x).(a)) '((y z).(b (f c)))))

;; 7 and 8 are out conditioned sigmas
 (intend-equal "7 psubsubp without same s" '((x y w z).((h w) (j y) (k y) (f c))) (psubsubp '((x y w).((h w) (j y) (k y))) '((y z).(b (f c)))))
 (intend-equal "8 psubsubp s2 has 2sigmas without affect on y" '((x w y z).((h w) (k y) b (f y))) (psubsubp '((x w y z).((h w) (k y))) '((y z).(b (f y)))))

)

(defito ito-ssubsubp ()
 "ssubsubp s2 affects s1's ex and added s2 to. "
 (intend-equal "1 ssubsubp s1,s2 empty " '(().()) (ssubsubp '(().()) '(().())))
 (intend-equal "2 ssubsubp s1 empty" '((x y).(a (f x))) (ssubsubp '(().()) '((x y).(a (f x)))))
 (intend-equal "3 ssubsubp s2 empty" '((z y).(a (h a))) (ssubsubp '((z y).(a (h a))) '(().())))
 (intend-equal "4 ssubsubp disjoint var s1,s2" '((z w x y).(a (h a) a (f x))) (ssubsubp '((z w).(a (h a))) '((x y).(a (f x)))))
)


;;
;;(defito ito-unify ()
;; "itos for unify"
;; (intend-equal "1 equal make null sigma" '() (unify '() 'a 'a))
;; (intend-equal "2 equal make null sigma" '((a) . (a)) (unify '(a) 'a 'a))
;; (intend-equal "3 equal make null sigma" '((x) . (x)) (unify '(x) 'a 'a))
;; (intend-equal "4 equal make null sigma" 'NO (unify '() 'a 'b))
;; (intend-equal "5 equal make null sigma" 'NO (unify '(x y) 'a 'b))
;;
;; (intend-equal "6 var to const s" '((x) . (a)) (unify '(x) 'x 'a))
;; (intend-equal "7 var to const with f" '((x) . (a)) (unify '(x) '(f x) '(f a)))
;; (intend-equal "8 var to const with f 2paths" '((x y) . (a a)) (unify '(x y) '(f x x) '(f a y)))
;;
;; (intend-equal "9 var to const with f v2v after" '((x y z) . (a a b)) (unify '(x y z) '(f x x z) '(f a y b)))
;; (intend-equal "10 var to const with f v2v first" '((x y z) . (a a b)) (unify '(x y z) '(f x x z) '(f y a b)))
;; 
;; (intend-equal "11 go and back in 4" '((x y z w) . (x (k (g x))(g x) (k (g x)))) (unify '(x y z w) '(f (g x) y (h y)) '(f z (k z) (h w))))
;;
;; (intend-equal "12 go and back in 4" '((x y z w n) . ( (k (g x)) (g x) (k (g x)) (p (g x)))) (unify '(x y z w n) '(f (g x) y (h y) (p y)) '(f z (k z) (h w) n)))
;;
;; (intend-equal "equal make null sigma" 'NO (unify '(x y) '(f x x) '(f (h y) y)))
;;
;;)

(defito ito-all()
 (ito-set "alpha unification"
  (ito-isvar)
  (ito-prims)
  (ito-subst1p)
  (ito-psubstp)
  (ito-ssubstp)
  (ito-subsub1p)
  (ito-insigmap)
  (ito-psubsubp)
  (ito-ssubsubp)

;  (ito-unify)
 )
)

(ito-all)

