;; rubbish-random.lisp
;; around random

(defun remove-elem (xl e)
  "remove a element e from xl"
  (loop for ax in xl unless (eq ax e) collect ax)
)

(defun remove-nth (xl n)
  "seems to slow to remove-elem"
  (loop for i from 0 to (length xl) unless (eq i n) collect (nth i xl))
)

(defun random-sort (xl)
  "shaffle x"
  (if (null xl) nil
      (let ((n (random (length xl))))
        (cons (nth n xl)
            (random-sort (remove-elem xl (nth n xl)))
        )
      )
  )
)



