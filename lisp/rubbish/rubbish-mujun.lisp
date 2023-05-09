;; rubbish-mujun.lisp 

(in-package :rubbish)

;; for analyze and manipulate mujun 

;; pure-prover-gtrail1 is in rubbish-prover-gtrail.lisp


(defun check-mujun1 (g)
  (car (pure-prover-gtrail (list g)) )
)

(defun check-mujunn (axioms)
  (loop for g in axioms collect
    (car (pure-prover-gtrail (list g)) )
  )
)

(defun check-mujun (axioms)
  (loop for g in axioms append
    (car (pure-prover-gtrail (list g)) )
  )
)

;; 
;; pc is a pcode, cinpc make cid of pcode's lid
(defun cinpc (pc)
  (uniq (loop for lid in pc collect (cidof lid)))
)

;; mujun-set is a pure logical function
;;; this finds effectively minimal inconsistent subset of *clist* 

;; when cids make []s, make pcode of [], find cid of pcode'lid.
(defun mujun-set (cids)
  (let (cs ups)
    (setq cs (check-mujun cids)) 
    (setq ups (uniq-pcodes cs))
    (values (loop for pc in ups collect (cinpc pc)) cs)
  )
)

;; select a clause for 

(defun oldest-one (ms)
  (loop with m0 = (car ms) 
    for m on ms 
    when (< (when-born (car m))(when-born m0)) 
    do (setq m0 (car m))
    finally (return m0))
)

(defun causes-contra (facts ms)
  (loop for m in ms collect (oldest-one m))
)


