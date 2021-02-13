;; for prover control

;;; define *lsymlist*
(defparameter *lsymlist* nil)

;; setup lsym of the lid has the lid
(defun pushlsym (lid)
  (let ((lsym (lsymof lid)))
;; if a lsym was orphan, new binding should made.
    (if (boundp lsym) (intern (string lsym)) (set lsym ()))
    (set lsym (union (cons lid nil) (eval lsym))) ;; a lsym has the lid has the lsym
;    (pushnew lid lsym)        ;; a lsym has the lid has the lsym. this should be macro and ...
    (pushnew lsym *lsymlist*) ;; if the lsym created on the fly, this call should be.
  )  
)
;; to make lsym -> lids with *llist* like that
(defun make-lsymlist (llist)
  (let ()
    (loop for lid in llist do
      (pushlsym lid)
    )
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
  (let (lsym opsym)
    (setq lsym (lsymof lid))
    (if (boundp lsym) 
      (progn 
        (setq opsym (oppolsymof lsym))
        (if (boundp opsym) (eval opsym) nil)
      )
      nil)
  )
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

;; berfore resolve-id, this shows the pcode of the resolvent if succeed
;; the order of lid1, lid2 is free

(defun make-pcode (lid1 lid2)
  (let ((pinf (make-pinfo lid1 lid2)) uniq)
    (setq uniq (loop with ss = () for s in pinf do (pushnew s ss :test #'equal) finally (return ss) ))
    (sort uniq #'string>)
  )
)

(defun make-pinfo (lid1 lid2)
  ;; not pcode, but something make-pinfo is better
  (append (list (olidof lid1)(olidof lid2)) (pcode (cidof lid1)) (pcode (cidof lid2))) 
)

;;; code for a proof of the cid
;; this have all information of cid without the order
;; this may be sorted.

(defun pcode-reduced (cid trues)
  (loop with pco = ()
    for tcid in trues do (push (olidof tcid) pco) ;;; ??? parent? body??? ###
     (setq pco (append (pcode (cidof tcid)) pco))
    finally (return pco)
  )
)

;; not uniq and sorted version of pcode
(defun pinfof (cid)
  (let ((rule (ruleof cid)))
    (cond 
      ((eq rule :resolution) 
        (let* ((rp (rpairof cid))(rl (car rp))(rr (cadr rp)))
          (cond 
            (rp (append (list (olidof rl)(olidof rr)) (pinfof (cidof rl))(pinfof (cidof rr))))
            (t ())
          )
        ))
      ((eq rule :REDUCED-BY-SEMANTIX) (pcode-reduced cid (truesof cid)))
      (t ())
    )
  )
)



; pcode of cid 

(defun pcode (cid)
  (let ((sinf (pinfof cid)) sss uniq)
    (setq uniq (loop with ss = () for s in sinf do (pushnew s ss :test #'equal) finally (return ss) ))
    (sort uniq #'string>)
  )
)

;; stringfy pcode
(defun spcode (cid)
  (format nil "~a" (sort (pcode cid) #'string>))
)

; print-otree may not work
;(defun print-otree (cid)
;  (let ((llid (car (rpairof cid)))(rlid (cadr (rpairof cid))))
;    (cond
;      ((iscontradiction cid) (format t "~% ~a [] ~a : <~a:~a> ~%" cid (ruleof cid) (olidof llid)(olidof rlid)))
;      ((car (proofof cid)) (format t "~% ~a ~a : <~a:~a> ~%" cid (ruleof cid) (olidof llid)(olidof rlid)))
;      (t (format t " input ~a~%" cid))
;    )
;    (when (cidof llid) (print-literal llid)
;      (print-otree (cidof llid)))
;    (when (cidof rlid) (print-literal rlid)
;      (format t " in ") (print-otree (cidof rlid)))
;  )
;)



