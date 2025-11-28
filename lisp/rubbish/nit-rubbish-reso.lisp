;; resolution over unif-disag.lisp

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
(defparameter nvs (newvars ovs))

(ito:defito ito-shrinkvs ()
  "remove non var from vars*sig"
  (ito:intend-equal "shrinkvs remove const" '(x z) (shrinkvs '(x y z) '(x a z)))
  (ito:intend-equal "shrinkvs remove f-term" '(z) (shrinkvs '(x y z) '(z (f z) z)))
)

(ito:defito ito-resolve ()
  "resolve : (v1 l1 c1') x (v2 l2 c2') -> r1 where c1=l1+c1', c2=l2+c2' with DVC"

;; fail
  (ito:intend-equal "resolve fail psym mismatch" :FAIL (resolve '() '(- P a) '((+ R a)) '() '(+ S a) '((- Q a))))
  (ito:intend-equal "resolve fail unify fail" :FAIL (resolve '() '(- P a) '((+ R a)) '() '(+ P b) '((- Q a))))

;; success
;; (()()) is (sigma [])
  (ito:intend-equal "resolved to []" '(() ()) (resolve '() '(- P a) '() '() '(+ P a) '()))
  (ito:intend-equal "resolve simple clauses" '(() ((+ R a)(- Q a))) (resolve '() '(- P a) '((+ R a)) '() '(+ P a) '((- Q a))))
  (ito:intend-equal "resolved to []" '(() ()) (resolve '(x) '(- P x) '() '() '(+ P a) '()))
  (ito:intend-equal "resolved to []" '((y) ()) (resolve '(x) '(- P x) '() '(y) '(+ P y) '()))

  ;; resolvent is multi-lits
  (ito:intend-equal "resolved to Li"  '((y) ((+ Q y)(- R y))) (resolve '(x) '(- P x) '((+ Q x)) 
                                                                     '(y) '(+ P y) '((- R y))))
  (ito:intend-equal "resolved remove by v to v" '((y w) ((+ Q (g w w))(- S w (h w))(+ R (f y w)))) 
                                      (resolve 
					'(x z) '(- P (f x) z) '((+ Q (g x z))(- S x (h z)))
					'(y w) '(+ P (f w) w) '((+ R (f y w)))))
  (ito:intend-equal "resolved remove by fn to v" '((z y) ((+ Q (g a z))(- S a (h z))(+ R (f y a)))) 
                                      (resolve 
					'(x z) '(- P (f a) x) '((+ Q (g x z))(- S x (h z)))
					'(y w) '(+ P (f w) w) '((+ R (f y w)))))
)


(ito:defito ito-isolatevs ()
 "isolate vars of resolvent"
  
  (setf nc (isolatevs '(x y) '((+ P (f x) (g y))(- Q x (h x y)))))
  (ito:intend-equal "rename vs with new vs" 
     		'((+ P (f x)(g y))(- Q x (h x y))) 
                (subsubp (car nc) (cadr nc) '(x y)))
)
;

(ito:defito ito-all-resolve ()
 "TESTS FOR RUBBISH-RESO"
 (ito-shrinkvs) 
 (ito-resolve)
 (ito-vrootof)
 (ito-isolatevs)
)

(ito-all-resolve)
