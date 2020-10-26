;; rubbish-proof.lisp
;; proof manager


;; rule = :reso, :merge, :rename

(defun entry-proof (cid rule vars sigma parents)
  (setf (get cid :proof)  (list rule vars sigma parents))
)

(defun proofof (cid)
  (get cid :proof)
)

(defun ruleof (cid)
  (car (proofof cid))
)

(defun sigof (cid)
  (list (cadr (proofof cid)) (caddr (proofof cid)))
)

(defun rpairof (cid)
  (cadddr (proofof cid))
)


(defun print-proof (cid)
  (let ((step (get cid :proof)))
    (let ((llid (car (cadddr step)))(rlid (cadr (cadddr step))))
    (cond 
      ((car step) (format t "~a ~a ~a <- ~a : <~a:~a> ~%" cid (car step) (cadr step) (caddr step) llid rlid))
      (t (format t " input ~a~%" cid ))
    )
    (when (cidof llid) (print-literal llid)
      (print-proof (cidof llid)))
    (when (cidof rlid) (print-literal rlid)
      (format t " in ") (print-proof (cidof rlid)))
    )
  )
)

