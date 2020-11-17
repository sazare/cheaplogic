;; for prover control


;; to make lsym -> lids with *llist* like that
(defun make-lsymtolids (llist)
  (loop for y in llist collect
    (let ((nam (lsymof y)))
      (if (boundp nam) (intern (string nam)) (set nam ()))
      (set nam (union (cons y nil) (eval nam)))
    )
  )
)


;; after make-lsymtolids, find-oppolids finds oppo lids of lid

(defun find-oppolids (lid)
  (eval (oppolsymof (lsymof lid)))
)


(defun geneof (cid)
  (loop for lid in (bodyof cid)
    collect
      (olidof lid)
  )
)


  
