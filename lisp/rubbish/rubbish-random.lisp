;; rubbish-random.lisp
;; around random

(in-package :rubbish)

(defun remove-elem (xl e)
  "remove a element e from xl"
  (loop for ax in xl unless (eq ax e) collect ax)
)

(defun remove-nth (xl n)
  "seems to slow to remove-elem"
  (loop for i from 0 to (- (length xl) 1) unless (eq i n) collect (nth i xl))
)

(defun separate (n xl)
  "values of nth and remainder"
  (values (nth n xl) (remove-nth xl n))
)

(defun random-sort (xl)
  "shaffle x"
  (if (null xl) nil
      (let (x r)
        (multiple-value-setq (x r) (separate (random (length xl)) xl))
        (cons x (random-sort r))
      )
  )
)



