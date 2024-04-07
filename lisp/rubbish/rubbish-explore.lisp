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
  (loop for m in mm  with vs = nil do 
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
  (loop for s in m1 with ss = nil do
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

(defparameter *checked-sigma* ())

(defun checkit (v) (push v *checked-sigma*))

(defun ischecked (v) (member v *checked-sigma* :test 'equal))

(defun clearchecked () (setq *checked-sigma* ()))

;; gather vars in a term
(defun vsinterm (tm)
  (if (atom tm) 
    (if (isconst tm) nil (list tm))
    (vsinterm* (cdr tm))
  )
)

(defun vsinterm* (tm*)
  (loop for tm in tm* append
    (vsinterm tm)
  )
)

;; 
(defun vartrace* (v* m1 )
  "get sigmas from v* in m1"
  (loop for v in v* unless (isconst v) collect
    (vartrace v m1 )
  )
)

(defun vartrace (v m1)
  "get sigmas from v in m1"
  (let (knownvs ssp ss s1 s0 s trace atrace)
    (setq ssp (list v))
    (loop while ssp do
      (setq s0 (pop ssp))

      (format t "at loop s0=~a~%" s0)

      (loop while (member s0 *checked-sigma* :test 'equal) 
        do (setq s0 (pop ssp)))

      (format t "after loop s0=~a~%" s0)

      (setq ss (find-sigma s0 m1))
      (push s0 *checked-sigma*)

      (setq ssp (append ssp ss))

      (loop for  s in ss with nextss = nil do
        (setq nextss (vartrace* (vsinterm* (cdr s)) m1))
        (setq ssp (append nextss ssp))
        (push s *checked-sigma*)
      )
    )
    (remove-nil *checked-sigma*)
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
;(defparameter mm (mguofΣ))
;(print-mm mm)
;
;(defparameter m1 (break-mgu* mm))
;(print-mm m1)
;
;;(defparameter vs (allvars mm))
;
;(trace-vars 'z.157 mm)


