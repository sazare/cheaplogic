;; unifier matrix of P for same signs and oppo signs

;; unify-atoms
(defun unify-atoms (lid1 lid2)
  (let* ((vs (union (varsof (cidof lid1)) (varsof (cidof lid2))))
         (a1 (latomicof lid1))
         (a2 (latomicof lid2))
         (sig (funification vs a1 a2)))
    (if (eq :NO sig) :NO (list vs sig))
  )
)

(defun make-umatrix (llids rlids)
  (loop for llid in llids collect
    (loop for rlid in rlids collect
      (unify-atoms llid rlid)
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
      nil
      (list (reverse vs)(reverse ts))
    )
  )
)

(defparameter ppnlist  (make-ppnlist *clist*))

(defun make-umatrix-of (ppnlist pid)
  (let (ppn)
    (setq ppn (make-ppnlist pid ppnlist))
    (values 
      (umatrix (cadr ppn)(cadr ppn)) 
      (umatrix (caddr ppn) (caddr ppn))
      (umatrix (cadr ppn) (caddr ppn))
    )
  )
)

