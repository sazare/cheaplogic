; EOLO consistent facts

(defparameter *kb* ())

(defun init-kb ()
  (setq *kb* (reverse *clist*))
)

;reduce for a clause(knowledge)
(defun reduce-clause (fcid cid)
  (let* ((flid (car (bodyof fcid))) (oflsym (oppolsymof (lsymof flid))) r1)
    (loop for lid in (bodyof cid) 
       when (eq (lsymof lid) oflsym)
       do 
          (unless (equal :fail (setq r1 (resolve-id flid lid))) (return r1))
       finally (return cid)
    )
  )
)

; reduce for knowledge base
(defun reduce-kb (fcid kb)
 ;; fcid is the cid of the answer
 ;; 
    (loop for cid in kb 
      unless (eq cid fcid)
      collect (reduce-clause fcid cid)
    )
)

;; find fact in kb
(defun findfact (kb)
  (loop for cid in kb
    when (isunitclause cid)
    collect cid
  )
)
