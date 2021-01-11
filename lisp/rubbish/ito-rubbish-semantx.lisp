(load "load-rubbish.lisp")
(load "rubbish-prover-gtrail.lisp")
(load "rubbish-peval.lisp")
(load "rubbish-semantx.lisp")

(myload "ito.lisp")

(format t "~%ito-rubbish-semantx.lisp in progress ~%")



(defito ito-peval-id ()
  "REMOVE NON VAR FROM VARS*SIG"
(defparameter a1 (readskqc "((1 () (+ A a)) (2 () (+ = 1 1)) (3 () (- = 1 1)) (4 () (+ = 1 2)) (5 () (- = 1 2)))"))
  (intend-equal "" '(A a) (peval-id 'L1-1))
  (intend-equal "" 'T (peval-id 'L2-1))
  (intend-equal "" 'nil (peval-id 'L3-1))
  (intend-equal "" nil (peval-id 'L4-1))
  (intend-equal "" 'T (peval-id 'L5-1))
)

(defito ito-apply-semantx ()
  "3 TYPES OF CLAUSE TRANS." 
  (defparameter a2 (readskqc 
    "((10 (x) (+ B x)(- C a)(+ A x))
      (11 (x y) (- = 1 1)(+ = 2 1)(- B x y)(+ A x)) 
      (12 () (- = 1 1) (+ = 2 1) (+ A 1 2) (+ = 1 2))
      (13 () (- P 1 1) (+ Q 1 5) (- = 1 2) (- R 2 2))
      (14 (x y) (+ P x) (- Q y 1) (- R x y) (+ = 1 1))
      (15 (x y) (+ P x)(- = 1 2)(- R x y) (- = 3 2))
      (16 (x y) (+ P x)(- = 1 2)(- R x y) (+ = 3 2)))"))
  (intend-equal "LLLL" (list () () (bodyof 'c10)) (apply-semantx 'C10))
  (intend-equal "FFLL" '(()(L11-1 L11-2)(L11-3 L11-4)) (apply-semantx 'C11))
  (intend-equal "FFLF" '(()(L12-1 L12-2 L12-4)(L12-3)) (apply-semantx 'C12))
  (intend-equal "LLTL" '((L13-3)()(L13-1 L13-2 L13-4)) (apply-semantx 'C13))
  (intend-equal "LLLT" '((L14-4)()(L14-1 L14-2 L14-3)) (apply-semantx 'C14))
  (intend-equal "LTLT" '((L15-2 L15-4)()(L15-1 L15-3)) (apply-semantx 'C15))
  (intend-equal "LTLF" '((L16-2)(L16-4)(L16-1 L16-3)) (apply-semantx 'C16))
)

(defito ito-all-semantx ()
 "TESTS FOR RUBBISH-SEMANTX"
 (ito-peval-id)
 (ito-apply-semantx)
)

(ito-all-semantx)

