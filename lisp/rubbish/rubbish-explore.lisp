;; rubbish-expore.lisp

(in-package :rubbish)

;; expore is an attempt to a prover.

(defun make-pair-lids ()
  (loop for p in (make-psymlist *llist*)
    collect 
      (list p (eval (ptolsym '+ p)) (eval  (ptolsym '- p)))
  )
)

(defun varsofthem (lid1 lid2)
  (append (varsof (cidof lid1)) (varsof (cidof lid2)))
)

(defun unify-pair (lid1 lid2)
  (let ((vars (varsofthem lid1 lid2)) mgu)
    (setq mgu (unificationp vars (cdr (eval lid1)) (cdr (eval lid2))))
    (if (eq mgu :no)
      (format t "nomgu: ~a.~a:~a~%" vars (eval lid1) (eval lid2))
      (unless (eq mgu :no) (list vars  mgu))
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

(defun mguofΣ (&optional (eraze-empty t))
  (let (up) 
    (loop for plsls in (make-pair-lids) append
      (loop for ll in (combi (cadr plsls) (caddr plsls))
        append
          (when (setq up (unify-pair (car ll)(cadr ll))) 
            (list 
              (list (append 
                      (list (car plsls) ll) 
                      (list (varsofthem (car ll)(cadr ll))))
                    (if eraze-empty (remove-empty up) up )
              )
           )
         )
      )
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
 
; break-mgu* removes vars of mgu.  
(defun break-mgu* (mm)
  (loop for m in mm append
    (break-mgu (cadr m))
  )
)

;;
(defun print-mm (mm)
  (loop for x in mm do (format t "~a ~a~%" (car x)(cadr x)))
)


(defun isconst(sym)
  (and (atom sym) (or (numberp sym) (string-equal sym (vrootof sym))))
)

(defun isvarsyntax (sym)
  (and (atom sym) (not (isconst sym)))
)

(defun remove-nil (ls)
  (loop for e in ls when e collect e)
)

;; *v-tree*
(defparameter *v-tree* ())
(defun check-in-tree (v) (unless (member v *v-tree*) (push v *v-tree*)))
(defun ischecked (v) (member v *v-tree* :test 'equal))
(defun clear-checked () (setq *v-tree* ()))


;; *σ-graph*
(defparameter *σ-graph* nil)
(defun clear-graph () (setq *σ-graph* nil))
(defun remove-in-graph (s) 
  (let ()
    (setq *σ-graph*  (remove s *σ-graph* :test 'equal) )
    s
  )
)

;; gather vars in a term
(defun vsinterm (ft)
  (if (atom ft) 
    (if (isconst ft) nil (list ft))
    (vsinterm* (cdr ft))
  )
)

(defun vsinterm* (ft*)
  (loop for ft in ft* append
    (vsinterm ft)
  )
)

;; 
(defun v*track (v*)
  (loop for v in v* unless (isconst v) append (vtrack v))
)

(defun vtrack (v)
  (let (s*)
    (setq s* (loop for x in *σ-graph* when (equal v (car x)) collect x))
    (if s*
      (s*track s*)
      (loop for x in *σ-graph* when (and (isvarsyntax (cadr x)) (equal v (cadr x))) do 
        (check-in-tree (list (cadr x)(car x)))
        (remove-in-graph x)
        (vtrack (car x))))
  )
)

(defun s*track (s*)
  (let (res rs)
    (loop for s in s* append 
      (loop for m in *σ-graph* do
        (cond
          ((equal s m)
            (check-in-tree s)
            (remove-in-graph s)
            (setq res (append (strack s ) res)))
          ((and (not (listp (cadr s))) (isvarsyntax (cadr s)))
            (setq rs (list (cadr s) (car s)))
            (check-in-tree rs)
            (remove-in-graph s)
            (setq res (append (strack rs) res)))
          (t rs)
        )
      )
    )
    rs
  )
)

(defun strack(s)
  (let (ss sv*)
    (setq sv* (ftrack (cadr s)))
    (remove-in-graph s)
    (vtrack (car s))
  )
)

(defun ftrack(ft)  
  (if (atom ft)
    (vtrack ft)
    (v*track (cdr ft))
  )
)
  
(defparameter mm nil)
(defparameter m1 nil)

(defun trackvars (v*)
  (let ()
    (clear-graph)
    (clear-checked)

    (setq  mm (mguofΣ))
    (setq  m1 (break-mgu* mm))
    (setq *σ-graph* m1)

    (v*track v*) ; let reduce *σ-graph*, update mm

    (uniq *v-tree*)
  )
)



;; do
;(defparameter mm (mguofΣ))
;(print-mm mm)
;(defparameter m1 (break-mgu* mm))
;(print-mm m1)
;
;;(defparameter vs (allvars mm))
;
;(vtrack 'z.157 m1)

