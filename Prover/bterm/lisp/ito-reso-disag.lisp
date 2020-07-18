;; resolution over unif-disag.lisp

(load "ito.lisp")
(load "load-reso-disag.lisp")

(defito ito-resolve ()
  "resolve : c1 x c2 -> r1"
  (intend-eual "resolve unit clauses" () (resolve () ((+ P a)) () ((- P a)) 'L1 'L2 #'unifications #'substs)


