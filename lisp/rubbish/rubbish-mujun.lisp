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
  "mujun-set return set list and their contradictions"
  (let (cs ups)
    (setq cs (check-mujun cids)) 
    (setq ups (uniq-pcodes cs))
    (values (loop for pc in ups collect (cinpc pc)) cs)
  )
)

;; select a clause for 
;;; this is an implementation of an situation.

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

;;
; ∀p ∈ Pred(Σ)について、 Π(Σ, +p)⊢□または Π(Σ, -p)⊢□ができたらΣに□が含まれると考える場合
;; 1. +pか-pのどちらかでよいと思う。□ができるということは、opposのunitの証明もできるということだから
;;;; ほんとか??
;; 2. (make-psymlist *llist*) => list of pred
;;;

(defun make-vars (nts)
  (loop for n from 1 to nts collect
    (newvar 'vc)
  )
)


(defun canonical-clause (lid)
  (let ((lit (eval lid)) args vars)
    (setq args (cddr lit))
    (setq vars (make-vars (length args)))
    (make-clause (list vars (cons (car lit) (cons (cadr lit) vars))))
  )
)

;; (typical-lids *lsymlist*) => all typical lids
(defun typical-lids (lsyms)
  (loop for lsym in lsyms collect 
    (car (eval lsym))
  )
)

;; (make-ccids *lsymlist*) => new clauses
(defun make-ccids (lsyms)
  (loop for lid in (typical-lids lsyms) collect
    (canonical-clause lid)
  )
)

