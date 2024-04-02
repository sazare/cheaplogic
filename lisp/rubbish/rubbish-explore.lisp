;; rubbish-expore.lisp

(in-package :rubbish)

;; expore is an attempt to a prover.

(defun make-pair-lids ()
  (loop for p in (make-psymlist *llist*)
    collect 
      (list p (eval (ptolsym '+ p)) (eval  (ptolsym '- p)))
  )
)

(defun unify-pair (lid1 lid2)
  (let ((vars (append (varsof (cidof lid1)) (varsof (cidof lid2)))))
    (list vars  
      (unificationp vars (cdr (eval lid1)) (cdr (eval lid2)))
    )
  )
)

(defun combi (ls1 ls2)
  (loop for l1 in ls1 append
    (loop for l2 in ls2 collect
      (list l1 l2)
    )
  )
)

(defun remove-empty (mgu)
  (let (vs ms nv nm)
    (setq vs (car mgu))
    (setq ms (cadr mgu))
    (loop for v in vs as m in ms when (not (eq v m)) do
      (push v nv)
      (push m nm)
    )
    (list nv nm)
  )
)

(defun mguofΣ()
  (loop for plsls in (make-pair-lids) append
    (loop for ll in (combi (cadr plsls) (caddr plsls))
      collect
        (list (cons (car plsls) ll) (remove-empty (unify-pair (car ll) (cadr ll))))
    )
  )
)

(defun allvars (mm)
  (loop for v in (loop for m in mm append (car (nth 1 m)))
      collect (list v)
  )
)

(defun break-mgu (mgu)
  (loop for v1 in (car mgu)
         as m1 in (cadr mgu)
      unless (eq v1 m1)
      collect (list v1 m1)
  )
)
  
(defun break-mgu* (mm)
  (loop for m in mm append
    (break-mgu (cadr m))
  )
)


(defun print-mm (mm)
  (loop for x in mm do (format t "~a ~a~%" (car x)(cadr x)))
)

;; do
(defparameter mm (mguofΣ))
(print-mm mm)
(defparameter vs (allvars mm))
(defparameter 1m (break-mgu* mm))
(print-mm 1m)


