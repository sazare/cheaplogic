;;; alpha is a unification

(defun isvar (vars sym)
  (member sym vars)
)

(defun vof (s) (car s))
(defun eof (s) (cdr s))
(defun issym (e) (atom e))
(defun sigma (v e) (cons v e))

(defun fof (e) (car e))
(defun e*of (e) (cdr e))
(defun form (f as) (cons f as))

;;; substitution

(defun subst1 (e s1)
 (cond 
  ((eq e (vof s1)) (eof s1))
  ((issym e) e)
  (t (form (fof e) (subst1* (e*of e) s1)))
 )
)

(defun subst1* (e* s1)
 (cond
  ((null e*) ())
  (t (cons (subst1 (car e*) s1) (subst1* (cdr e*) s1)))
 )
)

;;;
(defun psubst (e s)
 (cond
  ((atom e)
    (let ((s1 (findsig1 e s)))
     (cond 
      (s1 (eof s1))
      (t e))
    ))
  (t (form (fof e)(psubst* (e*of e) s)))
 )
)

(defun psubst* (e* s)
 (cond
  ((null e*) ())
  (t (cons (psubst (car e*) s) (psubst* (cdr e*) s)))
 )
)

(defun findsig1 (e s)
 (cond
  ((null s) ())
  ((eq e (vof (car s)))(car s))
  (t (findsig1 e (cdr s)))
 )
)

;;;
(defun ssubst (e s)
 (cond 
  ((null s) e)
  (t (ssubst (subst1 e (car s)) (cdr s)))
 )
)

;;;

   


