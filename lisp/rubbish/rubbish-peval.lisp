;rubbish-peval.lisp

(in-package :rubbish)

;; peval = partial evaluation
;; 
;; peval eval ground term to a value, but if it causes an error,
;; to the term itself.
;; but don't eval (+ x (+ 1 2)) to (+ x 3) because
;; (+ x 3) can't be unified with (+ x (+ y 2)) 

(defparameter *peval-active* t)

(defun peval (e) ;; e must be a quoted S-exp as '(+ 1 www)
  (and *peval-active*
    (let (v)
      (setq v (handler-case (progn (eval e)) (error () :myerror)))
      (if (eq v :myerror) e v)
    )
  )
)

(defmacro mpeval (e) ;; e may be a form as (+ 1 xxx) 
  `(and *peval-active*
    (let (v)
      (setq v (handler-case (progn ,e) (error () :myerror)))
      (if (eq v :myerror) ',e v)
     )
   )
)

