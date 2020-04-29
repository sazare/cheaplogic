;;
(load "ito.lisp")
(load "load-disag.lisp")


(defito ito-subst1 ()
  "subst1 is subst for primitive e*x,t" 
  (intent-equal "1 subst1" 'b (subst1  'b 'x 'a))
  (intent-equal "2 subst1" 'a (subst1  'x 'x 'a))
  (intent-equal "3 subst1" '(f a) (subst1  '(f x) 'x 'a))
  (intent-equal "4 subst1" '(f a (h a)) (subst1  '(f x (h x)) 'x 'a))
) 

(defito ito-substs ()
  "substs is subst sequential e*((x . s)(y . t))"
  (intent-equal "1 substs" 'b (substs  'b '((x . a))))
  (intent-equal "2 substs" 'a (substs  'x '((x . a))))
  (intent-equal "3 substs" '(f a) (substs  '(f x) '((x . a))))
  (intent-equal "4 substs" '(f a (h a)) (substs  '(f x (h x)) '((x . a))))
  (intent-equal "5 substs" '(f b (h a)) (substs  '(f y (h x)) '((x . a)(y . b))))
  (intent-equal "6 substs" '(f b (h a)b) (substs  '(f y (h x)y) '((x . a)(y . b))))
)



(defito ito-subsubs1 ()
  "subsubs1 s*(x . e) "
  (intent-equal "1 subsubs1" '((x . b)) (subsubs1  '((x . b)) 'x 'a))
  (intent-equal "2 subsubs1" '((x . b)(y . a)) (subsubs1  '((x . b)) 'y 'a))
  (intent-equal "3 subsubs1" '((x . a)) (subsubs1  '((x . x)) 'x 'a))
  (intent-equal "4 subsubs1" '((z . (f a y))(x . a)) (subsubs1 '((z . (f x y))) 'x 'a))
  (intent-equal "5 subsubs1" '((z . (f a (h x)))(w . a)(y . a)) (subsubs1 '((z . (f y (h x)))(w . y)) 'y 'a))
)

(defito ito-subsubs1h ()
  "subsubs1h s*(x . e) "
  (intent-equal "1 subsubs1h" '((x . b)) (subsubs1h  '((x . b)) 'x 'a nil))
  (intent-equal "2 subsubs1h" '((x . b)(y . a)) (subsubs1h  '((x . b)) 'y 'a nil))
  (intent-equal "3 subsubs1h" '((x . a)) (subsubs1h  '((x . x)) 'x 'a nil))
  (intent-equal "4 subsubs1h" '((z . (f a y))(x . a)) (subsubs1h '((z . (f x y))) 'x 'a nil))
  (intent-equal "5 subsubs1h" '((z . (f a (h x)))(w . a)(y . a)) (subsubs1h '((z . (f y (h x)))(w . y)) 'y 'a nil))
  (intent-equal "6 subsubs1h" '((x . a)(y . b)(w . a)) (subsubs1h '((x . a)(y . b)(w . y)) 'y 'a nil))
)


(defito ito-subsubs1w ()
  "subsubs1w s*(x . e) "
  (intent-equal "1 subsubs1w" '((x . b)) (subsubs1w  '((x . b)) 'x 'a ))
  (intent-equal "2 subsubs1w" '((x . b)(y . a)) (subsubs1w  '((x . b)) 'y 'a ))
  (intent-equal "3 subsubs1w" '((x . a)) (subsubs1w  '((x . x)) 'x 'a))
  (intent-equal "4 subsubs1w" '((z . (f a y))(x . a)) (subsubs1w '((z . (f x y))) 'x 'a ))
  (intent-equal "5 subsubs1w" '((z . (f a (h x)))(w . a)(y . a)) (subsubs1w '((z . (f y (h x)))(w . y)) 'y 'a ))
  (intent-equal "6 subsubs1h" '((x . a)(y . b)(w . a)) (subsubs1w '((x . a)(y . b)(w . y)) 'y 'a ))
)

(defito ito-subsubs ()
  "subsubs s*((x . e)(y . f)) "
  (intent-equal "1 subsubs" '((x . b)) (subsubs  '((x . b)) '((x . a))))
  (intent-equal "2 subsubs" '((x . b)(y . a)) (subsubs  '((x . b)) '((y . a))))
  (intent-equal "3 subsubs" '((x . b)(y . c)(z . d)) (subsubs  '((x . b)(y . c)) '((y . a)(z . d))))
  (intent-equal "4 subsubs" '((x . (f a))(y . (g e))(z . d)) (subsubs  '((x . (f y))(y . (g x))) '((x . e)(y . a)(z . d))))

)
(defito ito-subsubsw ()
  "subsubsw s*((x . e)(y . f)) "
  (intent-equal "1 subsubsw" '((x . b)) (subsubsw  '((x . b)) '((x . a))))
  (intent-equal "2 subsubsw" '((x . b)(y . a)) (subsubsw  '((x . b)) '((y . a))))
  (intent-equal "3 subsubsw" '((x . b)(y . c)(z . d)) (subsubsw  '((x . b)(y . c)) '((y . a)(z . d))))
  (intent-equal "4 subsubsw" '((x . (f a))(y . (g e))(z . d)) (subsubsw  '((x . (f y))(y . (g x))) '((x . e)(y . a)(z . d))))

)

(defito ito-pnot ()
  "pnot don7t change vars, put/get v.e, vars way"
  (intent-equal "1 putpnot" '(b d d) (putpnot '(x y z) '(d d d)  'x 'b))
  (intent-equal "2 putpnot" '(d b d) (putpnot '(x y z) '(d d d)  'y 'b))
  (intent-equal "3 putpnot" '(d d b) (putpnot '(x y z) '(d d d)  'z 'b))
  (intent-equal "4 putpnot" '(d d d) (putpnot '(x y z) '(d d d)  'w 'b))
  (intent-equal "5 putpnot" '(d (f x) d) (putpnot '(x y z) '(d d d)  'y '(f x)))
)

(defito ito-substp1 ()
  "substp1 pnot with vars."
  (intent-equal "1 substp1" '(b d d) (substp1 '(x y z) '(d d d)  'x 'b))
  (intent-equal "2 substp1" '(d b d) (substp1 '(x y z) '(d d d)  'y 'b))
  (intent-equal "3 substp1" '(d d b) (substp1 '(x y z) '(d d d)  'z 'b))
  (intent-equal "4 substp1" '(d d d) (substp1 '(x y z) '(d d d)  'w 'b))
  (intent-equal "5 substp1" '(d (f x) d) (substp1 '(x y z) '(d d d)  'y '(f x)))
)

(defito ito-substp ()
  "substp is subst parallel e*s"
  (intent-equal "1 substp" 'b (substp '(x) 'b '(a)))
  (intent-equal "2 substp" 'a (substp '(x) 'x '(a)))
  (intent-equal "3 substp" '(f a) (substp '(x) '(f x) '(a)))
  (intent-equal "4 substp" '(f a (h a)) (substp '(x) '(f x (h x)) '(a)))
  (intent-equal "5 substp" '(f b (h a)) (substp '(x y) '(f y (h x)) '(a b)))
)


(defito ito-subsubp1 ()
  "subsubp1 s*([x].[e]) "
  (intent-equal "1 subsubp1" '(b y) (subsubp1 '(x y) '(x y) 'x 'b))
  (intent-equal "2 subsubp1" '(x b) (subsubp1 '(x y) '(x y) 'y 'b))
  (intent-equal "3 subsubp1" '(x y) (subsubp1 '(x y) '(x y) 'z 'b))

  (intent-equal "4 subsubp1" '((f c) y) (subsubp1 '(x y) '(x y) 'x '(f c)))
  (intent-equal "5 subsubp1" '((f c) b) (subsubp1 '(x y) '(x b) 'x '(f c)))
  (intent-equal "6 subsubp1" '(b (f b)) (subsubp1 '(x y) '(x (f x)) 'x 'b))


)

(defito ito-subsubp ()
  "subsubp s*((x y) . (s t)) as (x y).(s*(s t)) "

  (intent-equal "1 subsubp" '(a b) (subsubp '(x y) '(x b) '(a y)))
  (intent-equal "2 subsubp" '(a b) (subsubp '(x y) '(x b) '(a y)))
  (intent-equal "3 subsubp" '((f a)(g b)) (subsubp '(x y) '((f x)(g y)) '(a b)))

  (intent-equal "4 subsubp dubious" '((f x)(g x)) (subsubp '(x y) '((f x)(g y)) '(y x)))
)


;(defun myfun ()
;  "for my fun"
;  (disagree () 'a 'a () #'showit)
;  (disagree () 'a 'b () #'showit)
;  (disagree () '(f a) '(g a) () #'showit)
;  (disagree () '(f a) '(f b) () #'showit)
;  (disagree '(x) '(f x) '(f b) () #'showit)
;)

(defito ito-disagree-collect ()
  "disagree collect are itos for disagree"
  (intent-equal "1 disagree" '() (disagree () 'a 'a () #'collect))
  (intent-equal "2 disagree" '((a . b)) (disagree () 'a 'b () #'collect))
  (intent-equal "3 disagree" 'NO (disagree () '(f a) '(g a) () #'collect))
  (intent-equal "4 disagree" '((a . b)) (disagree () '(f a) '(f b) () #'collect))
  (intent-equal "5 disagree" '((x . b)) (disagree '(x) '(f x) '(f b) () #'collect))
  (intent-equal "6 disagree" '((x . b)) (disagree '(x) '(f x) '(f b) () #'collect))
  (intent-equal "7 disagree" '((x . b)(y . a)) (disagree '(x y) '(f x (h y)) '(f b (h a)) () #'collect))
  (intent-equal "8 disagree" '((x . (g a))(y . a)) (disagree '(x y) '(f x (h y)) '(f (g a) (h a)) () #'collect))
  (intent-equal "9 disagree" '((x . (h y))(y . (g w))) (disagree '(x y) '(f (h y) (h y)) '(f x (h (g w))) ()  #'collect))
) 

(defito ito-disagree-unific ()
  "disagree unific is a unify ito"
  (intent-equal "010 disagree" '() (disagree () 'a 'a () #'unifics))
  (intent-equal "011 disagree" 'NO (disagree () 'a 'b () #'unifics))
  (intent-equal "012 disagree" 'NO (disagree '(x) 'a 'b () #'unifics))
  (intent-equal "013 disagree" '((x . (h b))) (disagree '(x) '(f x) '(f (h b)) () #'unifics))
  (intent-equal "013b disagree" '((x . (h b))) (disagree '(x) '(f (h b)) '(f x) () #'unifics))
  (intent-equal "014 disagree" '((x . a)(y . a)) (disagree '(x y) '(f x (g x)) '(f y (g a)) () #'unifics))
  (intent-equal "015 disagree" '((x . (g a))(y . (g a))) (disagree '(x y) '(f x x) '(f y (g a)) () #'unifics))
)

(defito ito-unifys ()
  "unifys is snot unify"
  (intent-equal "010 unifys" '() (unifys () 'a 'a))
  (intent-equal "011 unifys" 'NO (unifys () 'a 'b))
  (intent-equal "012 unifys" 'NO (unifys '(x) 'a 'b))
  (intent-equal "013 unifys" '((x . (h b))) (unifys '(x) '(f x) '(f (h b))))
  (intent-equal "013b unifys" '((x . (h b))) (unifys '(x) '(f (h b)) '(f x)))
  (intent-equal "014 unifys" '((x . a)(y . a)) (unifys '(x y) '(f x (g x)) '(f y (g a))))
  (intent-equal "015 unifys" '((x . (g a))(y . (g a))) (unifys '(x y) '(f x x) '(f y (g a))))
)

(defito ito-unifyp ()
  "unifys is pnot unify"
  (intent-equal "010 unifyp" '() (unifyp () 'a 'a))
  (intent-equal "011 unifyp" 'NO (unifyp () 'a 'b))
  (intent-equal "012 unifyp" 'NO (unifyp '(x) 'a 'b))
  (intent-equal "013 unifyp" '((h b)) (unifyp '(x) '(f x) '(f (h b))))
  (intent-equal "013b unifyp" '((h b)) (unifyp '(x) '(f (h b)) '(f x)))
  (intent-equal "014 unifyp" '(a a)  (unifyp '(x y) '(f x (g x)) '(f y (g a))))
  (intent-equal "015 unifyp" '((g a) (g a)) (unifyp '(x y) '(f x x) '(f y (g a))))
)



(ito-disagree-collect)
(ito-subst1)
(ito-substs)

(ito-subsubs1h)
(ito-subsubs1)
(ito-subsubs)

(ito-subsubs1w)
(ito-subsubsw)

(ito-pnot)
(ito-substp1)
(ito-substp)

(ito-subsubp1)
(ito-subsubp)
(ito-disagree-unific)
(ito-unifys)
(ito-unifyp)


