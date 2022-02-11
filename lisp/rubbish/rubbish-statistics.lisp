;; rubbish-statistics.lisp

(in-package :rubbish)

; variables for statistics

(defparameter *num-of-input-literals* 0)   ;
(defparameter *num-of-trials* 0)           ; how many unifications do?
(defparameter *num-of-proof-steps* 0)      ; how long proof is?

(defparameter *num-of-contradictions* 0)   ; # of contradictions(iscontradiction over *clist*)
(defparameter *num-of-literals* 0)         ; = (length *llist*)
(defparameter *input-clauses* ())          ; as the *clist* immediately after read kqc file
(defparameter *input-literals* ())         ; all literals of input clauses
(defparameter *num-of-resolvents* 0)       ; # of resolvents = (*clist* - input-clause)


(defun reset-stat ()
  (setq *num-of-input-literals* 0)   
  (setq *num-of-trials* 0)
  (setq *num-of-proof-steps* 0)

  (setq *num-of-contradictions* 0)
  (setq *num-of-literals* 0)
  (setq *input-clauses* ())
  (setq *input-literals* ())
  (setq *num-of-resolvents* 0)
)
