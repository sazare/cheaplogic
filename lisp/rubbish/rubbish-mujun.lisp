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

(defun cannon-mujun-finder (kqc)
  (let (pairs isos gid g contras)
    (readekqc kqc)
    (multiple-value-setq (pairs isos) (pair-or-iso *lsymlist*))

    (create-flog "mujun-output/mujun.log")
    (create-flog "mujun-output/result.log")

    (flog "mujun-output/mujun.log" "cannon-mujun run~%")
    (unless pairs (flog "mujun-output/mujun.log" "consistent because all lsyms are orphans~%"))
    (when isos (flog "mujun-output/mujun.log" "these are orphans: ~a~%" isos))

    (let (lid) 
      (loop for lsym in pairs do
        (setq lid (car (eval lsym)))
        (setq gid (canonical-clause lid))
        (setq g (rawclause0 gid))
        ; do check-mujun g kqc
        (when (check-mujun-on g kqc ) (push g contras))
       finally
        (return contras)
      )
    )
  )
)
;;; inner-mujun
(defun inner-mujun-finder (kqc)
  (let (pairs isos gid g contras)
    (readekqc kqc)
    (multiple-value-setq (pairs isos) (pair-or-iso *lsymlist*))

    (create-flog "mujun-output/mujun.log")
    (create-flog "mujun-output/result.log")

    (flog "mujun-output/mujun.log" "inner-mujun run~%")
    (unless pairs (flog "mujun-output/mujun.log" "consistent because all lsyms are orphans~%"))
    (when isos (flog "mujun-output/mujun.log" "these are orphans: ~a~%" isos))

    (let (lid) 
      (loop for lid in *clist* do
        (setq g (rawclause0 lid))
        ; do check-mujun g kqc
        (when (check-mujun-on g kqc ) (push g contras))
       finally
        (return contras)
      )
    )
  )
)
;;
(defun check-mujun-on (g kqc )
  (prog (cmd)
    (format t "check-mujun-on g=~a kqc=~a ~%" g kqc )
    (setq cmd (with-output-to-string (out) 
                (format out "sbcl --control-stack-size 128MB --sysinit rubbish-mujun-init.lisp --eval '(rubbish:mujun-prover)' '~a' '~a'" g kqc )))
    (format t "cmd = ~a~%" cmd)
    (uiop:run-program cmd  :force-output t)
    (return t)
  )
)

; for speed up by  using run-gtrail(make-gtrail-image)
;               (format out "sbcl --control-stack-size 128MB --core run-gtrail --eval '(rubbish:mujun-prover)' '~a' '~a'" g kqc )))

(defun mujun-prover-inside (g kqc )
  (let (gids sg cv)
; 1. get parameter(g, kqc ) in mujun-prover

   (setq sg (list (cons 0 (readastring g))))

   (flog "mujun-output/mujun.log" "rubbish-mujun-prover-inside param sg=~a, kqc=~a~%" sg kqc)

; 2.  (readkqc kqc)
     (readkqc kqc)

; 3. (factisf g)
    (setq gids (factisf sg))

;     (flog "mujun-output/mujun.log" "rawclause gid=~a clist=~a~%" (rawclause (car gids)) *clist*)
;     (flog "mujun-output/mujun.log" "~a~%" (with-output-to-string (out) (print-clauses *clist* out)))

; 4. (prover-gtrail (list g))

    (setq cv (prover-gtrail gids))

;     (flog "mujun-output/mujun.log" "after prover gids=~a lscova= ~a ~a~%" gids (lscova) cv)

; 5. when mujun exists, then report it
    (let ((contras (car (lscova))))
      (if contras
        (loop for c in contras do 
          (flog "mujun-output/result.log" "contradictions(inside): ~a, p2c=~a, pc=~a~%" (rawclause (car gids)) (p2code c) (pcode c))
        )
        (flog "mujun-output/result.log" "no contradictions(inside): ~a, ~a ~%" (rawclause (car gids)) contras)
      )
    )
  )
)


; mujun-prover is called in another process by run-program
(defun mujun-prover ()
  (let (sexp g kqc) 
    (setq sexp sb-ext:*posix-argv*)
    (setq g (nth 1 sexp))
    (setq kqc (nth 2 sexp))
    (mujun-prover-inside g kqc) 
  )
)

