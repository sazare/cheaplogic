;; rubbish-resoid.lisp
; id version of resolve

(in-package :rubbish)

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
  (let ((ncid (new-cid)) body (ns (newvars vs)) )

    (setf body (loop for lid in remid 
                    as lit in (substp vs remlit* sig) 
                    as n from 1
                collect 
                  (let (nlid)
                    (setq nlid (make-lid ncid n))
                    (setlid nlid ncid lid (subsubp vs lit ns))
    ;                (setlid nlid ncid lid (litof lid))
                    (pushlsym nlid)
                    nlid 
                  )
              )
     )
   

    (setcid ncid :resolvent (subsubp vs (shrinkvs vs sig) ns) (subsubp vs body ns)) ;;; this conflicts

    (entry-proof ncid :resolution vs (subsubp vs sig ns) (list lid1 lid2))
    (rubbish-log :resolvent ncid)
    ncid
  )
)


(defparameter *pcodelist* nil)

(defun existpcode (lid1 lid2)
  nil
)

;; resolve cid/lid version
(defun resolve-id (lid1 lid2)
  (let* ((vs (append (varsof (cidof lid1)) (varsof (cidof lid2))))
         (a1 (latomicof lid1))
         (a2 (latomicof lid2)) 
         (sig (funification vs a1 a2)))
;; 
   (incf *num-of-trials*)
;; logging
   (rubbish-log lid1 lid2 vs sig)
;; here: vs.sig is a mgu or sig==:NO
   (cond
;;; litとlidの対応をつける
     ((eq sig :NO) ':FAIL)
;     ((existpcode lid1 lid2) ':FAIL) ;; this resolvent was already made
     (t ;(pushnew (make-pcode lid1 lid2) *pcodelist*)
        (entry-clause lid1 lid2 vs sig (append (remof lid1) (remof lid2))
                (subsubp vs (append (lit*of (remof lid1)) (lit*of (remof lid2))) sig)))
   )
  )
)


;;; reduce-by-syntax
;;; L1vL2vα to L1∨α when L1 ≡ L2
;;; not use <L1:L2>, this is a propositional rule

(defun entry-reduce (lid1 lid2 vs remid )
  (let ((ncid (new-cid)) body (ns (newvars vs)) )

    (setf body (loop for lid in (remof lid2) as n from 1 
                collect 
                  (let (nlid)
                    (setq nlid (make-lid ncid n))
                    (setlid nlid ncid lid (litof lid))
                    (pushlsym nlid)
                    nlid 
                  )
               )
    )

    (setcid ncid :REDUCED-BY-SYNTAX () body)

    (entry-proof ncid :REDUCED-BY-SYNTAX vs vs (list lid1 lid2))
    (rubbish-log :REDUCED-BY-SYNTAX ncid)
    ncid
  )
)

(defun reduce-id (lid1 lid2)
  ;; lid1 and lid2 should have same cid
  (let* ((vs (varsof (cidof lid1)) ))
    (when (equal-lid lid1 lid2)
;; logging
     (rubbish-log lid1 lid2 vs ())
;;; litとlidの対応をつける
      (entry-reduce lid1 lid2 vs (remof lid2))
    )
  )
)

(defun match-lids (cid)
  (let ((body (bodyof cid)) llid)
    (loop named match-lids-loop for llids on body do
      (setq llid (car llids))
      (loop for rlid in (cdr llids) 
        do (if (equal-lid llid rlid) (return-from match-lids-loop (values llid rlid)))
      )
    )
  )
)

(defun step-reduce-syntax (cid)
  (let (llid rlid)
    (multiple-value-setq (llid rlid) (match-lids cid))
    (when llid (reduce-id llid rlid))
  )
)
   
