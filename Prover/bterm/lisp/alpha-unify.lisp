; alpha-unify.lisp

;;; unification
;; unify: E x E -> NO | S
; when vs =(x) empty subst must be ((x . x))
; 
; 

(defun unify (vs e1 e2)
 (prog ()
  (cond
   ((equal e1 e2) (return (cons vs vs)))
   ((isvar vs e1) (return (cons (sigma e1 e2) ()))) ;; not yet inside
   ((isvar vs e2) (return (cons (sigma e2 e1) ()))) ;; not yet inside
   ((and (atom e1)(atom e2)) (return 'NO))
  )
  ;; e1 or e2 is not var
  (return 'NO)
 )
)


