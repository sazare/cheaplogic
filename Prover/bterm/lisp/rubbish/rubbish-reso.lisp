; reso-disag.lisp
;; resolution on c1 with c2 over disag-functions unification and subsub

;; user of this module, define the followin variables
;(defparameter *sunification* #'unificationsp)
;(defparameter *ssubst*  #'substp)
;(defparameter *ssubsub* #'subsubp)

(defun funification (vs e1 e2) (funcall *sunification* vs e1 e2))
(defun fsubst (vs ex es) (funcall *ssubst* vs ex es))
(defun fsubsub (vs e1 e2) (funcall *ssubsub* vs e1 e2))


;; resolve - precondition: 
;; 1) Variable Disjoint Condition
;; 2) c1 = l1 v rem1, c2 = l1 v rem2
;; 3) vs1 = V(c1), vs2 = V(c2)
; 1. make vs = vs1 v vs2
; 2. s = vs.<lit(l1):lit(l2)> where lit(+/- p . args) = (p . args)
; 3. rvs = newvars(vs, s) ;; remove term from vs*s to cvs(must vars) and nvs(new vars)
;    nvs are didn't appear in c1,c2, and any other literals(for VDC)
; 4. r = nvs.(rvs.(rem1 v rem2)*s)*m ; when p-not, because *s'vars  differ *m vars
;    then fsubst is meaningless??
;;   

(defun atomicof (lit) 
 (cdr lit)
)

(defun resolve (vs1 l1 rem1 vs2 l2 rem2)
  (let* ((vs (append vs1 vs2))
         (a1 (atomicof l1))
         (a2 (atomicof l2))
         (sig (funification (append (atomicof vs1) (atomicof vs2)) a1 a2)))
   (cond 
     ((null sig) '())
     (t (list vs (append rem1 rem2)))
   )
  )
)


