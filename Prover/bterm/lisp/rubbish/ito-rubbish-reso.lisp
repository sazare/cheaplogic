;; resolution over unif-disag.lisp

(myload "ito.lisp")
(load "load-rubbish-unif.lisp")
(load "load-rubbish-reso.lisp")

(format t "~%ito-reso-disag.lisp in progress ~%")


(defparameter *sunification* #'unificationsp)
(defparameter *ssubst*  #'substp)
(defparameter *ssubsub* #'subsubp)

;(defparameter *sunification* #'unifications)
;(defparameter *ssubst*  #'substs)
;(defparameter *ssubsub* #'subsubs)

  (defparameter ovs '(x y))
  (defparameter nvs (prenameof ovs))

(defito ito-resolve ()
  "resolve : (v1 l1 c1') x (v2 l2 c2') -> r1 where c1=l1+c1', c2=l2+c2' "

;; fail
  (intend-equal "resolve fail psym mismatch" () (resolve '() '(- P a) '((+ R a)) '() '(+ S a) '((- Q a))))
  (intend-equal "resolve fail unify fail" () (resolve '() '(- P a) '((+ R a)) '() '(+ P b) '((- Q a))))

;; success
  (intend-equal "success resolve unit clauses make []" '(() ()) (resolve '() '(- P a) '() '() '(+ P a) '()))
  (intend-equal "resolve simple clauses" '(() ((+ R a)(- Q a))) (resolve '() '(- P a) '((+ R a)) '() '(+ P a) '((- Q a))))
)


(defito ito-prenameof ()
  "rename is a substition as vs<-vs, is defined as a new vars list. p-not specific"

  (intend-equal "number of vars are same" (length ovs) (length nvs))
  (intend-equal "root of names are same" (basesof ovs) (basesof nvs)) 
  (intend-equal "length of names are +4" (+ (length (symbol-name (car ovs))) 3) (length (symbol-name (car nvs))))
)

(defito ito-disjoinfy ()
 "isolate vars of resolvent"


)


(defito ito-all-resolve ()
 "tests for rubbish-reso"

 
 (ito-resolve)
)

(ito-all-resolve)
