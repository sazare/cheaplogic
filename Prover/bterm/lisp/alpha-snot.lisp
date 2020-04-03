;;; alpha is a unification

;;; snot is seq notation [(vi.ei)]

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
; subst1s: E x (v.e) -> E

(defun subst1s (e s1)
 (cond 
  ((eq e (vof s1)) (exof s1))
  ((issym e) e)
  (t (form (fof e) (subst1s* (e*of e) s1)))
 )
)

; substs*1 E* x (v.e) -> E*
(defun subst1s* (e* s1)
 (cond
  ((null e*) ())
  (t (cons (subst1s (car e*) s1) (subst1s* (cdr e*) s1)))
 )
)

;;;
; psubsts : E x S -> E
(defun psubsts (e s)
 (cond
  ((atom e)
    (let ((s1 (findsig1 e s)))
     (cond 
      (s1 (exof s1))
      (t e))
    ))
  (t (form (fof e)(psubst*s (e*of e) s)))
 )
)

; psubst*s : E* x S -> E*

(defun psubst*s (e* s)
 (cond
  ((null e*) ())
  (t (cons (psubsts (car e*) s) (psubst*s (cdr e*) s)))
 )
)

; findsig1 : E x S -> S1|() where S1 in S or not
(defun findsig1 (e s)
  (assoc e s)
)

;;;
; ssubst : E x S -> E
(defun ssubsts (e s)
 (cond 
  ((null s) e)
  (t (ssubsts (subst1s e (car s)) (cdr s)))
 )
)

;;; subsub* : S x S -> S

; subsub1s S x (v.e) -> S
;; ***think something better
(defun subsub1s (s1 s2)
 (cond
  ((null s1) (cons s2 ()))
  ((eq (vof (car s1)) (vof s2)) 
    (cons (sigma (vof (car s1)) (subst1s (exof (car s1)) s2))
          (subsub1sa (cdr s1) s2)))
  (t (cons (sigma (vof (car s1)) (subst1s (exof (car s1)) s2))
           (subsub1s (cdr s1) s2)))
 )
)

; subsub1sa after s2 in s1 occur
(defun subsub1sa (s1 s2) 
 (cond
  ((null s1) ())
  (t (cons (sigma (vof (car s1)) (subst1s (exof (car s1)) s2))
           (subsub1sa (cdr s1) s2)))
 )
)

; psubsubs : S x S -> S
(defun psubsubs (s1 s2)
 (append 
  s1
  (diffsigma s2 s1) ; this function is't needed when psubsts used.
 )
)

; diffsigma S x S -> S
(defun diffsigma (s1 s2)
 (cond
  ((null s1) ())
  ((insigmas (vof (car s1)) s2) (diffsigma (cdr s1) s2))
  (t (cons (car s1) (diffsigma (cdr s1) s2)))
 )
)

; insigmas Atom x S -> T|NIL
(defun insigmas (v s)
 (cond
  ((null s) NIL)
  ((eq v (vof (car s))) T)
  (t (insigmas v (cdr s)))
 )
)

; ssubsubs S x S -> S

(defun ssubsubs (s1 s2) ;; this may be too tedious but neccessary?
 (cond
  ((null s2) s1)
  (t (ssubsubs (subsub1s s1 (car s2)) (cdr s2)))
 )
)


