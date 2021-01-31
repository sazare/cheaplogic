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
  (loop 
    with conts = ()
    with trues = ()
    with others = ()
    for cid in clist do 
    (cond
      ((isvalid cid)         (push cid trues))
      ((iscontradiction cid) (push cid conts))
      (t                     (push cid others))
    )
  finally
    (return (values others conts trues))
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
        (if *enable-semantics*
          (when (setq res (reduce-by-semantx res)) (push res newgoals))
          (push res newgoals)
        )
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


(defun quit-contra (message time-start contras valids)
  (format t "~%limit-over ~a~%" message) 
  (summary time-start)
)

(defun summary (time-start)
  (let (others contras valids)
    (multiple-value-setq (others contras valids) (gathercontra *clist*) )
    (format t "~%time consumed = ~a secs~%#clauses = ~a~%#contras = ~a~%#valids = ~a~%#trials = ~a~%#max proof steps = ~a~%"
      (- (time-current-secs) time-start)
      (length *clist*)
      (length contras)
      (length valids)
      *num-of-trials*
      *num-of-proof-steps*)
  )
)

;; template prover control for gtrail
(defun prover-gtrail (goals)
  (prog (
         (contradictions nil) 
         (valids nil)
         (proof-steps 0)
         (trials-count 0)
         (time-start (time-current-secs))
         (goallist goals)
         goal 
         newgoal
         newgoals
         cs
         ts
         )

;; preparation

    (show-parameter time-start)

;; 
    (loop named prover-loop 
       while goallist do
         (multiple-value-setq (goal goallist) (select-goal goallist))
  
         (setq  newgoal  (step-solver goal))
  
         (multiple-value-setq (newgoals cs ts) (gathercontra newgoal) )
         (setq contradictions (append cs contradictions))
         (setq valids (append ts valids))
         (setq goallist (append goallist newgoals))
         (setq newgoal nil)
         (setq *goallist* goallist)
      
         (cond
           ((> (length *clist*) *max-clauses*) 
            (return-from prover-loop (quit-contra "number of clauses exceeds" time-start contradictions valids)))
           ((> (length contradictions) *max-contradictions*)
            (return-from prover-loop (quit-contra "number of contradictions exceeds" time-start contradictions valids)))
           ((> trials-count *max-trials*)  
            (return-from prover-loop (quit-contra "number of trials exceeds" time-start contradictions valids)))
           ((> proof-steps *max-steps*)  
            (return-from prover-loop (quit-contra "number of steps exceeds" time-start contradictions valids)))
           ((> (- (time-current-secs) time-start) *timeout-sec*)
            (return-from prover-loop (quit-contra "run time exceeds" time-start contradictions valids)))
           ((when-finish-p)  
            (return-from prover-loop (quit-contra "when-finish-p decide to finish" time-start contradictions valids)))
         )
      finally
        (format t "finished. goallist is empty~%")
        (format t "contradictions=~a~%" contradictions)
        (format t "valids =~a~%" valids)
        (summary time-start)
    )
  )
)

(defun cidlistfy (namelist)
  (loop for name in namelist collect
    (cidfy name)
  )
)

(defun play-prover-gtrail (goal kqcfile)
  (let (cids agoal)
    (setq agoal goal)
    (setq cids (readkqc kqcfile))
    (make-lsymlist *llist*)

    (when *enable-semantics* 
      (loop with nids = () 
            with nid = nil
            for cid in cids do 
              (setq nids (reduce-by-semantx cid))
              (when nids (push nid nids))
      )
    )
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
;;; these functions may be unclear the purposes of them

(defun clear-atoms ()
  (loop for atm in '(*rubbish-state* *clist* *llist* *lsymlist*)
    collect
    (return (clear-atom atm))
  )
)

(defun clear-all-atoms()
  (clear-atoms '(*rubbish-state* *clist* *llist* *lsymlist*))
)

(defun clear-atoms (alist)
  (loop for gvar in alist collect 
    (cons gvar (gather-atominfo (eval gvar)))
  )
)

(defun clear-properties (atm)
  (symbol-plist atm)
)

(defun clear-atominfo (atmlist)
  (loop for atm in atmlist collect
    (list atm (eval atm) (gather-properties atm))
  )
)


;; remve all prop on atm's plist
;; this is good
(defun remove-props-on-atom (atm)
  (let ((pls (symbol-plist atm)))
    (loop for pn on pls  by #'cddr 
      collect (remprop atm (car pn))
    )
  )
)

