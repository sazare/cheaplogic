;; rubbish-resoid.lisp
; id version of resolve

;; general
(defun list-remain (e es)
 (loop for a in es when (not (eq e a)) collect a)
)

;;; remaind lids of the clause of/with lid
(defun remof (lid)
  (list-remain lid (bodyof (cidof lid)))
) 

;; atomic lid version
(defun latomicof (lid)
  (cdr (litof lid))
)



(defun entry-clause (lid1 lid2 vs sig remid remlit*)
  (let ((ncid (new-cid)) body)
   (setf body (loop for lid in remid for lit in (substp vs remlit* sig) 
                collect (setlid (make-lid ncid "R") ncid lit )))
   (setcid ncid "R" (shrinkvs vs sig) body)
   
   (list ncid vs sig)
  )
)

;; resolve cid/lid version
(defun resolve-id (lid1 lid2)
  (let* ((vs (append (varsof (cidof lid1)) (varsof (cidof lid2))))
         (a1 (latomicof lid1))
         (a2 (latomicof lid2)) 
         (sig (funification vs a1 a2)))
;; here: vs.sig is a mgu or sig==:NO
   (cond
;;; litとlidの対応をつける
     ((eq sig :NO) ':FAIL)
     (t (entry-clause lid1 lid2 vs sig (append (remof lid1) (remof lid2))
                (subsubp vs (append (lit*of (remof lid1)) (lit*of (remof lid2))) sig)))
   )
  )
)


