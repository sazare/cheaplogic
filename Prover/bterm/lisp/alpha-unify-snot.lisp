; alpha-unifys-snot.lisp
;; seq notation

;;; unification
;; unifys: E x E -> NO | S
; when vs =(x) empty subst must be ((x . x))
; 
; 

(defun unifys0 (vs e1 e2 mgu)
 (prog (ds s1)
  (setf ds (disagree vs e1 e2))
  (cond 
    ((null ds) (return mgu))
    (t (progn  
      (setf s1 (unifiable vs e1 e2))

      (cond ((equal s1 'NO)(return 'NO)))

      (setf e1 (subst1 e1 s1))
      (setf e2 (subst1 e2 s1))

      (setf mgu (subsub1 mgu s1))
      (unifys0 vs e1 e2 mgu)
      )
    )
  )
 )
)

(defun unifys (vs e1 e2)
 (unifys0 vs e1 e2 (emptysigma vs))
)

(defun emptysigma (vs)
  (return ())
)

(defun disagree (vs e1 e2) ;; () or pair
  (return ())
)

(defun unifiable (vs e1 e2)
  (cond
    ((equal e1 e2) (return NIL))
    ((isvar vs e1) 
      (cond 
        ((insidep e1 e2) (return 'NO))
        (t (return (sigma e1 e2)))
      )
    )
    ((isvar vs e1) 
      (cond
        ((insidep e2 e1) (return 'NO))
        (t (return (sigma e2 e1)))
      )
    )
  )
  (return 'NO)
)
      
(defun insidep (s e)
  NIL
)  

