;; test for alpha
;; how to write these test in consice and complete
;; notation [vi<-ei,...]

(load "test.lisp")

(load "load-alpha-prim-snot.lisp")
(load "load-alpha-unif-snot.lisp")

(format t "[alpha is a implementation of subst and subsub variations and snotation]~%")

;;
(deftest test-disagree ()
 "disagree finds unmatch point in 2 exps"
 (expect-equal "1a identical a" () (disagree 'a 'a))
 (expect-equal "1b identical a b" () (disagree '(f a b) '(f a b)))
 (expect-equal "1d identical indepth" () (disagree '(f (f x) (h y)) '(f (f x)(h y))))

;both symbol
 (expect-equal "diff con" '(a . b) (disagree 'a 'b))

; sym vs. fterm
 (expect-equal "sym vs R fterm" '(a . (f b)) (disagree 'a '(f b)))
 (expect-equal "L fterm vs sym" '((f x) . b) (disagree '(f x) 'b))
 (expect-equal "both fterms diff sym" '((f x) . (g a)) (disagree '(f x) '(g a)))
 (expect-equal "sym sym in depth" '(x . a) (disagree '(f x) '(f a)))
 (expect-equal "sym ftermin depth" '(x . (h a)) (disagree '(f x) '(f (h a))))
 (expect-equal "fterm vs sym in depth" '((h a) . x) (disagree '(f (h a)) '(f x)))
 (expect-equal "sym vs sym in 2 depth" '(a . (g x)) (disagree '(f (h a)) '(f (h (g x)))))

)

(deftest test-insidep ()
 "insidep holds when x appears < e not x=e"
 (expect-f "1 not insidep x x"  (insidep 'x 'x))
 (expect-f "2 not insidep x y"  (insidep 'x 'y))
 (expect-f "3 not insidep x in fterm"  (insidep 'x '(f y)))
 (expect-f "4 not insidep x in wide fterm"  (insidep 'x '(f y w z)))
 (expect-f "5 not insidep x in wide fterm"  (insidep 'x '(f y (h w z) z)))

 (expect-t "6 not insidep x fterm[x]"  (insidep 'x '(f x (h x w) z)))
 (expect-t "7 not insidep x fterm[x]"  (insidep 'x '(f y (h x w) z)))
)

(deftest test-unifiable ()
 "unifiable prerequisit: e1 != e2"

 (expect-equal "" 'NO (unifiable '(x) 'b 'a))
 (expect-equal "" '(x . b) (unifiable '(x) 'b 'x))
 (expect-equal "" '(x . a) (unifiable '(x) 'x 'a))
 (expect-equal "" '(x . (f a)) (unifiable '(x) 'x '(f a)))
 (expect-equal "" 'NO (unifiable '(x) 'x '(f x)))

)

(deftest test-emptysigma ()
 "emptysigma is [(vi.ei)...] or []"
  (expect-equal "empty vs" '() (emptysigma ()))
  (expect-equal "var " '((x . x)) (emptysigma '(x)))
  (expect-equal "3vars" '((x . x)(y . y)(z . z)) (emptysigma '(x y z)))


)

(deftest test-unifys ()
 "unifys find unifier for 2 s-not exps or NO"
; symbol
 (expect-equal "1 equal make null sigma" '() (unifys '() 'a 'a))
 (expect-equal "2 equal make null sigma" '((a . a)) (unifys '(a) 'a 'a))
 (expect-equal "3 equal make null sigma" '((x . x)) (unifys '(x) 'a 'a))
 (expect-equal "4 var to const s" '((x . a)) (unifys '(x) 'x 'a))

 (expect-equal "5a equal make null sigma" 'NO (unifys '() 'a 'b))
 (expect-equal "5b equal make null sigma" 'NO (unifys '(x y) 'a 'b))

; mix to NO
 (expect-equal "6a equal make null sigma" 'NO (unifys '(x y) '(f x) 'b))
 (expect-equal "6b equal make null sigma" 'NO (unifys '(x y) 'c '(f x)))
 (expect-equal "6c equal make null sigma" 'NO (unifys '(x y) '(f x) '(g y)))
 (expect-equal "6d equal make null sigma" 'NO (unifys '() '(f a) '(g a)))
 (expect-equal "6e equal make null sigma" 'NO (unifys '() '(f a) '(f b)))
 (expect-equal "6f equal make null sigma" 'NO (unifys '(x y) '(f (k a)) '(f (h b))))
 (expect-equal "6f equal make null sigma" 'NO (unifys '(x y) '(f (k a)) '(f b)))
 (expect-equal "6f equal make null sigma" 'NO (unifys '(x y) '(f a) '(f (h b))))

; fterm
 (expect-equal "7 var to const with f" '((x . a)) (unifys '(x) '(f x) '(f a)))
 (expect-equal "7a var to const with f" '((x . a)) (unifys '(x) '(f x x) '(f a a)))

 (expect-equal "8 var to const with f 2paths" '((x . a) (y . a)) (unifys '(x y) '(f x x) '(f a y)))
 (expect-equal "8a var to const with f 2paths" '((x . a) (y . a)) (unifys '(x y) '(f x x) '(f y a)))

 (expect-equal "9 var to const with f v2v after" '((x . a)(y . a)(z . b)) (unifys '(x y z) '(f x x z) '(f a y b)))
 (expect-equal "10 var to const with f v2v first" '((x . a)(y . a)(z . b)) (unifys '(x y z) '(f x x z) '(f y a b)))
 
 (expect-equal "11a go and back in 3" '((x . x)(y . (k (g x)))(z . (g x))(w . (k (g x)))) (unifys '(x y z w) '(f (g x) y (h y)) '(f z (k z) (h w))))

 (expect-equal "11b go and back in 3" '((x . x)(y . (k (g x)))(z . (g x))(w . (k (g x)))) (unifys '(x y z w) '(f (h y) y (g x)) '(f (h w) (k z) z)))

 (expect-equal "12a 4" 
   '((x . (k (k (g w))))(y . (k (k (g w))))(z . (k (g w)))(w . w)(n . (g (k (k (g w))))))
  (unifys '(x y z w n) 
    '(f (g x) y    (h z)        (g y)) 
    '(f n    (k z) (h (k (g w))) n))) 

 (expect-equal "12b reverse in 4" 
   '((x . (k (k (g w))))(y . (k (k (g w))))(z . (k (g w)))(w . w)(n . (g (k (k (g w))))))
    (unifys '(x y z w n) '(f (g y) (h z) y (g x)) '(f n (h (k (g w))) (k z) n)))

 (expect-equal "13 equal make null sigma" 'NO (unifys '(x y) '(f x x) '(f (h y) y)))

 (expect-equal "14 x->z->y->n->x but not inside"
   '((x . x)(y . (k (p x)))(z . (p x))(w . w)(n . (k (p x))))
    (unifys '(x y z w n) 
      '(f (g y) (h (p x)) y     (k (p x))) 
      '(f (g n) (h z)     (k z) n))
 )
)

;;; all tests
(deftest test-all ()
  (test-set "test uification"
    (test-disagree)
    (test-insidep)
    (test-unifiable)
    (test-emptysigma)
    (test-unifys)
  )
)

(test-all)

