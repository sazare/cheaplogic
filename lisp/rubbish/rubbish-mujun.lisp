;; rubbish-mujun.lisp 

(in-package :rubbish)

;; for analyze and manipulate mujun 

;; pure-prover-gtrail1 is in rubbish-prover-gtrail.lisp


;; this method is simple but not perfect.
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

;;;
(defun pair-or-iso (&optional (lsymlist *lsymlist*))
  "classify lsym with has oppos or not."
  (loop with fills = nil and isos = nil for lsym in lsymlist 
    do (if (boundp (oppolsymof lsym)) 
         (push lsym fills)
         (push lsym isos))
    finally (return (values fills isos))
  )
)


;;; check-mujun-controller
(defun check-mujun-controller (kqc)
  (let (pairs isos gid g contras)
    (readekqc kqc)
    (multiple-value-setq (pairs isos) (pair-or-iso *lsymlist*))
    (unless pairs (format t "consistent because all lsyms are orphans~%"))
    (let (lid ofile)
      (loop for lsym in pairs as i from 1 do
        (setq lid (car (eval lsym)))
        (setq gid (canonical-clause lid))
        (setq g (rawclause gid))
        (setq ofile (with-output-to-string (out) (format out "mujun-output/mujun~3,'0d.out" i)))
        ; do check-mujun g kqc
        (when (check-mujun-on g kqc ofile) (push g contras))
       finally
        (return contras)
      )
    )
  )
)

;;; check-mujun-
(defun check-mujun-on (g kqc ofile)
  (prog (cmd)
    (format t "check-mujun-on ~a ~a ~ofile~%" g kqc ofile)
    (setq cmd (with-output-to-string (out) 
                (format out "sbcl --control-stack-size 128MB --userinit 'rubbish-mujun-prover.lisp'  --eval '(mujun-prover)' '~a' '~a' '~a'" g kqc ofile)))
    (format t "call ~a~%" cmd)
    (uiop:run-program cmd  :force-output t)
    (return t)
  )
)


(defun mujun-prover-inside (g kqc ofile)
  (let (sexp)

; 1. get parameter(g, kqc, ofile) in mujun-prover

; 2. (factisf g)
     (setq gid (factisf g))

; 3.  (readkqc kqc)
     (readkqc kqc)

; 4. (prover-gtrail g)

    (prover-gtrail (list gic))

; 5. when mujun exists, then report it in ofile
    (with-open-file (out ofile
                         :direction :output
                         :if-exists :supersede)
      (format out "in rubbish-mujun-prover-inside~%")
      (format out "~a ~a~%" g (car (lscova)))
    ) 
  )
)


