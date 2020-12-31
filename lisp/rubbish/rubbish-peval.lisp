;rubbish-peval.lisp
;; peval = partial evaluation
;; 
;; peval eval ground term to a value, but if it causes an error,
;; to the term itself.
;; but don't eval (+ x (+ 1 2)) to (+ x 3) because
;; (+ x 3) can't be unified with (+ x (+ y 2)) 

(defun peval (e) ;; e must be a quoted S-exp as '(+ 1 www)
  (let (v)
    (setq v (ignore-errors (if (null (eval e))  :nil)))
    (cond 
      ((eq v :nil) nil)
      ((null v) e)
      (t v))
  )
)

(defmacro mpeval (e) ;; e may be a form as (+ 1 xxx) 
  `(let (v)
    (setq v (ignore-errors ,e))
    (if v v ',e)
   )
)

