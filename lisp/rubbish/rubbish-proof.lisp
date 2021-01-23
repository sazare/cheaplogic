;; rubbish-proof.lisp
;; proof manager

;; find all contradictions
(defun listcontra ()
  (loop for cid in *clist* when (iscontradiction cid) collect cid)
)


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

(defun print-proof (cid &optional (ind 0))
  (let ()
    (cond 
      ((eq (ruleof cid) :resolution)
        (let* ((llid (car (rpairof cid)))(rlid (cadr (rpairof cid)))(sig (sigof cid)))
          (cond 
            ((iscontradiction cid) 
               (format t "~a~a [] ~a ~a <- ~a : <~a:~a> ~%" 
                 (nspace ind) cid (ruleof cid) (car sig) (cadr sig) llid rlid))
            ((car (proofof cid)) 
               (format t "~a~a ~a ~a ~a <- ~a : <~a:~a> ~%" 
                 (nspace ind) cid (bodyof cid) (ruleof cid) (car sig) (cadr sig) llid rlid))
            (t (format t "~ainput ~a ~a~%" (nspace ind) cid (bodyof cid)))
          )
          (when (cidof llid)
            (print-literal0 llid (1+ ind))
            (format t "in~%")
            (print-proof (cidof llid))(+ 2 ind))
          (when (cidof rlid) 
            (print-literal0 rlid (1+ ind))
            (format t "in~%")
            (print-proof (cidof rlid)(+ 2 ind)))
          ))
      ((eq (ruleof cid) :REDUCE-BY-SEMANTIX)
        (let* ((pr (proofof cid))(flits (cadddr pr)))
          (cond
            ((iscontradiction cid) 
               (format t "~a~a ~a [] are removed~%" (nspace ind) cid (ruleof cid)))
            (t 
               (format t "~a~a ~a ~a are removed~%" (nspace ind) cid (ruleof cid) (bodyof cid)))
          )
          (loop for flid in flits do 
            (print-literal0 flid (1+ ind))
;            (terpri t)
            (print-proof (cidof flid)(+ 2 ind)))
        ))
    )
  )
)

(defun print-literal0 (lid ind)
  (format t "~%~a" (nspace ind))
  (print-literal lid)
)

(defun print-prmof0 (cid &optional (ind 0))
  (let ()
    (format t "~%")
    (cond
      ((eq (ruleof cid) :resolution)
        (let* ((llid (car (rpairof cid)))(rlid (cadr (rpairof cid))))
          (cond 
            ((iscontradiction cid) (format t "~a~a [] ~a : <~a:~a>" (nspace ind) cid (ruleof cid) llid rlid))
            ((car (proofof cid)) (format t "~a~a ~a ~a : <~a:~a>" (nspace ind) cid (bodyof cid) (ruleof cid)  llid rlid))
            (t (format t "~ainput ~a ~a" (nspace ind) cid (bodyof cid)))
          )
          (when (cidof llid) 
            (print-literal0 llid (1+ ind))
            (if (cidof llid) (format t " in") (format t "input"))
            (print-proof0  (cidof llid)(+ 2 ind)))
          (when (cidof rlid) 
            (print-literal0 rlid (1+ ind))
            (if (cidof llid) (format t " in") (format t "input"))
            (print-proof0  (cidof rlid)(+ 2 ind)))
        )
      )
      ((eq (ruleof cid) :REDUCE-BY-SEMANTIX)
        (let* ((pr (proofof cid))(flits (cadddr pr)))
          (cond
            ((iscontradiction cid) 
              (format t "~a~a ~a [] are removed" (nspace ind) cid (ruleof cid)))
            (t 
              (format t "~a~a ~a ~a are removed" (nspace ind) cid (ruleof cid) (bodyof cid))))
          (loop for flid in flits do 
            (print-literal0 flid (+ 2 ind))
            (terpri t)
            (print-proof0 (cidof flid)(+ 4 ind)))
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

