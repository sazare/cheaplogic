; ito for rubbish-random.lisp

(load "rubbish-random.lisp")

(ito:defito ito-remove-nth ()
  "ito for remove-nth"

  (ito:intend-equal "0th" '(1 2) (remove-nth '(0 1 2) 0))
  (ito:intend-equal "1st" '(0 2) (remove-nth '(0 1 2) 1))
  (ito:intend-equal "2nd" '(0 1) (remove-nth '(0 1 2) 2))
)

(ito:defito ito-separate ()
  "separate list to e and rem"
  (defvar x 0)
  (defvar y 0)
  (multiple-value-setq (x y) (separate 0 '(1 2 3)))
  (ito:intend-equal "0th-1" 1 x)
  (ito:intend-equal "0th-1" '(2 3) y)

  (multiple-value-setq (x y) (separate 1 '(1 2 3)))
  (ito:intend-equal "1st-1" 2 x)
  (ito:intend-equal "1st-1" '(1 3) y)

  (multiple-value-setq (x y) (separate 2 '(1 2 3)))
  (ito:intend-equal "2nd-1" 3 x)
  (ito:intend-equal "2nd-1" '(1 2) y)

)

(ito:defito ito-shuffle ()
  "change rundom order"
  (defvar v1 '(1 2 3 4 5 6))
  (defvar s1 (random-sort v1))
  (ito:intend-equal "same length" (length v1)  (length s1))
  (ito:intend-equal "same elements" v1  (sort s1 '<))
)

(ito:defito ito-random ()
 "TESTS FOR RUBBISH-RESO"
  (ito-remove-nth)
  (ito-separate)
  (ito-shuffle)
)

(ito-random)


  
