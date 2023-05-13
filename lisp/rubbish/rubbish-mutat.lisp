; rubbish-mutat.lisp

(in-package :rubbish)

;;; the functions about mutate facts set.

;;
(defun mutate (facts)
  (let (csc ms cs)
    (multiple-value-setq (ms cs) (mujun-set facts))
    (setq csc (causes-contra facts ms))
    (loop for cid in csc do (remove-cid cid))
    (loop for cc in cs do (remove-cid cc))
  )
)



