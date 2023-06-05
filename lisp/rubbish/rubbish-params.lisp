;; parameter definitions

(in-package :rubbish)

; process control parameters
(defparameter *enable-semantics* nil)     ;; use reduce-by-semantix
;(defparameter *enable-semantics* t)     ;; use reduce-by-semantix
(defparameter *enable-reduce-syntax* t) ;; don't use reduce-by-syntax
;(defparameter *enable-reduce-syntax* nil) ;; don't use reduce-by-syntax

;(defparameter *max-clauses* 1000)
(defparameter *max-clauses* 5000)
(defparameter *max-contradictions* 30)
(defparameter *max-trials* 10000) 
(defparameter *max-steps* 100)
(defparameter *timeout-sec* 10)

;; internal used variables
;; local vars
; variables for statistics
(defparameter *num-of-input-literals* 0)   ;
(defparameter *trials-count* 0)           ; how many unifications do?
; it seems too time consuming, i calculate it from *clist*. so, the below variable is not used.
(defparameter *num-of-proof-steps* 0)      ; how long proof is? NOT USED YET.

(defparameter *contradictions* ())
(defparameter *num-of-literals* 0)         ; = (length *llist*)
(defparameter *input-clauses* ())          ; as the *clist* immediately after read kqc file
(defparameter *input-literals* ())         ; all literals of input clauses
(defparameter *num-of-resolvents* 0)       ; # of resolvents = (*clist* - input-clause)
(defparameter *max-cid* 0)
(defparameter *when-born* 0)

(defparameter *goallist* nil)

(defparameter *rubbish-state* '(*goallist* *trials-count*))


(defun reset-env ()
  (clear-all-atoms)
  (setq *maxcid* 0)
  (logreset)
)

