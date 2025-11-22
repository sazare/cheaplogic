;; unifier matrix of P for same signs and oppo signs

(in-package :rubbish)

;; unify-atoms
(defun unify-atoms (lid1 lid2)
  (let* ((vs (union (varsof (cidof lid1)) (varsof (cidof lid2))))
         (a1 (latomicof lid1))
         (a2 (latomicof lid2))
         (sig (funification vs a1 a2)))
    (if (eq :NO sig) :NO (list vs sig))
  )
)

(defun make-umatrix (clist)
  (let (ppns ppn)
    (setq ppns (make-ppnlist clist))
    (loop for pred in (make-psymlist (make-lidlist clist)) 
      collect
      (let ()
        (setq ppn (assoc pred  ppns))
        (list pred 
           (make-umatrix-p (nth 1 ppn)(nth 1 ppn))
           (make-umatrix-p (nth 2 ppn)(nth 2 ppn))
           (make-umatrix-p (nth 1 ppn)(nth 2 ppn)))
      )
    )
  )
)

(defun make-umatrix-p (llids rlids)
  (list 
    (list llids rlids)
    (loop for llid in llids collect
      (loop for rlid in rlids collect
        (unify-atoms llid rlid)
      )
    )
  )
)

(defun strip-mgu (mgu)
  (let (vs ts)
    (loop for v in (nth 0 mgu) as tm in (nth 1 mgu)
      when (not (equal v tm ) )  do
        (push v vs)
        (push tm ts)
    ) 
    (if (null vs) 
      :∅
      (list (reverse vs)(reverse ts))
    )
  )
)

(defun pum-row (ml)
  (loop for am in  ml do
    (if (eq :NO am)
      (format t "|NO")
      (format t "|~a" (strip-mgu am))
    )
  finally 
    (format t "|~%")
  )
)
 
(defun pum-p (pred aum)
  "ums = (pred (ll1 ll2) (m11 m12 ...)(m21 m22 ...)...(mk1 mk2 ...))"
  (let ()
    (format t "~a~%" pred)
    (format t "~a~%" (car aum))
    (loop for aml in (cadr aum) do
      (pum-row aml)
    ) 
  )
)

(defun pum (ums)
  (let (pred)
    (setq pred (nth 0 ums))
    (pum-p pred (nth 1 ums))
    (pum-p pred (nth 2 ums))
    (pum-p pred (nth 3 ums))
  )
) 
