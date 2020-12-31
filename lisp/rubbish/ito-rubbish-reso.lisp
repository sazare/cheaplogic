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
(defparameter nvs (newvars ovs))

(defito ito-shrinkvs ()
  "remove non var from vars*sig"
  (intend-equal "shrinkvs remove const" '(x z) (shrinkvs '(x y z) '(x a z)))
  (intend-equal "shrinkvs remove f-term" '(z) (shrinkvs '(x y z) '(z (f z) z)))
)

(defito ito-resolve ()
  "resolve : (v1 l1 c1') x (v2 l2 c2') -> r1 where c1=l1+c1', c2=l2+c2' with DVC"

;; fail
  (intend-equal "resolve fail psym mismatch" :FAIL (resolve '() '(- P a) '((+ R a)) '() '(+ S a) '((- Q a))))
  (intend-equal "resolve fail unify fail" :FAIL (resolve '() '(- P a) '((+ R a)) '() '(+ P b) '((- Q a))))

;; success
;; (()()) is (sigma [])
  (intend-equal "resolved to []" '(() ()) (resolve '() '(- P a) '() '() '(+ P a) '()))
  (intend-equal "resolve simple clauses" '(() ((+ R a)(- Q a))) (resolve '() '(- P a) '((+ R a)) '() '(+ P a) '((- Q a))))
  (intend-equal "resolved to []" '(() ()) (resolve '(x) '(- P x) '() '() '(+ P a) '()))
  (intend-equal "resolved to []" '((y) ()) (resolve '(x) '(- P x) '() '(y) '(+ P y) '()))

  ;; resolvent is multi-lits
  (intend-equal "resolved to Li"  '((y) ((+ Q y)(- R y))) (resolve '(x) '(- P x) '((+ Q x)) 
                                                                     '(y) '(+ P y) '((- R y))))
  (intend-equal "resolved remove by v to v" '((y w) ((+ Q (g w w))(- S w (h w))(+ R (f y w)))) 
                                      (resolve 
					'(x z) '(- P (f x) z) '((+ Q (g x z))(- S x (h z)))
					'(y w) '(+ P (f w) w) '((+ R (f y w)))))
  (intend-equal "resolved remove by fn to v" '((z y) ((+ Q (g a z))(- S a (h z))(+ R (f y a)))) 
                                      (resolve 
					'(x z) '(- P (f a) x) '((+ Q (g x z))(- S x (h z)))
					'(y w) '(+ P (f w) w) '((+ R (f y w)))))
)


(defito ito-isolatevs ()
 "isolate vars of resolvent"
  
  (setf nc (isolatevs '(x y) '((+ P (f x) (g y))(- Q x (h x y)))))
  (intend-equal "rename vs with new vs" 
     		'((+ P (f x)(g y))(- Q x (h x y))) 
                (subsubp (car nc) (cadr nc) '(x y)))
)
;

(defito ito-all-resolve ()
 "TESTS FOR RUBBISH-RESO"
 (ito-shrinkvs) 
 (ito-resolve)
 (ito-vrootof)
 (ito-isolatevs)
)

(ito-all-resolve)
