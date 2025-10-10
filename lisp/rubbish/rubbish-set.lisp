;; rubbish-combi.lisp
;; combination algorithms

(in-package :rubbish)

(defun putelem (e s)
  (cons e s)
)

(defun subsetof (s)
  (cond
    ((null s) nil)
    ((null (cdr s)) (list s))
    (t
      (let ((ss (subsetof (cdr s))))
        (append (list (list (car s)) )
                ss
                (loop for e in ss collect (cons (car s) e))
        )
      )
    )
  )  
)

