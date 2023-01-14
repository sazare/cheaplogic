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

;; statics by computed

(defun print-pcodes (&optional (cids *clist*))
   (loop for cid in cids do (format t "~a ~a~%" cid (pcode cid)))
)

(defun uniq-pcodes (&optional (cids *clist*))
  (loop for cid in cids with ss = () do
    (pushnew (pcode cid) ss :test #'equal)
    finally (return ss)
  )
)
   
(defun find-cid-by-pcode (pcode &optional (cids *clist*))
  (loop for cid in cids 
    when (equal pcode (pcode cid)) collect cid
  )
)

(defun classify-cid-by-pcode (&optional (cids *clist*))
  (let (pcodes )
    (setq pcodes (uniq-pcodes cids))
    (loop for pc in pcodes collect
      (list pc (find-cid-by-pcode pc))
    )
  )
)


;;;;
(defun analyze-pcode ()
  (let (cc xx yy zz)
    (setq cc (car (lscova)))
    (setq xx (classify-cid-by-pcode cc))
    (setq yy (loop for pc in xx collect (list (length (cadr pc) )(car pc))))
    (setq zz (sort yy (lambda (x y) (> (car x)(car y)))))
    zz
  )
)

(defun print-analyze (csp)
  (terpri t)
  (format t "kqc file             : ~a~%" *kqcfile*)
  (format t "*max-contradictions* : ~a~%" *max-contradictions*)
  (format t "# of pcodes          : ~a~%" (length csp))
  (loop for z in csp do (format t "~a ~a~%" (car z)(cadr z)))
)


      
 
