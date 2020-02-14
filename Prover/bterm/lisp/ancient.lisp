;; ancient substitution and unification
; the origin of performance measure

;; substitution
;; (defun subst) exists
;; (subst t v expr)
;; (substitute t v expr)

(defun subst* (sigma expr)
  (progn 
    (loop for s in sigma
      do (setf expr (subst (cdr s) (car s) expr))
    )
    expr
  )
)
    

;; disagreement



;; make-unifier


