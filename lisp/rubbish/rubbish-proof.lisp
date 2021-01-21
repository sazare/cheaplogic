;; rubbish-proof.lisp
;; proof manager


;; rule = :reso, :merge, :rename
;; proof is (rule vars sigma parents)
;;  parents = (left::Lid . right::Lid)

(defun entry-proof (cid rule vars sigma conflicts)
  (setf (get cid :proof)  (list rule vars sigma conflicts))
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
  (let ()
    (cond 
      ((eq (ruleof cid) :resolution)
        (let* ((llid (car (rpairof cid)))(rlid (cadr (rpairof cid)))(sig (sigof cid)))
          (cond 
            ((iscontradiction cid) (format t "~% ~a [] ~a ~a <- ~a : <~a:~a> ~%" cid (ruleof cid) (car sig) (cadr sig) llid rlid))
            ((car (proofof cid)) (format t "~% ~a ~a ~a ~a <- ~a : <~a:~a> ~%" cid (bodyof cid) (ruleof cid) (car sig) (cadr sig) llid rlid))
            (t (format t " input ~a ~a~%" cid (bodyof cid)))
          )
          (when (cidof llid) (print-literal llid)
            (print-proof (cidof llid)))
          (when (cidof rlid) (print-literal rlid)
            (format t " in ") (print-proof (cidof rlid)))
          ))
      ((eq (ruleof cid) :REDUCE-BY-SEMANTIX)
        (let* ((pr (proofof cid))(flits (cadddr pr)))
          (cond
;            ((iscontradiction cid) (format t "~% ~a [] removed ~a~%" cid (ruleof cid) flits ))
            (t (format t "~% ~a ~a ~a removed ~a~%" cid (ruleof cid) (bodyof cid) flits))
          )
          (loop for flid in flits do 
            (print-literal flid)
            (print-proof (cidof flid)))
        ))
    )
  )
)

(defun print-proof0 (cid)
  (let ()
    (cond
      ((eq (ruleof cid) :resolution)
        (let* ((llid (car (rpairof cid)))(rlid (cadr (rpairof cid))))
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
      ((eq (ruleof cid) :REDUCE-BY-SEMANTIX)
        (let* ((pr (proofof cid))(flits (cadddr pr)))
          (cond
;            ((iscontradiction cid) (format t "~% ~a [] removed ~a~%" cid (ruleof cid) flits ))
            (t (format t "~% ~a ~a ~a removed ~a~%" cid (ruleof cid) (bodyof cid) flits))
          )
          (loop for flid in flits do 
            (print-literal flid)
            (print-proof0 (cidof flid)))
        ))
    )
  )
)


(defun fullproof (cid)
  (if (proofof cid)  ;; should check :resolution too
    (cond 
      ((eq (ruleof cid) :resolution)
        (let (rpa) 
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
      ((eq (ruleof cid) :REDUCE-BY-SEMANTIX)
        (let* ((pr (proofof cid))(flits (cadddr pr)))
          (loop for flid in flits collect 
            (fullproof (cidof flid))
          )
        )
      ))
  )
)

