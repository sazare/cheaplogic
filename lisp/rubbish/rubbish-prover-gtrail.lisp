;; prover with goal trailer
;; template for goal trailer prover

(in-package :rubbish)

;(load "load-rubbish.lisp")
;(readkqc "kqc/file/path")
;(make-lsymlist *llist*)
;(prover-grail '(c1))


;; parameters see rubbish-params.lisp
;; see also rubbish.conf

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


(defparameter *enable-semantics* nil)
;(defparameter *enable-semantics* t)

(defun findoppos (goal)
  (let (oppos)
    (loop for target in (bodyof goal) 
      do 
        (if (setq oppos (find-oppolids target))
           (return  (values target oppos))
           (format t "orphan lsym ~a in ~a.~%" target goal)
        )
    )
  )
)

;;; a step of solver, a controller of the step.
(defun step-solver (goal) 
  (let (target oppos (newgoals ()) res rres eres) ;step1 select a lid in goal ; CASE CID
    (if (null goal)
      nil   ; this should not be happen. 
            ;because nil = contradiction is immediately removed at generated from goal.
      (setf (values target oppos) (findoppos goal)) ; this is a first attempt to investigate the prover.
    )
    (loop for oppo in oppos  do
      (setq res (resolve-id target oppo))
      (when (not (eq :FAIL res))
        (push res newgoals)
        (setq rres (step-reduce-syntax res))
        (if rres (push rres newgoals))
;; reduction = remove the literals by peval=NIL , remove the goal by peval=T.
;; if no reduction, no red was made.
;; 
        (when  *enable-semantics*
          (when 
           (when res (setq eres (reduce-by-semantx res)) 
             (push eres newgoals))
           (when rres (setq erres (reduce-by-semantx rres)) 
             (push eres newgoals))
          )
        )
      )
    )
    newgoals
  )
)


(defun show-parameter0 (goals out)
  (format out 
  "
  *kqcfile*            = ~a 
  goals                = ~a
  *max-clauses*        = ~a
  *max-contradictions* = ~a
  *max-trials*         = ~a
  *max-steps*          = ~a
  *timeout-sec*        = ~a
  *enable-semantics*   = ~a~%"
   *kqcfile*
   goals
   *max-clauses* *max-contradictions* *max-trials* *max-steps* *timeout-sec* 
   *enable-semantics*) 
)

(defun show-parameter (goals time-start)
    (format t 
  "~%start-time: ~a ~%
  ### PARAMETERS ###
  *kqcfile*            = ~a 
  goals                = ~a
  *max-clauses*        = ~a
  *max-contradictions* = ~a
  *max-trials*         = ~a
  *max-steps*          = ~a
  *timeout-sec*        = ~a
  *enable-semantics*   = ~a~%"
   (local-time:now) *kqcfile* goals 
   *max-clauses* *max-contradictions* *max-trials* *max-steps* *timeout-sec*  
   *enable-semantics*) 
)

;(format t "after2: newgoal=~a / goallist=~a / contras=~a~%" newgoal goallist contradictions)

; show-allparams

(defun show-allparams (&optional (out t))
 (progn
    (format out "*enable-semantics*	= ~a~%" *enable-semantics*)
    (format out "*goallist*			= ~a~%" *goallist*)
    (format out "*input-clauses*	= ~a~%" *input-clauses*)
    (format out "*input-literals*	= ~a~%" *input-literals*)
;    (format out "*kb*    = ~a~%" *kb*)
    (format out "*kqcfile*			= ~a~%" *kqcfile*)
    (format out "*logging-active*    = ~a~%" *logging-active*)
    (format out "*lsymlist*    = ~a~%" *lsymlist*)
    (format out "*max-clauses*    = ~a~%" *max-clauses*)
    (format out "*max-contradictions*    = ~a~%" *max-contradictions*)
    (format out "*max-steps*    = ~a~%" *max-steps*)
    (format out "*max-trials*    = ~a~%" *max-trials*)
    (format out "*num-of-contradictions*    = ~a~%" *num-of-contradictions*)
    (format out "*num-of-input-literals*    = ~a~%" *num-of-input-literals*)
    (format out "*num-of-literals*    = ~a~%" *num-of-literals*)
    (format out "*num-of-proof-steps*    = ~a~%" *num-of-proof-steps*)
    (format out "*num-of-resolvents*    = ~a~%" *num-of-resolvents*)
    (format out "*num-of-trials*    = ~a~%" *num-of-trials*)
    (format out "*pcodelist*    = ~a~%" *pcodelist*)
    (format out "*peval-active*    = ~a~%" *peval-active*)
  ;  (format out "*rubbish-log*    = ~a~%" *rubbish-log*)
    (format out "*rubbish-state*    = ~a~%" *rubbish-state*)
    (format out "*ssubst*    = ~a~%" *ssubst*)
    (format out "*ssubsub*    = ~a~%" *ssubsub*)
    (format out "*sunification*    = ~a~%" *sunification*)
    (format out "*timeout-sec*    = ~a~%" *timeout-sec*)
    (format out "*validlist*    = ~a~%" *validlist*)
    (format out "*max-cid*    = ~a~%" *max-cid*)
    nil
  )
)    


(defun quit-contra (message time-start contras valids)
  (format t "~%limit-over ~a~%" message) 
  (summary time-start)
)

(defun summary0 (out)
  (let (others contras valids)
    (multiple-value-setq (others contras valids) (gathercontra *clist*) )
    (format out  "~%#clauses = ~a~%#contras = ~a~%#valids = ~a~%#trials = ~a~%#max refute steps = ~a~%"
      (length *clist*)
      (length contras)
      (length valids)
      *num-of-trials*
      (loop with s = 0 for cid in (car (lscova)) collect 
       (setq s (max s (depth-cid cid))) finally (return s)
      )
    )
  )
)

(defun summary (time-start)
  (let (others contras valids)
    (multiple-value-setq (others contras valids) (gathercontra *clist*) )
    (format t "~%end-time: ~a~%" (local-time:now))
    (format t "
  ### SUMMARY ###
  time consumed = ~,6F secs
  #clauses = ~a
  #contras = ~a
  #valids = ~a
  #trials = ~a
  #max refute steps = ~a"
      (/ (- (get-internal-run-time) time-start) internal-time-units-per-second)
      (length *clist*)
      (length contras)
      (length valids)
      *num-of-trials*
      (loop with s = 0 for cid in (car (lscova)) collect 
       (setq s (max s (depth-cid cid))) finally (return s)
      )
    )
  )
)

(defun pure-prover-gtrail (goals)
  (prog (
         (contradictions nil) 
         (valids nil)
         (proof-steps 0)
         (trials-count 0)
         (goallist goals)
         goal 
         newgoal
         newgoals
         cs
         ts
         )


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
     
         (rubbish-log :goallist goallist)
 
         (cond
           ((> (length *clist*) *max-clauses*) 
            (return-from prover-loop (list contradictions valids)))
           ((> (length contradictions) *max-contradictions*)
            (return-from prover-loop (list contradictions valids)))
           ((> trials-count *max-trials*)  
            (return-from prover-loop (list contradictions valids)))
           ((> proof-steps *max-steps*)  
            (return-from prover-loop (list contradictions valids)))
           ((eval (when-finish-p)  )
            (return-from prover-loop (list contradictions valids)))
         )
      finally
        (return (list contradictions valids))
    )
  )
)


;; template prover control for gtrail
(defun prover-gtrail (goals)
  (prog (
         (contradictions nil) 
         (valids nil)
         (proof-steps 0)
         (trials-count 0)
         (time-start (get-internal-run-time))
         (goallist goals)
         goal 
         newgoal
         newgoals
         cs
         ts
         )

;; preparation

    (show-parameter goals time-start)

;; debug
(with-open-file (out "work.txt" :direction :output :if-exists :append)

(format out "~a in prover-gtrail " (local-time:now))
(format out "goals=~a ~%" goals )

;; 
    (loop named prover-loop 
       while goallist do
         (multiple-value-setq (goal goallist) (select-goal goallist))
  
         (setq  newgoal  (step-solver goal))
  
         (multiple-value-setq (newgoals cs ts) (gathercontra newgoal) )
         (setq contradictions (append cs contradictions))

(format out "~a prover-gtrail " (local-time:now))
(format out "eval goal = ~a  " (eval goal))
(format out "goal=~a contras=~a newgoal==~a ~%" goal contradictions newgoal)


         (setq valids (append ts valids))
         (setq goallist (append goallist newgoals))
         (setq newgoal nil)
         (setq *goallist* goallist)
     
         (rubbish-log :goallist goallist)
 
         (cond
           ((> (length *clist*) *max-clauses*) 
            (return-from prover-loop (quit-contra "number of clauses exceeds" time-start contradictions valids)))
           ((> (length contradictions) *max-contradictions*)
            (return-from prover-loop (quit-contra "number of contradictions exceeds" time-start contradictions valids)))
           ((> trials-count *max-trials*)  
            (return-from prover-loop (quit-contra "number of trials exceeds" time-start contradictions valids)))
           ((> proof-steps *max-steps*)  
            (return-from prover-loop (quit-contra "number of steps exceeds" time-start contradictions valids)))
           ((> (/ (- (get-internal-run-time) time-start) internal-time-units-per-second) *timeout-sec*)
            (return-from prover-loop (quit-contra "run time exceeds" time-start contradictions valids)))
           ((eval (when-finish-p)  )
            (return-from prover-loop (quit-contra "when-finish-p decide to finish" time-start contradictions valids)))
         )
      finally
        (format t "~%end-time: ~a~%~%" (local-time:now))
        (format t "finished. goallist is empty~%")
        (format t "contradictions=~a~%" contradictions)
        (format t "valids =~a~%" valids)
        (summary time-start) 
    )
  )
  )
)

;; macro interface

(defmacro pg (goals)
  `(prover-gtrail (quote ,goals))
)

; cidlistfy makes number to cid
;(defun cidlistfy (namelist)
;  (loop for name in namelist collect
;    (cidfy name)
;  )
;)

;; start process
(defun start-prover-gtrail (kqcfile)
  (let (cids )
    (setq cids (readekqc kqcfile))
    (make-lsymlist *llist*)

    (when *enable-semantics* 
      (loop with nids = () 
            with nid = nil
            for cid in cids do 
              (setq nids (reduce-by-semantx cid))
              (when nids (push nid nids))
      )
    )
  )
)

;; prover from kqc to 
;; this show how to use start-prover-gtrail and prover-gtrail
(defun play-prover-gtrail (goal kqcfile)
  (let ()
    (start-prover-gtrail kqcfile)
    (logstart)
    (prover-gtrail goal)
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

(defun clear-all-atoms()
  (clear-atoms (append *rubbish-state* *clist* *llist* *lsymlist*))
  (setf *clist* nil)
  (setf *llist* nil)
  (setf *lsymlist* nil)

  ;below parameters
  (setf *goallist* nil)
  (setf *num-of-trials* 0)
  (setf *maxcid* 0)
)

(defun clear-atoms (atomlist)
  (loop for atm in atomlist 
    do (clear-atom atm)
  )
)

(defun clear-atom (atm)
  (let ()
    (remove-plist-of-atom atm)
    (makunbound atm)
  )
)


;; remve all prop on atm's plist
;; this is good
(defun remove-plist-of-atom (atm)
  (let ((pls (symbol-plist atm)))
    (loop for pn on pls  by #'cddr do 
      (remprop atm (car pn))
    )
  )
)


;; remove a cid from the world

; cidを消すとは
;　1) (bodyof cid)のlidの消去
;　　1.1) lidの消去とは
;　　　　　1.1.1) symbol-plistの全消去 (remove-plist-of-atom lid)
;　　　　　1.1.2) lidのbindingの消去 (makunbound lid)
;          1.1.3) *lsymlist*のlsymからlidを消す。もしもnilになったらそのまま
;　2) cidのplistの全消去 (remove-plist-of-atom cid)
;  3) cidのbindingの消去 (makunbound cid)

(defun remove-lids (lids)
  (loop for lid in lids do
      (remove-plist-of-atom lid)
      (remove-lsym lid)
      (setq *llist* (delete lid *llist*))
      (makunbound lid)
  )
)

(defun remove-lsym (lid)
;; *lsymlist* has only lsym of input literals.
;; (eval lsym) is nil when removed.
  (set (lsymof lid) (delete lid (eval (lsymof lid)))) 
)


(defun remove-cid (cid)
  (remove-lids (bodyof cid))
  (remove-plist-of-atom cid)
  (setq *clist* (delete cid *clist*))
  (makunbound cid)
)


