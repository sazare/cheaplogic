; rubbish-mutat.lisp

(in-package :rubbish)

;;; the functions about mutate facts set.

(defparameter *beleave* nil)

(defun beleave ()
  *beleave*
)

(defun factisf (facts)
  (prog1 
    (loop for f in facts collect
      (make-clause f)
    )
    (make-lsymlist *llist*)
  )
)

(defmacro factis (&rest facts)
  `(factisf ',facts)
)

;;
(defun mutate (fact)
  (let ((ms (mujun-set fact)))
    (warn "notyetimplement")
  )
)



