;; resolution over unif-disag.lisp

(myload "ito.lisp")
(load "load-rubbish-unif.lisp")
(load "load-rubbish-reso.lisp")

(format t "~%ito-reso-disag.lisp is NOT YET WRITTEN~%")


(defito ito-resolve ()
  "resolve : (v1 l1 c1') x (v2 l2 c2') -> r1 where c1=l1+c1', c2=l2+c2' "

(defparameter *sunification* #'unificationsp)
(defparameter *ssubst*  #'substp)
(defparameter *ssubsub* #'subsubp)

;(defparameter *sunification* #'unifications)
;(defparameter *ssubst*  #'substs)
;(defparameter *ssubsub* #'subsubs)

;; fail
  (intend-equal "resolve fail psym mismatch" () (resolve '() '(- P a) '((+ R a)) '() '(+ S a) '((- Q a))))
  (intend-equal "resolve fail unify fail" () (resolve '() '(- P a) '((+ R a)) '() '(+ P b) '((- Q a))))

;; success
  (intend-equal "resolve unit clauses" '(() ()) (resolve '() '(- P a) '() '() '(+ P a) '()))
  (intend-equal "resolve simple clauses" '(() ((+ R a)(- Q a))) (resolve '() '(- P a) '((+ R a)) '() '(+ P a) '((- Q a))))
)



(ito-resolve)

