;; factoring with lids
; lid1 and lid2 has or will have same cid

(in-package :rubbish)

;; entry-factor
(defun entry-factor (lid1 lid2 vs sig remid remlit*)
  (let ((ncid (new-cid)) body (ns (newvars vs)) newvars )

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

    (setq newvars (shrinkvs vs sig))

    (setcid ncid :facto (subsubp vs newvars  ns) (subsubp vs body ns) newvars) ;;; this conflicts

    (entry-proof ncid :factoring vs (subsubp vs sig ns) (list lid1 lid2))
    (rubbish-log :facto ncid)
    ncid
  )
)


;factor with lid
(defun factor-id (lid1 lid2)
  (let* ((vs (varsof (cidof lid1))) ; is same (varsof (cidof lid2))
         (a1 (latomicof lid1))
         (a2 (latomicof lid2))
         (sig (funification vs a1 a2)))
;;
;   (incf *trials-count*)
;; logging
   (rubbish-log lid1 lid2 vs sig)
;; here: vs.sig is a mgu or sig==:NO
   (cond
;;; litとlidの対応をつける
     ((eq sig :NO) ':FAIL)
     (t
        (entry-factor lid1 lid2 vs sig (remof lid2) 
                (subsubp vs (lit*of (remof lid2)) sig)))
   )
  )
)
