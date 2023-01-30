;; parameter definitions

(in-package :rubbish)

; variables for statistics

(defparameter *num-of-input-literals* 0)   ;
(defparameter *num-of-trials* 0)           ; how many unifications do?

; it seems too time consuming, i calculate it from *clist*. so, the below variable is not used.
(defparameter *num-of-proof-steps* 0)      ; how long proof is?

(defparameter *num-of-contradictions* 0)   ; # of contradictions(iscontradiction over *clist*)
(defparameter *num-of-literals* 0)         ; = (length *llist*)
(defparameter *input-clauses* ())          ; as the *clist* immediately after read kqc file
(defparameter *input-literals* ())         ; all literals of input clauses
(defparameter *num-of-resolvents* 0)       ; # of resolvents = (*clist* - input-clause)

(defparameter *max-clauses* 1000)
(defparameter *max-contradictions* 30)
(defparameter *max-trials* 100)
(defparameter *max-steps* 100)
(defparameter *timeout-sec* 10)

(defparameter *max-cid* 0)

(defparameter *goallist* nil)

(defparameter *rubbish-state* '(*goallist* *num-of-trials*))

(defparameter *enable-semantics* nil)

(defun reset-env ()
  (clear-all-atoms)
  (setq *maxcid* 0)
  (logreset)
)

