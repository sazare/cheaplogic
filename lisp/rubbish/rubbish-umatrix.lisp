;; unifier matrix of P for same signs and oppo signs

(in-package :rubbish)

(defun make-umatrix (clist)
  (let (ppns ppn)
    (setq ppns (make-ppnlist clist))
    (loop for pred in (make-psymlist (make-lidlist clist)) 
      collect
      (let ()
        (setq ppn (assoc pred ppns))
        (list pred 
           (make-umatrix-p (nth 1 ppn)(nth 1 ppn))
           (make-umatrix-p (nth 2 ppn)(nth 2 ppn))
           (make-umatrix-p (nth 1 ppn)(nth 2 ppn)))
      )
    )
  )
)

(defun make-umatrix-p (llids rlids)
  (cons
    (list llids rlids)
    (loop for llid in llids collect
      (loop for rlid in rlids collect
        (unify-atoms llid rlid)
      )
    )
  )
)

;(defun strip-mgu (mgu)
;  (let (vs ts)
;    (loop for v in (nth 0 mgu) as tm in (nth 1 mgu)
;      when (not (equal v tm ) )  do
;        (push v vs)
;        (push tm ts)
;    ) 
;    (if (null vs) 
;      :∅
;      (list (reverse vs)(reverse ts))
;    )
;  )
;)

(defun strip-mgu (mgu)
  (let (forms)
    (loop for v in (nth 0 mgu) as tm in (nth 1 mgu)
      when (not (equal v tm ) ) do 
        (push (list '= v tm) forms)
    ) 
    (if (null forms) 
      :∅
      (reverse forms)
    )
  )
)

(defun pum-row (lid ml)
  (format t "~a |" lid)
  (loop for am in  ml do
    (if (eq :NO am)
      (format t "|NO")
      (format t "|~a" (strip-mgu am))
    )
  finally 
    (format t "|~%")
  )
)
 
(defun pum-p (aum)
  "ums = ((ll1 ll2) (m11 m12 ...)(m21 m22 ...)...(mk1 mk2 ...))"
  (let (rt ct)
    (setq rt (nth 0 (car aum)))
    (setq ct (nth 1 (car aum)))

    (format t "     |" )
    (loop for cn in ct do (format t "~a|" cn)) 
    (format t "~%")
    (loop for aml in (cadr aum) as rn in rt do
      (pum-row rn aml)
    ) 
  )
)

(defun pum (ums)
  (let (pred)
    (setq pred (nth 0 ums))
    (format t "~a PxP~%" pred)
    (pum-p (nth 1 ums))
    (format t "~a NxN~%" pred)
    (pum-p (nth 2 ums))
    (format t "~a PxN~%" pred)
    (pum-p (nth 3 ums))
  )
) 

;; unify-atoms
(defun unify-atoms (lid1 lid2)
  (let* ((vs (union (varsof (cidof lid1)) (varsof (cidof lid2))))
         (a1 (latomicof lid1))
         (a2 (latomicof lid2))
         (sig (funification vs a1 a2)))
    (if (eq :NO sig) :NO (list vs sig))
  )
)


