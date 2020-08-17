; rubbish-reso.lisp
;  old name: reso-disag.lisp
;; resolution on c1 with c2 over disag-functions unification and subsub

;; user of this module, define the followin variables
;(defparameter *sunification* #'unificationsp)
;(defparameter *ssubst*  #'substp)
;(defparameter *ssubsub* #'subsubp)

(defun funification (vs e1 e2) (funcall *sunification* vs e1 e2))
(defun fsubst (vs ex es) (funcall *ssubst* vs ex es))
(defun fsubsub (vs e1 e2) (funcall *ssubsub* vs e1 e2))


;; resolve - precondition: 
;; 1) Disjoined Variables Condition
;; 2) c1 = l1 v rem1, c2 = l1 v rem2
;; 3) vs1 = V(c1), vs2 = V(c2)
; 1. make vs = vs1 v vs2
; 2. s = vs.<lit(l1):lit(l2)> where lit(+/- p . args) = (p . args)
;    or :FAIL
; 3. r = nvs.(rvs.(rem1 v rem2)*s)*m ; when p-not, because *s'vars  differ *m vars
;    then fsubst is meaningless??
; 4 (s r) or () for fail

;; (+/- P . args) => (P . args) ... remove sign
(defun atomicof (lit) 
 (cdr lit)
)

(defun shrinkvs (vs sig)
  (delete-duplicates 
    (loop for v in vs 
          as s in sig 
      when (isvar vs s) collect s
    )
  )
)

;; resolve 2 clauses
(defun resolve (vs1 l1 rem1 vs2 l2 rem2)
  (let* ((vs (append vs1 vs2))
         (a1 (atomicof l1))
         (a2 (atomicof l2))
         (sig (funification vs a1 a2)))
   (cond 
     ((eq sig :NO) ':FAIL)
     (t (list (shrinkvs vs sig) (subsubp vs (append rem1 rem2) sig)))
   )
  )
)


;; isolate makes variables of the clause new
; 1. rvs = newvars(vs, s) ;; remove term from vs*s to cvs(must vars) and nvs(new vars)
;    nvs are didn't appear in c1,c2, and any other literals(for VDC)
; 2. sigma*rename is just subsubp.

;; isolate vars 
(defun isolatevs (vs c1)
;  ns.(vs.c1@nvs)
  (let ((ns (prenameof vs)))
    (list ns (subsubp vs c1 ns))
  )
)

;;; the following are resolv ??

;; basevar : var.1234.1222 => var
(defun basevar (v)
 (subseq (symbol-name v) 0 (position #\. (symbol-name v)))
)

;; basesof : vs => bvs s.t. base of each vars
(defun basesof (vs)
 (loop for v in vs
   collect (basevar v)
 )
)

;; newvar : v -> v.nnn
(defun newvar (v)
 (gensym (format nil "~a." (basevar v)))
)

;; for rename : vs <- nvs s.t. new vars of v in vs : p-not
; vs.nvs is the binding form

(defun prenameof (vs) 
 (loop for v in vs collect (newvar v))
)

