;; prover with goal trailer
;; parameters
(defparameter *max-clauses* 1000)
(defparameter *max-contradictions* 10)
(defparameter *max-trials* 100)
(defparameter *max-steps* 100)
(defparameter *timeout-sec* 10)


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

(defun quit-contra (message)
  (format t "~%limit-over ~a~%" message) 
)

(defun step-solver (goal) ; goal is cid
  (let (target oppos (newgoals ()) res ) ;step1 select a lid in goal ; CASE CID
    (if (null (bodyof goal))
      nil   ; this should not be happen. because nil = contradiction already removed.
      (setq target (car (bodyof goal))) ); this is a first step of big investigation(may no exit)
    (setq oppos (find-oppolids target))
    (if (null oppos) 
      (format t "orphan lsym ~a~% this cid ~a can't become [].~%" target goal))
      (loop for oppo in oppos do
        (setq res (resolve-id target oppo))
        (unless (eq :FAIL res) (push res newgoals))
      )
    newgoals
  ) 
)

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

  (format t 
"~%time-start           = ~a
*max-clauses*        = ~a
*max-contradictions* = ~a
*max-trials*         = ~a
*max-steps*          = ~a
*timeout-sec*        = ~a~%"
 time-start *max-clauses* *max-contradictions* *max-trials* *max-steps* *timeout-sec* ) 

;; 
  (loop named prover-loop 
     while goallist do
       (multiple-value-setq (goal goallist) (select-goal goallist))

       (setq  newgoal  (step-solver goal))

;(format t "before: newgoal=~a / goallist=~a / contras=~a~%" newgoal goallist contradictions)
       (multiple-value-setq (cs newgoals) (gathercontra newgoal) )
       (setq contradictions (append cs contradictions))
       (setq goallist (append goallist newgoals))
       (setq newgoal nil)
;(format t "after2: newgoal=~a / goallist=~a / contras=~a~%" newgoal goallist contradictions)

       (cond
         ((> (length *clist*) *max-clauses*) (return-from prover-loop (quit-contra "number of clauses exceeds")))
         ((> (length contradictions) *max-contradictions*)  (return-from prover-loop (quit-contra "number of contradictions exceeds")))
         ((> trials-count *max-trials*)  (return-from prover-loop (quit-contra "number of trials exceeds")))
         ((> proof-steps *max-steps*)  (return-from prover-loop (quit-contra "number of steps exceeds")))
         ((> (- (time-current-secs) time-start) *timeout-sec*)  (return-from prover-loop (quit-contra "run time exceeds")))
         ((when-finish-p)  (return-from prover-loop (quit-contra "when-finish-p decide to finish")))
       )
  )
  (format t "finished~%")
  (format t "contradictions=~a~%goallist=~a~%" contradictions goallist)
  )
)

