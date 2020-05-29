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

; substs* is more general than substsv. but not be used in others
;(defun substs* (es ss) 
;  (cond
;    ((null es) ())
;    (t (cons (substs (car es) ss) (substs* (cdr es) ss)))
;  )
;)

;; substsv is called only s2p
(defun substsv (vs ss) 
  (cond
    ((null vs) ())
    (t (cons (substs (car vs) ss)(substsv (cdr vs) ss)))
  )
)

(defun subsubs1 (s v1 e1)
  (subsubs1h s v1 e1 nil)
;  (subsubs1w s v1 e1 ())
)

; i dont like this
(defun subsubs1h (s v1 e1 has)
  (cond
    ((null s)
      (cond (has ())(t (list (cons v1 e1)))))
    (t (cons (cons (caar s)(subst1 (cdar s) v1 e1))
             (subsubs1h (cdr s) v1 e1 (or has (eq (caar s) v1)))))
  )
)

;; alternative subsubs1
(defun subsubs1w (s v1 e1)
  (subsubs1w0 s v1 e1 (list (cons v1 e1)))
)

; keep as the subst will be added at the end
(defun subsubs1w0 (s v1 e1 as)
  (cond
    ((null s) as)
    (t (cons (cons (caar s)(subst1 (cdar s) v1 e1))
             (subsubs1w0 (cdr s) v1 e1 (cond ((eq (caar s) v1) ())(t as)) )))
  )
)

(defun subsubs (s1 s2)
  (cond
    ((null s2) s1)
    (t (subsubs (subsubs1 s1 (caar s2)(cdar s2)) (cdr s2)))
  )
)

(defun subsubsw (s1 s2)
  (cond
    ((null s2) s1)
    (t (subsubs (subsubs1w s1 (caar s2)(cdar s2)) (cdr s2)))
  )
)

;(defun putpnot (vs s v1 e1)
;  "basic operation on vars sigma"
;  (loop for v in vs for e in s collect
;    (cond ((eq v v1) e1)(t e))
;  )
;)
;(defun substp1 (vs s v1 e1)
;  (loop for v in vs for e in s collect
;    (cond ((eq v v1) e1)(t (subst1 e v1 e1)))
;  )
;)

(defun normalf (e v1 e1)
  e
)

(defun putpnot (vs s v1 e1 &optional (fn #'normalf))
  "basic operation on vars sigma"
  (loop for v in vs for e in s collect
    (cond ((eq v v1) e1)(t (funcall fn e v1 e1)))
  )
)

(defun substp1 (vs s v1 e1)
  (putpnot vs s v1 e1 #'subst1)
)


(defun substp (vs ex es)
  (let ((nex ex))
    (loop for v in vs for e in es do
      (setf nex (subst1 nex v e))
    )
    nex
  )
)

;; subsubp

(defun subsubp1 (vs s1 v1 s2)
  (loop for v in vs for e1 in s1 collect
    (if (eq v v1)
      (if (eq v e1)  ;; empty substitution
          s2
          (subst1 e1 v1 s2)
      )
      (subst1 e1 v1 s2)
    )
  )
)

(defun subsubp (vs s1 s2)
  (let ((rs s1))
    (loop for v2 in vs for e2 in s2 do 
      (setf rs (subsubp1 vs rs v2 e2))
    )
    rs
  )
)

;;;;; disgreee is a core of unify

(defun disagree (vs e1 e2 se fn)
  (disag vs e1 e2 se fn)
)

(defun disag (vs e1 e2 m fn)
  (cond
    ((equal e1 e2) m)
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

; showit is a stub for testing disagree
;(defun showit (vs e1 e2 m)
; (format t "~a:~a ~a~%" vs e1 e2)
; m
;)

(defun collect (vs e1 e2 m)
 vs
 (append m (list (cons e1 e2)))
)

;; unify variation
;; s for snot, p for pnot

(defun unifics (vs d1 d2 m)
;; assume d1!=d2
  (cond
    ((isvar vs d1) (makesubsubs vs m (substs d1 m)(substs d2 m)))
    ((isvar vs d2) (makesubsubs vs m (substs d2 m)(substs d1 m)))
    ((or (atom d1)(atom d2)) 'NO)
    ((eq (car d1)(car d2))(unifics* vs (cdr d1)(cdr d2) m))
    (t 'NO)
  )
)

(defun unifics* (vs e1* e2* m)
  (cond
    ((null e1*) m)
    (t (unifics* vs (cdr e1*)(cdr e2*) (unifics vs (car e1*)(car e2*) m)))
  )
)

;;;
(defun makesubsubs (vs s v e)
  (subsubs1 s v e)
)

;;; 
(defun unifys (vs e1 e2)
  (disagree vs e1 e2 () #'unifics)
)

;;
(defun unificp (vs d1 d2 m)
;; assume d1!=d2
  (cond
    ((isvar vs d1) (makesubsubp vs m (substp vs d1 m)(substp vs d2 m)))
    ((isvar vs d2) (makesubsubp vs m (substp vs d1 m)(substp vs d2 m)))
    ((or (atom d1)(atom d2)) 'NO)
    ((eq (car d1)(car d2))(unificp* vs (cdr d1)(cdr d2) m))
    (t 'NO)
  )
)

(defun unificp* (vs e1* e2* m)
  (cond
    ((null e1*) m)
    (t (unificp* vs (cdr e1*)(cdr e2*) (unificp vs (car e1*)(car e2*) m)))
  )
)

(defun makesubsubp (vs s v e)
  (subsubp1 vs s v e)
)

;; unifyp
(defun unifyp (vs e1 e2)
  (let ((s0 (unifys vs e1 e2)))
    (cond ((eq s0 'NO) 'NO)
          (t (s2p vs s0)))
  )
;  (disagree vs e1 e2 vs #'unificp)
)

;;; unifysp
;; s for subst e, p for compose mgu

;; in substs m should be snot, insubsubp m should be pnot.
;; it is not both valid.
;;;; unifysp may be identical unifyp

(defun unificsp (vs d1 d2 m)
;; assume d1!=d2
  (cond
    ((isvar vs d1) (makesubsubp vs m (substp vs d1 m)(substp vs d2 m)))
    ((isvar vs d2) (makesubsubp vs m (substp vs d1 m)(substp vs d2 m)))
    ((or (atom d1)(atom d2)) 'NO)
    ((eq (car d1)(car d2))(unificsp* vs (cdr d1)(cdr d2) m))
    (t 'NO)
  )
)

(defun unificsp* (vs e1* e2* m)
  (cond
    ((null e1*) m)
    (t (unificsp* vs (cdr e1*)(cdr e2*) (unificsp vs (car e1*)(car e2*) m)))
  )
)

(defun unifysp (vs e1 e2)
  (disagree vs e1 e2 vs #'unificsp)
)

;;;; snot to pnot
(defun s2p (vs ss)
  (substsv vs ss)
)

;;;; pnot to snot
(defun p2s (vs es)
  (loop for v in vs for e in es
    collect (cons v e))
)

