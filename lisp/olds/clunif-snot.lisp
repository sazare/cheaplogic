; clunif-snot.lisp

(load "load-alpha-prim-snot.lisp")

(defun make-unifizea (vs e1 e2)
  '(lambda (m s1)
      (disagree (subst1s e1 s1)(subst1s e2 s1)))
)
       

