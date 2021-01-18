;; prover with goal trailer
;; parameters
(defparameter *max-clauses* 1000)
(defparameter *max-contradictions* 30)
(defparameter *max-trials* 100)
(defparameter *max-steps* 100)
(defparameter *timeout-sec* 10)

(defparameter *goallist* nil)


(defparameter *rubbish-state* '(*goallist* *num-of-trials*))

;;; finish time function user can defined
;(defun when-finish-p () t)
(defun when-finish-p () nil)

;;; essential functions
(defun select-goal (gs)
  (values (car gs) (cdr gs))
)

(defun gathercontra (clist)
  (let (conts unconts)
    (loop for cid in clist do 
      (if (iscontradiction cid)
        (push cid conts)
        (push cid unconts)
      )
    )
    (values conts unconts)
  )
)

(defun constract-lid (cid)
  cid
)


(defparameter *enable-semantics* t)

;;; a step of solver, a controller of the step.
(defun step-solver (goal) 
  (let (target oppos (newgoals ()) res) ;step1 select a lid in goal ; CASE CID
    (if (null (bodyof goal))
      nil   ; this should not be happen. because nil = contradiction is immediately removed at generated from goal.
      (setq target (car (bodyof goal))) ); this is a first attempt to investigate the prover.
    (setq oppos (find-oppolids target))
    (if (null oppos) 
      (format t "orphan lsym ~a~% this cid ~a can't become [].~%" target goal))
    (loop for oppo in oppos do
      (setq res (resolve-id target oppo))
      (unless (eq :FAIL res)
;; reduction = remove the literals by peval=NIL , remove the goal by peval=T.
;; if no reduction, no red was made.
;; 
        (when *enable-semantics*
          (setq res (reduce-by-semantx res))
        )
        (push res newgoals)
      )
    )
    newgoals
  )
)

(defun show-parameter (time-start)
    (format t 
  "~%time-start           = ~a (secs)
  *max-clauses*        = ~a
  *max-contradictions* = ~a
  *max-trials*         = ~a
  *max-steps*          = ~a
  *timeout-sec*        = ~a~%"
   time-start *max-clauses* *max-contradictions* *max-trials* *max-steps* *timeout-sec* ) 
)

;(format t "after2: newgoal=~a / goallist=~a / contras=~a~%" newgoal goallist contradictions)


(defun quit-contra (message time-start contras)
  (format t "~%limit-over ~a~%" message) 
  (summary time-start contras)
)

(defun summary (time-start contras)
  (format t "~%time consumed = ~a secs~%#clauses = ~a~%#contras = ~a~%#trials = ~a~%#max proof steps = ~a~%"
    (- (time-current-secs) time-start)
    (length *clist*)
    (length contras)
    *num-of-trials*
    *num-of-proof-steps*)


;; others in some future
;  *num-of-trials*
;  *num-of-proof-steps*
;
;  *num-of-input-literals*
;  *num-of-resolvents*
;  *num-of-contradictions*
;  *num-of-literals*
;  *input-clauses ())
;  *input-literals* ())

)

;; template prover control for gtrail
(defun prover-gtrail (goals)
  (prog (
         (contradictions nil) 
         (proof-steps 0)
         (trials-count 0)
         (time-start (time-current-secs))
         (goallist goals)
         goal 
         newgoal
         newgoals
         cs
         )

;; preparation

    (show-parameter time-start)

;; 
    (loop named prover-loop 
       while goallist do
         (multiple-value-setq (goal goallist) (select-goal goallist))
  
         (setq  newgoal  (step-solver goal))
  
         (multiple-value-setq (cs newgoals) (gathercontra newgoal) )
         (setq contradictions (append cs contradictions))
         (setq goallist (append goallist newgoals))
         (setq newgoal nil)
         (setq *goallist* goallist)
      
         (cond
           ((> (length *clist*) *max-clauses*) 
            (return-from prover-loop (quit-contra "number of clauses exceeds" time-start contradictions)))
           ((> (length contradictions) *max-contradictions*)
            (return-from prover-loop (quit-contra "number of contradictions exceeds" time-start contradictions)))
           ((> trials-count *max-trials*)  
            (return-from prover-loop (quit-contra "number of trials exceeds" time-start contradictions)))
           ((> proof-steps *max-steps*)  
            (return-from prover-loop (quit-contra "number of steps exceeds" time-start contradictions)))
           ((> (- (time-current-secs) time-start) *timeout-sec*)
            (return-from prover-loop (quit-contra "run time exceeds" time-start contradictions)))
           ((when-finish-p)  
            (return-from prover-loop (quit-contra "when-finish-p decide to finish" time-start contradictions)))
         )
      finally
        (format t "finished. goallist is empty~%")
        (format t "contradictions=~a~%" contradictions)
        (summary time-start contradictions)
    )
  )
)

(defun cidlistfy (namelist)
  (loop for name in namelist collect
    (cidfy name)
  )
)

(defun play-prover-gtrail (goal kqcfile)
  (let (cids)
    (setq cids (readkqc kqcfile))
    (when *enable-semantics* (loop for cid in cids collect (reduce-by-semantx cid)))
    (make-lsymlist *llist*)
    (logstart)
    (prover-gtrail (cidlistfy goal))
  )
)

;;;; environmens of prover
(defun gather-properties (atm)
  (symbol-plist atm)
)

(defun gather-atominfo (atmlist)
  (loop for atm in atmlist collect
    (list atm (eval atm) (gather-properties atm))
  )
)

(defun gather-atoms (alist)
  (loop for gvar in alist collect 
    (cons gvar (gather-atominfo (eval gvar)))
  )
)

(defun gather-allinf ()
  (gather-atoms '(*rubbish-state* *clist* *llist* *lsymlist*))
)

;;; saving
(defun save-rubbish (fname)
  (writeafile fname (gather-allinf))
)

;; loading
(defun allatomof (alist)
  (loop for atm in alist collect
    (car atm)
  )
)

(defun deploy-atoms (allinf)
  (let ()
    (loop for vinf in (cdr allinf) collect
      (progn 
        (set (car vinf) (allatomof (cdr vinf)))
        (loop for ainf in (cdr vinf) do
    ;      (format t "~a ~a ~a~%" (car ainf) (cadr ainf) (caddr ainf))
          (fsetatom (car ainf) (cadr ainf)(caddr ainf))
        )
      )
    )
  )
)

(defun load-rubbish (fname)
  (let (alli) 
    (setq alli (car (readafile fname))) ;; readafile makes a list of contents
    (deploy-atoms alli)
  )
)

;;; clear all
(defun clear-atoms ()
  (clear-atoms '(*rubbish-state* *clist* *llist* *lsymlist*))
)
