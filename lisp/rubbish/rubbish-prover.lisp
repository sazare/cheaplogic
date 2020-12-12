;; for prover control

;; to make lsym -> lids with *llist* like that
(defun make-lsymlist (llist)
  (let ((lsyms ()))
    (loop for y in llist collect
      (let ((nam (lsymof y)))
        (if (boundp nam) (intern (string nam)) (set nam ()))
        (set nam (union (cons y nil) (eval nam)))
        (pushnew nam lsyms)
      )
    )
    lsyms
  )
)

;; psym of a lid
(defun psymoflid (lid)
  (cadr (litof lid))
)

;; to make psym list -> lids with *llist* like that
(defun make-psymlist (llist)
  (let (psyms)
    (loop for psym in 
      (loop for lid in llist collect
        (psymoflid lid)
      )
    do
      (pushnew psym psyms)
    )
    psyms
  )
)

;; after make-lsymlist, find-oppolids finds oppo lids of lid

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
;; sorted body
(defun canonic (cid)
  (sort 
    (loop for lid in (bodyof cid) collect lid)
    #'olid<
  )
)

;;; code for a proof of the cid
;; this have all information of cid without the order
;; this may be sorted.
(defun pinfof (cid)
  (let ((rule (ruleof cid)))
    (cond 
      ((eq rule :resolution) 
        (let* ((rp (rpairof cid))(rl (car rp))(rr (cadr rp)))
          (cond 
            (rp (append (cons (list (olidof (car rp))(olidof (cadr rp))) (pinfof (cidof rl)))(pinfof (cidof rr))))
            (t (list (ccode cid)))
          )
        ))
      (t ())
    )
  )
)

;;pinfofolp for checking before make resolvent.
(defun pinfoflp (llid rlid)
  (append (cons (list (olidof llid)(olidof rlid)) (pinfof (cidof llid)))(pindof (cidof rlid))) 
)


; pcode of cid for successful unificaton
(defun pcode (cid)
  (format nil "~a" (pinfof cid))
)


(defun make-pcode (lid1 lid2)
  ;; in construction 
)

;; the following is not work. I which every elements are string.
(defun spinfof (cid)
  (let ((rule (ruleof cid)))
    (cond 
      ((eq rule :resolution) 
        (let* ((rp (rpairof cid))(rl (car rp))(rr (cadr rp)))
          (cond 
            (rp (append (cons (format nil "~a ~a" (olidof (car rp)) (olidof (cadr rp)))
                              (spinfof (cidof rl)))(spinfof (cidof rr))))
            (t (list (string (ccode cid))))
          )
        ))
      (t ())
    )
  )
)

(defun spcode (cid)
  (format nil "~a" (sort (spinfof cid) #'string<))
)


(defun print-otree (cid)
  (let ((llid (car (rpairof cid)))(rlid (cadr (rpairof cid))))
    (cond
      ((iscontradiction cid) (format t "~% ~a [] ~a : <~a:~a> ~%" cid (ruleof cid) (olidof llid)(olidof rlid)))
      ((car (proofof cid)) (format t "~% ~a ~a : <~a:~a> ~%" cid (ruleof cid) (olidof llid)(olidof rlid)))
      (t (format t " input ~a~%" cid))
    )
    (when (cidof llid) (print-literal llid)
      (print-otree (cidof llid)))
    (when (cidof rlid) (print-literal rlid)
      (format t " in ") (print-otree (cidof rlid)))
  )
)



