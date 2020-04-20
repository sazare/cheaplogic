;;

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

(defun substs (vs e ss) 
  (cond
    ((null ss) e)
    (t (substs vs (subst1 vs e (car ss)) (cdr ss)))
  )
)


(defun substp (vs e es) 
  (psubst vs e (cons vs es))
)

(defun psubst (vs e ss)
  (cond
    ((null (car ss)) e)
    (t (psubst vs (subst1 vs e (cons (caar ss)(cadr ss))) (cons (cdar ss)(cddr ss))))
  )
)


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
 (format t "~a:~a ~a~%" vars e1 e2)
 m
)

(defun collect (vars e1 e2 m)
 vars
 (append m (list(cons e1 e2)))
)

(defun unific (vs d1 d2 m)
;; assume d1!=d2
  (cond
    ((isvar vs d1) (append m (list (cons d1 d2))))
    ((isvar vs d2) (append m (list (cons d2 d1))))
    (t 'NO)
  )
)


