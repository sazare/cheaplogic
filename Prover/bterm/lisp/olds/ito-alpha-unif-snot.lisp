;; ito for alpha
;; how to write these ito in consice and complete
;; notation [vi<-ei,...]

(myload "ito.lisp")

(load "load-alpha-prim-snot.lisp")
(load "load-alpha-unif-snot.lisp")

(format t "[alpha is a implementation of subst and subsub variations and snotation]~%")

;;
(defito ito-disagree ()
 "disagree finds unmatch point in 2 exps"
 (intend-equal "1a identical a" () (disagree 'a 'a))
 (intend-equal "1b identical a b" () (disagree '(f a b) '(f a b)))
 (intend-equal "1d identical indepth" () (disagree '(f (f x) (h y)) '(f (f x)(h y))))

;both symbol
 (intend-equal "diff con" '(a . b) (disagree 'a 'b))

; sym vs. fterm
 (intend-equal "sym vs R fterm" '(a . (f b)) (disagree 'a '(f b)))
 (intend-equal "L fterm vs sym" '((f x) . b) (disagree '(f x) 'b))
 (intend-equal "both fterms diff sym" '((f x) . (g a)) (disagree '(f x) '(g a)))
 (intend-equal "sym sym in depth" '(x . a) (disagree '(f x) '(f a)))
 (intend-equal "sym ftermin depth" '(x . (h a)) (disagree '(f x) '(f (h a))))
 (intend-equal "fterm vs sym in depth" '((h a) . x) (disagree '(f (h a)) '(f x)))
 (intend-equal "sym vs sym in 2 depth" '(a . (g x)) (disagree '(f (h a)) '(f (h (g x)))))

)

(defito ito-insidep ()
 "insidep holds when x appears < e not x=e"
 (intend-f "1 not insidep x x"  (insidep 'x 'x))
 (intend-f "2 not insidep x y"  (insidep 'x 'y))
 (intend-f "3 not insidep x in fterm"  (insidep 'x '(f y)))
 (intend-f "4 not insidep x in wide fterm"  (insidep 'x '(f y w z)))
 (intend-f "5 not insidep x in wide fterm"  (insidep 'x '(f y (h w z) z)))

 (intend-t "6 not insidep x fterm[x]"  (insidep 'x '(f x (h x w) z)))
 (intend-t "7 not insidep x fterm[x]"  (insidep 'x '(f y (h x w) z)))
)

(defito ito-unifiable ()
 "unifiable prerequisit: e1 != e2"

 (intend-equal "" 'NO (unifiable '(x) 'b 'a))
 (intend-equal "" '(x . b) (unifiable '(x) 'b 'x))
 (intend-equal "" '(x . a) (unifiable '(x) 'x 'a))
 (intend-equal "" '(x . (f a)) (unifiable '(x) 'x '(f a)))
 (intend-equal "" 'NO (unifiable '(x) 'x '(f x)))

)

(defito ito-emptysigma ()
 "emptysigma is [(vi.ei)...] or []"
  (intend-equal "empty vs" '() (emptysigma ()))
  (intend-equal "var " '((x . x)) (emptysigma '(x)))
  (intend-equal "3vars" '((x . x)(y . y)(z . z)) (emptysigma '(x y z)))


)

(defito ito-unifys ()
 "unifys find unifier for 2 s-not exps or NO"
; symbol
 (intend-equal "1 equal make null sigma" '() (unifys '() 'a 'a))
 (intend-equal "2 equal make null sigma" '((a . a)) (unifys '(a) 'a 'a))
 (intend-equal "3 equal make null sigma" '((x . x)) (unifys '(x) 'a 'a))
 (intend-equal "4 var to const s" '((x . a)) (unifys '(x) 'x 'a))

 (intend-equal "5a equal make null sigma" 'NO (unifys '() 'a 'b))
 (intend-equal "5b equal make null sigma" 'NO (unifys '(x y) 'a 'b))

; mix to NO
 (intend-equal "6a equal make null sigma" 'NO (unifys '(x y) '(f x) 'b))
 (intend-equal "6b equal make null sigma" 'NO (unifys '(x y) 'c '(f x)))
 (intend-equal "6c equal make null sigma" 'NO (unifys '(x y) '(f x) '(g y)))
 (intend-equal "6d equal make null sigma" 'NO (unifys '() '(f a) '(g a)))
 (intend-equal "6e equal make null sigma" 'NO (unifys '() '(f a) '(f b)))
 (intend-equal "6f equal make null sigma" 'NO (unifys '(x y) '(f (k a)) '(f (h b))))
 (intend-equal "6f equal make null sigma" 'NO (unifys '(x y) '(f (k a)) '(f b)))
 (intend-equal "6f equal make null sigma" 'NO (unifys '(x y) '(f a) '(f (h b))))

; fterm
 (intend-equal "7 var to const with f" '((x . a)) (unifys '(x) '(f x) '(f a)))
 (intend-equal "7a var to const with f" '((x . a)) (unifys '(x) '(f x x) '(f a a)))

 (intend-equal "8 var to const with f 2paths" '((x . a) (y . a)) (unifys '(x y) '(f x x) '(f a y)))
 (intend-equal "8a var to const with f 2paths" '((x . a) (y . a)) (unifys '(x y) '(f x x) '(f y a)))

 (intend-equal "9 var to const with f v2v after" '((x . a)(y . a)(z . b)) (unifys '(x y z) '(f x x z) '(f a y b)))
 (intend-equal "10 var to const with f v2v first" '((x . a)(y . a)(z . b)) (unifys '(x y z) '(f x x z) '(f y a b)))
 
 (intend-equal "11a go and back in 3" '((x . x)(y . (k (g x)))(z . (g x))(w . (k (g x)))) (unifys '(x y z w) '(f (g x) y (h y)) '(f z (k z) (h w))))

 (intend-equal "11b go and back in 3" '((x . x)(y . (k (g x)))(z . (g x))(w . (k (g x)))) (unifys '(x y z w) '(f (h y) y (g x)) '(f (h w) (k z) z)))

 (intend-equal "12a 4" 
   '((x . (k (k (g w))))(y . (k (k (g w))))(z . (k (g w)))(w . w)(n . (g (k (k (g w))))))
  (unifys '(x y z w n) 
    '(f (g x) y    (h z)        (g y)) 
    '(f n    (k z) (h (k (g w))) n))) 

 (intend-equal "12b reverse in 4" 
   '((x . (k (k (g w))))(y . (k (k (g w))))(z . (k (g w)))(w . w)(n . (g (k (k (g w))))))
    (unifys '(x y z w n) '(f (g y) (h z) y (g x)) '(f n (h (k (g w))) (k z) n)))

 (intend-equal "13 equal make null sigma" 'NO (unifys '(x y) '(f x x) '(f (h y) y)))

 (intend-equal "14 x->z->y->n->x but not inside"
   '((x . x)(y . (k (p x)))(z . (p x))(w . w)(n . (k (p x))))
    (unifys '(x y z w n) 
      '(f (g y) (h (p x)) y     (k (p x))) 
      '(f (g n) (h z)     (k z) n))
 )
)

;;; all itos
(defito ito-all ()
  (ito-set "ito uification"
    (ito-disagree)
    (ito-insidep)
    (ito-unifiable)
    (ito-emptysigma)
    (ito-unifys)
  )
)

(ito-all)

