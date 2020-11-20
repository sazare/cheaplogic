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

;;; code of clause
;; compare over atom's name
(defun name< (ll rr)
  (string< (string ll)(string rr))
)

;; sort over olid on bodies
(defun ccode (cid)
  (sort 
    (loop for lid in (bodyof cid) collect (olidof lid))
    #'name<
  )
)
(defun sccode (cid)
  (format nil "~a" 
    (sort 
      (loop for lid in (bodyof cid) collect (olidof lid))
      #'name<
    )
  )
)

;; sort the body with olid
(defun olid< (ll rr)
  (string< (string (olidof ll)) (string (olidof rr)))
)

;; vars is (varsof (cidof (car (canoc cid))))
(defun canonic (cid)
  (sort 
    (loop for lid in (bodyof cid) collect lid)
    #'olid<
  )
)

;;; code for a proof of the cid
;; this have all information of cid without the order

(defun pcode (cid)
  (format nil "~a" (pinfof cid))
)

(defun pinfof (cid)
  (let ((rule (ruleof cid)))
    (cond 
      ((eq rule :resolution) 
        (let* ((rp (rpairof cid))(rl (car rp))(rr (cadr rp)))
          (cond 
            (rp (append(cons rp (pinfof (cidof rl)))(pinfof (cidof rr))))
            (t (list cid))
          )
        ))
      (t (list cid))
    )
  )
)

