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

(defun allsinglevars (mm)
  "collect all atom in mm"
; it contains constants,
  (loop for m in mm  with vs do 
    (setq vs (append (car (nth 1 m)) vs)) 
    (loop for mr in (cadr (nth 1 m)) when (atom mr) do (push mr vs)) 
    finally
    (return vs)
  )
)

(defun allvars (mm)
  (loop for v in (allsinglevars mm) collect (list v))
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

;;
(defun print-mm (mm)
  (loop for x in mm do (format t "~a ~a~%" (car x)(cadr x)))
)

(defun find-sigma (v m1)
  (loop for s in m1 with ss do
    (cond 
      ((eq v (car s)) (push s ss))
      ((eq v (cadr s)) (push (list (cadr s) (car s)) ss))
    )
    finally
    (return ss)
  )
)

(defun isconst(sym)
  (string-equal sym (vrootof sym))
)

(defun remove-nil (ls)
  (loop for e in ls when e collect e)
)

(defparameter *checked-vars* ())

(defun checkit (v) (push v *checked-vars*))

(defun ischecked (v) (member v *checked-vars*))

(defun clearchecked () (setq *checked-vars* ()))

(defun vartrace* (v* m1)
  (loop for v in v* unless (isconst v) collect
    (vartrace v m1)
  )
)

(defun vartrace (v m1)
  (let (ssp ss s1 trace atrace)
    (setq ssp (list v))
    (loop while ssp do
      (setq v (pop ssp))

(format  t "find-sigma: v=~a ssp=~a ~%" v ssp )
      (setq ss (find-sigma v m1))

      (when ss (setq ssp (append ss ssp)) )
(format  t "append sigma: ss=~a ssp=~a ~%" ss ssp )

      (setq s1 (pop ssp))
(format  t "pop ssp: ssp=~a s1=~a cadr=~a~%" ssp s1 (cadr s1)) 

      (loop while (and ssp (ischecked (cadr s1))) do
(format  t "1 ssp=~a s1=~a cadr=~a~%" ssp s1 (cadr s1)) 
        (setq s1 (pop ssp))
      )

(format t "2 checkit s1=~a cadr=~a~%" s1 (cadr s1))

      (checkit (cadr s1))

(format t "3 push s1 to trace  s1=~a trace=~a~%" s1 trace)
      (push s1 trace)

(format t "before vartrace* : s1=~a atrace=~a~%" s1 atrace)

      (when (listp (cadr s1)) (setq atrace  (vartrace* (cdr (cadr s1)) m1)))

(format t "5 trace=~a atrace=~a~%" trace atrace)
      (push atrace trace)

(format t "6 trace=~a atrace=~a~%" trace atrace)
      (setq atrace nil)
    )
    (remove-nil trace)
  )
)

(defun trace-vars (v mm)
  (let (m1)
    (setq m1 (break-mgu* mm))

    (clearchecked )

    (vartrace v m1)
  )
)
  
;; do
(defparameter mm (mguofΣ))
(print-mm mm)

(defparameter m1 (break-mgu* mm))
(print-mm m1)

(defparameter vs (allvars mm))

(clearchecked)
(vartrace 'z.157 m1)


