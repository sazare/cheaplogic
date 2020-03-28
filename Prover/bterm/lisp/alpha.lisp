;;; alpha is a unification

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


;;; subst* : E x s -> E
; subst1: E x (v.e) -> E

(defun subst1 (e s1)
 (cond 
  ((eq e (vof s1)) (exof s1))
  ((issym e) e)
  (t (form (fof e) (subst1* (e*of e) s1)))
 )
)

; subst1* E* x (v.e) -> E*
(defun subst1* (e* s1)
 (cond
  ((null e*) ())
  (t (cons (subst1 (car e*) s1) (subst1* (cdr e*) s1)))
 )
)

;;;
; psubst : E x S -> E
(defun psubst (e s)
 (cond
  ((atom e)
    (let ((s1 (findsig1 e s)))
     (cond 
      (s1 (exof s1))
      (t e))
    ))
  (t (form (fof e)(psubst* (e*of e) s)))
 )
)

; psubst* : E* x S -> E*

(defun psubst* (e* s)
 (cond
  ((null e*) ())
  (t (cons (psubst (car e*) s) (psubst* (cdr e*) s)))
 )
)

; findsig1 : E x S -> S1|() where S1 in S or not
(defun findsig1 (e s)
  (assoc e s)
)

;;;
; ssubst : E x S -> E
(defun ssubst (e s)
 (cond 
  ((null s) e)
  (t (ssubst (subst1 e (car s)) (cdr s)))
 )
)

;;; subsub* : S x S -> S

; subsub1 S x (v.e) -> S
;; ***think something better
(defun subsub1 (s1 s2)
 (cond
  ((null s1) (cons s2 ()))
  ((eq (vof (car s1)) (vof s2)) 
    (cons (sigma (vof (car s1)) (subst1 (exof (car s1)) s2))
          (subsub1a (cdr s1) s2)))
  (t (cons (sigma (vof (car s1)) (subst1 (exof (car s1)) s2))
           (subsub1 (cdr s1) s2)))
 )
)

; subsub1a after s2 in s1 occur
(defun subsub1a (s1 s2) 
 (cond
  ((null s1) ())
  (t (cons (sigma (vof (car s1)) (subst1 (exof (car s1)) s2))
           (subsub1a (cdr s1) s2)))
 )
)

; psubsub : S x S -> S
(defun psubsub (s1 s2)
 (append 
  s1
  (diffsigma s2 s1) ; this function is't needed when psubst used.
 )
)

; diffsigma S x S -> S
(defun diffsigma (s1 s2)
 (cond
  ((null s1) ())
  ((insigma (vof (car s1)) s2) (diffsigma (cdr s1) s2))
  (t (cons (car s1) (diffsigma (cdr s1) s2)))
 )
)

; insigma Atom x S -> T|NIL
(defun insigma (v s)
 (cond
  ((null s) NIL)
  ((eq v (vof (car s))) T)
  (t (insigma v (cdr s)))
 )
)

; ssubsub S x S -> S

(defun ssubsub (s1 s2) ;; this may be too tedious but neccessary?
 (cond
  ((null s2) s1)
  (t (ssubsub (subsub1 s1 (car s2)) (cdr s2)))
 )
)



;;; unification
;; unify: E x E -> NO | S
; when vs =(x) empty subst must be ((x . x))

;(defun unify (vs e1 e2)
; (cond
;  ((equal e1 e2) ())
;  (t 'NO)
; )
;)


  

   


