;;
(load "test.lisp")

(defun isvar (vars sym)
  (member sym vars)
)

(defun vof (s) (car s))
(defun exof (s) (cdr s))
(defun issym (e) (atom e))
(defun sigma (v e) (cons v e))

(defun fof (e) (car e))
(defun e*of (e) (cdr e))
(defun form (f as) (cons f as))

(defun subst1 (vs e s1) ;; s1 = (v . e)
  (cond
    ((atom e)
      (cond
        ((equal e (vof s1)) (exof s1))
        (t e)))
    ((consp e) (cons (car e)(subst1* vs (cdr e) s1)))
  )    
)

(defun subst1* (vs e* s1)
  (cond
    ((null e*) ())
    (t (cons (subst1 vs (car e*) s1) (subst1* vs (cdr e*) s1)))
  )
)

(expect-equal "1 subst1" 'b (subst1 '(x) 'b '(x . a)))
(expect-equal "2 subst1" 'a (subst1 '() 'x '(x . a)))
(expect-equal "3 subst1" '(f a) (subst1 '(x) '(f x) '(x . a)))
(expect-equal "4 subst1" '(f a (h a)) (subst1 '(x) '(f x (h x)) '(x . a)))

(defun substp (vs e ss) 
  (cond
    ((null ss) e)
    (t (substp vs (subst1 vs e (car ss)) (cdr ss)))
  )
)

(expect-equal "1 substp" 'b (substp '(x) 'b '((x . a))))
(expect-equal "2 substp" 'a (substp '() 'x '((x . a))))
(expect-equal "3 substp" '(f a) (substp '(x) '(f x) '((x . a))))
(expect-equal "4 substp" '(f a (h a)) (substp '(x) '(f x (h x)) '((x . a))))
(expect-equal "5 substp" '(f b (h a)) (substp '(x) '(f y (h x)) '((x . a)(y . b))))


;;;;

(defun disagree (vars e1 e2 fn)
  (disag vars e1 e2 () fn)
)

(defun disag (vars e1 e2 m fn)
  (cond
    ((equal e1 e2) ())
    ((atom e1) (funcall fn vars e1 e2 m))
    ((atom e2) (funcall fn vars e2 e1 m))
    ((not (eq (car e1)(car e2))) 'NO)
    (t (disag* vars (cdr e1)(cdr e2) m fn))
  )
)

(defun disag* (vars es1 es2 m fn)
  (cond 
    ((eq m 'NO) m)
    ((null es1) m)
    (t (disag* vars (cdr es1)(cdr es2) (disag vars (car es1)(car es2) m fn) fn))
  )
)

(defun showit (vars e1 e2 m)
 (format t "~a ~a~%" e1 e2)
 m
)

(defun collect (vars e1 e2 m)
 (append m (list(cons e1 e2)))
)

(disagree () 'a 'a #'showit)
(disagree () 'a 'b #'showit)
(disagree () '(f a) '(g a) #'showit)
(disagree () '(f a) '(f b) #'showit)
(disagree '(x) '(f x) '(f b) #'showit)

(expect-equal "1 disagree" '() (disagree () 'a 'a #'collect))
(expect-equal "2 disagree" '((a . b)) (disagree () 'a 'b #'collect))
(expect-equal "3 disagree" 'NO (disagree () '(f a) '(g a) #'collect))
(expect-equal "4 disagree" '((a . b)) (disagree () '(f a) '(f b) #'collect))
(expect-equal "5 disagree" '((x . b)) (disagree '(x) '(f x) '(f b) #'collect))
(expect-equal "6 disagree" '((x . b)) (disagree '(x) '(f x) '(f b) #'collect))
(expect-equal "7 disagree" '((x . b)(y . a)) (disagree '(x y) '(f x (h y)) '(f b (h a)) #'collect))
(expect-equal "8 disagree" '((x . (g a))(y . a)) (disagree '(x y) '(f x (h y)) '(f (g a) (h a)) #'collect))
(expect-equal "9 disagree" '((x . (h y))(y . (g w))) (disagree '(x y) '(f (h y) (h y)) '(f x (h (g w))) #'collect))

(defun unific (vs d1 d2 m)
;; assume d1!=d2
  (cond
    ((isvar vs d1) (append m (list (cons d1 d2))))
    ((isvar vs d2) (append m (list (cons d2 d1))))
    (t 'NO)
  )
)


(expect-equal "010 disagree" '() (disagree () 'a 'a #'unific))
(expect-equal "011 disagree" 'NO (disagree () 'a 'b #'unific))
(expect-equal "012 disagree" 'NO (disagree '(x) 'a 'b #'unific))
(expect-equal "013 disagree" '((x . (h b))) (disagree '(x) '(f x) '(f (h b)) #'unific))
(expect-equal "014 disagree" '((x . (g a))(y . a)) (disagree '(x y) '(f x (g x)) '(f y (g a)) #'unific))

