; ito for rubbish-random.lisp

(myload "ito.lisp")
(load "rubbish-random.lisp")

(defito ito-shuffle ()
  "change rundom order"
  (defvar v1 '(1 2 3 4 5 6))
  (defvar s1 (random-sort v1))
  (intend-equal "same length" (length v1)  (length s1))
  (intend-equal "same elements" v1  (sort s1 '<))
)

(defito ito-random ()
 "TESTS FOR RUBBISH-RESO"
 (ito-shuffle)
)

(ito-random)


  
