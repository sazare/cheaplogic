;; rubbish-mujun.lisp 

(in-package :rubbish)

;; for analyze and manipulate mujun 

;; logfilename

(defconstant +MUJUNLOG+ #p"mujun-output/mujun.log")
(defconstant +RESULTLOG+ #p"mujun-output/result.log")

(defun pair-or-iso (&optional (lsymlist *lsymlist*))
  "classify lsym with has oppos or not."
  (loop with fills = nil and isos = nil for lsym in lsymlist 
    do (if (boundp (oppolsymof lsym)) 
         (push lsym fills)
         (push lsym isos))
    finally (return (values fills isos))
  )
)

;;;; mujun-finder
;; mujun-finder over inner-mujun-finder over  cannon-mujun-finder
(defun mujun-finder (kqc &optional (faster nil))
  (prog (pairs isos gid g contras time-start)

    (create-flog +MUJUNLOG+)
    (create-flog +RESULTLOG+)

    (flog +MUJUNLOG+ " start: ~a~%" (local-time:now))

    (readekqc kqc)

;; when all lsym are orphans, this is consistent.

    (multiple-value-setq (pairs isos) (pair-or-iso *lsymlist*))

    (unless pairs (flog +MUJUNLOG+ "consistent because all lsyms are orphans~%")
                  (return t))
-
    (setq time-start (get-internal-run-time))

    (with-open-file (out +MUJUNLOG+
                         :direction :output
                         :if-exists :append)
       (format out "kqc file = ~a~%" kqc)
       (print-clauses *clist* out)
       (terpri out)
    )

    (if faster
      (flog +MUJUNLOG+ "inner-mujun faster run~%")
      (flog +MUJUNLOG+ "inner-mujun run~%")
    )

    (loop for n from 0 to (- (length *clist*) 1) do
      (when (check-mujun-on-n n kqc faster) (push (nth n *clist*) contras) )
     finally
      (return contras)
    )
    (flog +MUJUNLOG+ " end: ~a~%" (local-time:now))
    (flog +MUJUNLOG+ " time consumed = ~,6F secs ~%"  (/ (- (get-internal-run-time) time-start) internal-time-units-per-second) )
  )
)

;;
(defun check-mujun-on-n (gi kqc &optional (faster nil))
  (prog (cmd)
;    (format t "check-mujun-on-n g=~a kqc=~a ~%" gi kqc )
    (if faster  
      (setq cmd (with-output-to-string (out) 
               (format out "sbcl --control-stack-size 128MB --core run-gtrail --eval '(rubbish:mujun-prover-n)' '~a' '~a'" gi kqc )))
      (setq cmd (with-output-to-string (out) 
                (format out "sbcl --control-stack-size 128MB --sysinit rubbish-mujun-init.lisp --eval '(rubbish:mujun-prover-n)' '~a' '~a'" gi kqc )))
    )
    (format t "cmd = ~a~%" cmd)
    (uiop:run-program cmd  :force-output t)
    (return t)
  )
)

;; inside
; mujun-prover is called in another process by run-program
(defun mujun-prover-n ()
  (let (sexp gi kqc) 
    (setq sexp sb-ext:*posix-argv*)

    (setq gi (parse-integer (nth 1 sexp)))
    (setq kqc (nth 2 sexp))

    (mujun-prover-inside-n gi kqc) 
  )
)

(defun mujun-prover-inside-n (gi kqc )
  (let (gid sg cv)

; 2.  readkqc 
     (readekqc kqc)

; 3. which is the gid
     (setq gid (nth gi *clist*))

;     (flog +MUJUNLOG+ "rawclause gid=~a clist=~a~%" (rawclause gid) *clist*)
;     (flog +MUJUNLOG+ "~a~%" (with-output-to-string (out) (print-clauses *clist* out)))

; 4. (prover-gtrail (list gid))

     (flog +MUJUNLOG+ "before prover goal =~a~%" (rawclause gid))

    (setq cv (prover-gtrail (list gid)))

     (flog +MUJUNLOG+ "after prover gid=~a lscova= ~a ~a~%" gid (lscova) cv)

; 5. when mujun exists, then report it
    (let ((contras (car (lscova))))
      (if contras
        (loop for c in contras do 
          (flog +RESULTLOG+ "contradictions(inside): g=~a, pc=~a, p2c=~a~%" (rawclause gid) (pcode c) (p2code c))
        )
        (flog +RESULTLOG+  "no contradictions(inside): g=~a~%" (rawclause gid) )
      )
    )
  )
)


;; pure-prover-gtrail1 is in rubbish-prover-gtrail.lisp

;; this method is simple and not perfect.
;(defun check-mujun1 (g)
;  (car (pure-prover-gtrail (list g)) )
;)
;
;(defun check-mujunn (axioms)
;  (loop for g in axioms collect
;    (car (pure-prover-gtrail (list g)) )
;  )
;)
;
;(defun check-mujun (axioms)
;  (loop for g in axioms append
;    (car (pure-prover-gtrail (list g)) )
;  )
;)
;
;; 
;; pc is a pcode, cinpc make cid of pcode's lid
(defun cinpc (pc)
  (uniq (loop for lid in pc collect (cidof lid)))
)

;; mujun-set is a pure logical function
;;; this finds effectively minimal inconsistent subset of *clist* 

;; when cids make []s, make pcode of [], find cid of pcode'lid.
;(defun mujun-set (cids)
;  "mujun-set return set list and their contradictions"
;  (let (cs ups)
;    (setq cs (check-mujun cids)) 
;    (setq ups (uniq-pcodes cs))
;    (values (loop for pc in ups collect (cinpc pc)) cs)
;  )
;)

;; select a clause for 
;;; this is an implementation of an situation.

;(defun oldest-one (ms)
;  (loop with m0 = (car ms) 
;    for m on ms 
;    when (< (when-born (car m))(when-born m0)) 
;    do (setq m0 (car m))
;    finally (return m0))
;)
;
;(defun causes-contra (facts ms)
;  (loop for m in ms collect (oldest-one m))
;)
;
;;
; ∀p ∈ Pred(Σ)について、 Π(Σ, +p)⊢□または Π(Σ, -p)⊢□ができたらΣに□が含まれると考える場合
;; 1. +pか-pのどちらかでよいと思う。□ができるということは、opposのunitの証明もできるということだから
;;;; ほんとか?? NOT TRUE 6/1
;; 2. (make-psymlist *llist*) => list of pred
;;;
;
;(defun make-vars (nts)
;  (loop for n from 1 to nts collect
;    (newvar 'vc)
;  )
;)
;
;(defun canonical-clause (lid)
;  (let ((lit (eval lid)) args vars)
;    (setq args (cddr lit))
;    (setq vars (make-vars (length args)))
;    (make-clause (list vars (cons (car lit) (cons (cadr lit) vars))))
;  )
;)
;
;;; (typical-lids *lsymlist*) => all typical lids
;(defun typical-lids (lsyms)
;  (loop for lsym in lsyms collect 
;    (car (eval lsym))
;  )
;)
;
;;; (make-ccids *lsymlist*) => new clauses
;(defun make-ccids (lsyms)
;  (loop for lid in (typical-lids lsyms) collect
;    (canonical-clause lid)
;  )
;)
;
;;;

;;;; mujun-finder
; mujun-prover is called in another process by run-program
;(defun mujun-prover ()
;  (let (sexp g kqc) 
;    (setq sexp sb-ext:*posix-argv*)
;    (setq g (parse-integer (nth 1 sexp)))
;    (setq kqc (nth 2 sexp))
;    (mujun-prover-inside g kqc) 
;  )
;)

;(defun cannon-mujun-finder (kqc &optional (faster nil))
;  (let (pairs isos gid g contras time-start)
;
;    (create-flog +MUJUNLOG+)
;    (create-flog +RESULTLOG+)
;
;    (flog +MUJUNLOG+ " start: ~a~%" (local-time:now))
;
;    (readekqc kqc)
;
;    (setq time-start (get-internal-run-time))
;
;    (multiple-value-setq (pairs isos) (pair-or-iso *lsymlist*))
;
;    (if faster
;      (flog +MUJUNLOG+ "cannon-mujun faster run~%")
;      (flog +MUJUNLOG+ "cannon-mujun run~%")
;    )
;
;    (inner-mujun-finder "kqc/mujun/mj102-a.kqc" t)
;    (unless pairs (flog +MUJUNLOG+ "consistent because all lsyms are orphans~%"))
;    (when isos (flog +MUJUNLOG+ "these are orphans: ~a~%" isos))
;
;    (let (lid) 
;      (loop for lsym in pairs do
;        (setq lid (car (eval lsym)))
;        (setq gid (canonical-clause lid))
;        (setq g (rawclause0 gid))
;        ; do check-mujun g kqc
;        (when (check-mujun-on g kqc faster) (push g contras))
;       finally
;        (return contras)
;      )
;    )
;    (flog +MUJUNLOG+ " time consumed = ~,6F secs ~%"  (/ (- (get-internal-run-time) time-start) internal-time-units-per-second) )
;    (flog +MUJUNLOG+ " end: ~a~%" (local-time:now))
;  )
;)

;;; inner-mujun
;(defun inner-mujun-finder (kqc &optional (faster nil))
;  (let (pairs isos gid g contras time-start)
;
;    (create-flog +MUJUNLOG+)
;    (create-flog +RESULTLOG+)
;
;    (flog +MUJUNLOG+ " start: ~a~%" (local-time:now))
;
;    (readekqc kqc)
;
;    (setq time-start (get-internal-run-time))
;
;    (with-open-file (out +MUJUNLOG+
;                         :direction :output
;                         :if-exists :append)
;       (format out "kqc file = ~a~%" kqc)
;       (print-clauses *clist* out)
;       (terpri out)
;    )
;
;    (multiple-value-setq (pairs isos) (pair-or-iso *lsymlist*))
;
;    (format t "start : ~a" time-start)
;
;    (if faster
;      (flog +MUJUNLOG+ "inner-mujun faster run~%")
;      (flog +MUJUNLOG+ "inner-mujun run~%")
;    )
;    (unless pairs (flog +MUJUNLOG+ "consistent because all lsyms are orphans~%"))
;    (when isos (flog +MUJUNLOG+ "these are orphans: ~a~%" isos))
;
;    (let (lid) 
;      (loop for lid in *clist* do
;        (setq g (rawclause0 lid))
;        ; do check-mujun g kqc
;        (when (check-mujun-on g kqc faster) (push g contras))
;       finally
;        (return contras)
;      )
;    )
;    (flog +MUJUNLOG+ " end: ~a~%" (local-time:now))
;    (flog +MUJUNLOG+ " time consumed = ~,6F secs ~%"  (/ (- (get-internal-run-time) time-start) internal-time-units-per-second) )
;  )
;)
;
;;;
;(defun check-mujun-on (g kqc &optional (faster nil))
;  (prog (cmd)
;    (format t "check-mujun-on g=~a kqc=~a ~%" g kqc )
;    (if faster  
;      (setq cmd (with-output-to-string (out) 
;               (format out "sbcl --control-stack-size 128MB --core run-gtrail --eval '(rubbish:mujun-prover)' '~a' '~a'" g kqc )))
;      (setq cmd (with-output-to-string (out) 
;                (format out "sbcl --control-stack-size 128MB --sysinit rubbish-mujun-init.lisp --eval '(rubbish:mujun-prover)' '~a' '~a'" g kqc )))
;    )
;    (format t "cmd = ~a~%" cmd)
;    (uiop:run-program cmd  :force-output t)
;    (return t)
;  )
;)
;
;; for speed up by  using run-gtrail(make-gtrail-image)
;;               (format out "sbcl --control-stack-size 128MB --core run-gtrail --eval '(rubbish:mujun-prover)' '~a' '~a'" g kqc )))
;
;(defun mujun-prover-inside (g kqc )
;  (let (gids sg cv)
;
;; 1. get parameter(g, kqc ) in mujun-prover
;
;   (setq sg (list (cons 0 (readastring g))))
;   (flog +MUJUNLOG+ "rubbish-mujun-prover-inside param sg=~a, kqc=~a~%" sg kqc)
;
;; 2.  readkqc 
;     (readekqc kqc)
;
;; 3. (factisf g)
;
;    (setq gids (factisf sg))
;
;;     (flog +MUJUNLOG+ "rawclause gid=~a clist=~a~%" (rawclause (car gids)) *clist*)
;;     (flog +MUJUNLOG+ "~a~%" (with-output-to-string (out) (print-clauses *clist* out)))
;
;; 4. (prover-gtrail (list g))
;
;     (flog +MUJUNLOG+ "before prover gids=~a~%" (rawclause (car gids)))
;
;    (setq cv (prover-gtrail gids))
;
;     (flog +MUJUNLOG+ "after prover gids=~a lscova= ~a return=~a~%" gids (lscova) cv)
;
;; 5. when mujun exists, then report it
;    (let ((contras (car (lscova))))
;      (if contras
;        (loop for c in contras do 
;          (flog +RESULTLOG+ "contradictions(inside): gc=~a, p2c=~a, pc=~a~%" (rawclause (car gids)) (p2code c) (pcode c))
;        )
;        (flog +RESULTLOG+  "no contradictions(inside): gc=~a, ~a ~%" (rawclause (car gids)) contras)
;      )
;    )
;  )
;)
;
;
