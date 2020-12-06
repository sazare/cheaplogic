;; rubbish-proof.lisp
;; proof manager


;; rule = :reso, :merge, :rename
;; proof is (rule vars sigma parents)
;;  parents = (left::Lid . right::Lid)

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
  (let ((llid (car (rpairof cid)))(rlid (cadr (rpairof cid)))(sig (sigof cid)))
    (cond 
      ((iscontradiction cid) (format t "~% ~a [] ~a ~a <- ~a : <~a:~a> ~%" cid (ruleof cid) (car sig) (cadr sig) llid rlid))
      ((car (proofof cid)) (format t "~% ~a ~a ~a ~a <- ~a : <~a:~a> ~%" cid (bodyof cid) (ruleof cid) (car sig) (cadr sig) llid rlid))
      (t (format t " input ~a ~a~%" cid (bodyof cid)))
    )
    (when (cidof llid) (print-literal llid)
      (print-proof (cidof llid)))
    (when (cidof rlid) (print-literal rlid)
      (format t " in ") (print-proof (cidof rlid)))
  )
)

(defun print-proof0 (cid)
  (let ((llid (car (rpairof cid)))(rlid (cadr (rpairof cid))))
    (cond 
      ((iscontradiction cid) (format t "~% ~a [] ~a : <~a:~a> ~%" cid (ruleof cid) llid rlid))
      ((car (proofof cid)) (format t "~% ~a ~a ~a : <~a:~a> ~%" cid (bodyof cid) (ruleof cid)  llid rlid))
      (t (format t " input ~a ~a~%" cid (bodyof cid)))
    )
    (when (cidof llid) (print-literal llid)
      (print-proof0 (cidof llid)))
    (when (cidof rlid) (print-literal rlid)
      (format t " in ") (print-proof0 (cidof rlid)))
  )
)


(defun fullproof (cid)
  (let (rpa)
    (if (proofof cid)  ;; should check :resolution too
      (let () 
        (setq rpa (rpairof cid))
        (cond 
          ((null rpa) (bodyof cid ))
          (t (list 
;             (ruleof cid)
             (when (car rpa) (list (car rpa) (fullproof (cidof (car rpa)))))
             (when (cadr rpa) (list (cadr rpa) (fullproof (cidof (cadr rpa)))))
           ))
        )
      )
      (bodyof cid )
    )
  )
)

