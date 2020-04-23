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

(defun subst1 (e v1 e1)
  (cond
    ((atom e)
      (cond
        ((equal e v1) e1)
        (t e)))
    ((consp e) (cons (car e)(subst1* (cdr e) v1 e1)))
  )    
)

(defun subst1* (e* v1 e1)
  (cond
    ((null e*) ())
    (t (cons (subst1 (car e*) v1 e1) (subst1* (cdr e*) v1 e1)))
  )
)

(defun substs (e ss) 
  (cond
    ((null ss) e)
    (t (substs (subst1 e (caar ss)(cdar ss)) (cdr ss)))
  )
)

(defun subsubs1 (s v1 e1)
  (cond
    ((null s) ())
    (t (cons (cons (caar s)(subst1 (cdar s) v1 e1))
             (subsubs1 (cdr s) v1 e1)))
  )
)

(defun substp (vs e es) 
  (psubst vs e (cons vs es))
)

(defun psubst (vs e ss)
  (cond
    ((null (car ss)) e)
    (t (psubst vs (subst1 e (caar ss)(cadr ss)) (cons (cdar ss)(cddr ss))))
  )
)

;(defun substp1 (vs e s1)
;  (cond
;    ((atom e) 
;      (cond 
;        ((eq e (car s1)) (cdr s1))
;        (t  e)))
;     (t (cons (car e) (substp1* vs (cdr e) s1)))
;  )
;)
;
;(defun subsubp1 (vs ss v1 e1)
;  (subst1 vs ss (cons v1 e1))
;)
;
;;;;;
;
(defun disagree (vs e1 e2 fn)
  (disag vs e1 e2 () fn)
)

(defun disag (vs e1 e2 m fn)
  (cond
    ((equal e1 e2) ())
    ((atom e1) (funcall fn vs e1 e2 m))
    ((atom e2) (funcall fn vs e2 e1 m))
    ((not (eq (car e1)(car e2))) 'NO)
    (t (disag* vs (cdr e1)(cdr e2) m fn))
  )
)

(defun disag* (vs es1 es2 m fn)
  (cond 
    ((eq m 'NO) m)
    ((null es1) m)
    (t (disag* vs (cdr es1)(cdr es2) (disag vs (car es1)(car es2) m fn) fn))
  )
)

;(defun showit (vs e1 e2 m)
; (format t "~a:~a ~a~%" vs e1 e2)
; m
;)

(defun collect (vs e1 e2 m)
 vs
 (append m (list (cons e1 e2)))
)

(defun unific (vs d1 d2 m)
;; assume d1!=d2
  (cond
    ((isvar vs d1) (append m (list (cons d1 d2))))
    ((isvar vs d2) (append m (list (cons d2 d1))))
    (t 'NO)
  )
)


