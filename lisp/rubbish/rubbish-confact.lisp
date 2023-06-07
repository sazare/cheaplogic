; EOLO consistent facts

(in-pacage :rubbish)

(defparameter *kb* ())

(defun init-kb ()
  (setq *kb* *clist*)
)


;;; in the following, separete reduce for fact and falsehood
;;; because this is an experiment. 
;;; the two procedure should be in one for efficiency.

; fact reduce for a clause(knowledge)
(defun onfact-clause (fcid cid)
  (let* ((flid (car (bodyof fcid))) (oflsym (oppolsymof (lsymof flid))) r1)
    (loop for lid in (bodyof cid) 
       when (eq (lsymof lid) oflsym)
       do (unless (equal :FAIL (setq r1 (resolve-id flid lid))) (return r1))
       finally (return cid)
    )
  )
)

; fact reduce for knowledge base
(defun onfact-kb (fcid kb)
 ;; fcid is the cid of the answer
 ;; 
    (loop for cid in kb 
      unless (eq cid fcid)
      collect (onfact-clause fcid cid)
    )
)

; falsehood reduce for clause
(defun onfalse-clause (fcid cid)
  (let* ((flid (car (bodyof fcid))) (flsym (lsymof flid)) r1)
    (loop for lid in (bodyof cid) 
       when (eq (lsymof lid) flsym)
       do (unless (equal :FAIL (setq r1 (resolve-id flid lid))) (return nil))
       finally (return cid)
    )
  )
)

; falsehood reduce for knowledge base
(defun onfalse-kb (fcid kb)
;; if same lsym, they don't resolve
  (let (r1)
    (loop for cid in kb 
      when (setq r1 (onfalse-clause fcid cid))
      collect r1
    )
  )
)

(defun reduce-kb (fcid kb)
  (onfalse-kb fcid (onfact-kb fcid kb))  
)

;; find fact in kb
(defun findfact (kb)
  (loop for cid in kb
    when (isunitcid cid)
    collect cid
  )
)
