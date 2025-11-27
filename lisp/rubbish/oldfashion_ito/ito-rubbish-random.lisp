; ito for rubbish-random.lisp

(myload "ito.lisp")
(load "rubbish-random.lisp")

(defito ito-remove-nth ()
  "ito for remove-nth"

  (intend-equal "0th" '(1 2) (remove-nth '(0 1 2) 0))
  (intend-equal "1st" '(0 2) (remove-nth '(0 1 2) 1))
  (intend-equal "2nd" '(0 1) (remove-nth '(0 1 2) 2))
)

(defito ito-separate ()
  "separate list to e and rem"
  (defvar x 0)
  (defvar y 0)
  (multiple-value-setq (x y) (separate 0 '(1 2 3)))
  (intend-equal "0th-1" 1 x)
  (intend-equal "0th-1" '(2 3) y)

  (multiple-value-setq (x y) (separate 1 '(1 2 3)))
  (intend-equal "1st-1" 2 x)
  (intend-equal "1st-1" '(1 3) y)

  (multiple-value-setq (x y) (separate 2 '(1 2 3)))
  (intend-equal "2nd-1" 3 x)
  (intend-equal "2nd-1" '(1 2) y)

)

(defito ito-shuffle ()
  "change rundom order"
  (defvar v1 '(1 2 3 4 5 6))
  (defvar s1 (random-sort v1))
  (intend-equal "same length" (length v1)  (length s1))
  (intend-equal "same elements" v1  (sort s1 '<))
)

(defito ito-random ()
 "TESTS FOR RUBBISH-RESO"
  (ito-remove-nth)
  (ito-separate)
  (ito-shuffle)
)

(ito-random)


  
