;; functions on bterm

(defun binding-of (vars bterm)
  (cond 
    ((atom bterm)
	(cond
	  ((member bterm vars) (list bterm))
	  (t '())
	)
     )
    ((listp (car bterm)) (car bterm))
    (t (binding-of-list vars bterm))
  )
)

(defun uniq-push (alist blist)
  (let ((rlist alist))
    (loop for b in blist
      do
      (unless (member b rlist) (setf rlist (append rlist (list b))))
    )
  rlist
  )
)

(defun binding-of-list (vars blist)
  (let ((binds nil))
    (loop for b in blist
      do
        (let ((bs nil))
	  (setf bs (binding-of vars b))
          (setf binds (uniq-push binds bs))
       ) 
    )
  binds
  )
)
