;; rubbish-mujun.lisp 

(in-package :rubbish)

;; for analyze and manipulate mujun 

;; logfilename

(defconstant +MUJUNLOG+ #p"mujun-output/mujun.log")
(defconstant +RESULTLOG+ #p"mujun-output/result.log")
(defconstant +RESULTMSG+ #p"mujun-output/result.msg")

(defun pair-or-iso (&optional (lsymlist *lsymlist*))
  "classify lsym with has oppos or not."
  (loop with fills = nil and isos = nil for lsym in lsymlist 
    do (if (boundp (oppolsymof lsym)) 
         (push lsym fills)
         (push lsym isos))
    finally (return (values fills isos))
  )
)

;;; CHILD-PARENT PROTOCOL
;; for return value of child is passed thrugh "mujun-output/result.msg"
;; for contradiction it contains pcode of the dontra.
(defun contradictions-info ()
  (let (cont*)
    (setq cont* (nth 0 (lscova)))
    (cond 
      (cont* 
        (let ((class (classify-cid-by-pcode cont*)))
          (loop for ca in class collect (nth 0 ca)))
        )
      (t :consistent)
    )
  )
)

(defun send-result (gid)
  (let ((contras (car (lscova))))
    (cond
      (contras
        (fmsg +RESULTMSG+ "(contradiction ~a ~a)" (rawclause gid) (contradictions-info) )
        (flog +RESULTLOG+ "(contradiction ~a ~a)" (rawclause gid) (contradictions-info) )
      )
      (t
        (fmsg +RESULTMSG+  "(consistent ~a)" (rawclause gid) )
        (flog +RESULTLOG+  "(consistent ~a)" (rawclause gid) )
      ) 
    )
  )
)

(defun read-result ()
  (with-open-file (in +RESULTMSG+) 
    (let (g pcs ss)
      (loop until (eq :eof (setf ss (read in nil :eof))) collect
        (progn 
          (setq g (nth 1 (nth 1 ss))) 
          (setq pcs (nth 2 (nth 1 ss))) 
          (format t "~a: ~a~%" g pcs)
          (cons g pcs)
        )
      )
    )
  )
)

;;;; mujun-finder(parent)
;; mujun-finder over mujun-finder over  cannon-mujun-finder
(defun mujun-finder (kqc &optional (faster nil))
  (prog (answer pairs isos gid g contras time-start)

    (create-flog +MUJUNLOG+)
    (create-flog +RESULTLOG+)
    (new-flog +RESULTMSG+)

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
      (flog +MUJUNLOG+ "run-gtrail run for faster run~%")
      (flog +MUJUNLOG+ "no run-grail run~%")
    )

    (loop for n from 0 to (- (length *clist*) 1) do
      (when (check-mujun-on-n n kqc faster) (push (nth n *clist*) contras) )
     finally (setq answer (read-result))
    )
    (flog +MUJUNLOG+ " end: ~a~%" (local-time:now))
    (flog +MUJUNLOG+ " time consumed = ~,6F secs ~%"  (/ (- (get-internal-run-time) time-start) internal-time-units-per-second) )
    (return answer)
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
;    (format t "cmd = ~a~%" cmd)
    (uiop:run-program cmd  :force-output t)

    (return t)
  )
)

;; child process
; mujun-prover is called in the parent process by run-program
(defun mujun-prover-n ()
  (let (sexp gi kqc) 
    (setq sexp sb-ext:*posix-argv*)

    (setq gi (parse-integer (nth 1 sexp)))
    (setq kqc (nth 2 sexp))

    (mujun-prover-inside-n gi kqc) 
  )
)

;; mujun-prover-inside-n DO search the contradictions if any.
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

; 5. when mujun exists, then report it to the parent
    (send-result gid)
  )
)

