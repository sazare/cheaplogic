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
(defun mguofl0 ()
  (loop for plsls in (make-pair-lids) append
    (loop for ll in (combi (cadr plsls) (caddr plsls))
      collect
        (list plsls (unify-pair (car ll) (cadr ll)))
    )
  )
)


;;; do
 (defparameter mm (mguofl0))
 (loop for x in mm do (format t "~a~%" x))


