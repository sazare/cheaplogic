;; ito-rubbish-peval.lisp
;;; 

; load file be tested
(load "rubbish-peval.lisp")

(defito ito-peval-on-ground ()
  "peval of ground term"
  (ito:intend-equal "symbolic constants are not evaluated" '(f a) (peval '(f a)))
  (ito:intend-equal "symbolic constants are not evaluated" '(+ 2 a) (peval '(+ 2 a)))
  (ito:intend-equal "symbolic constants are not evaluated" '(+ a 2) (peval '(+ a 2)))

  (ito:intend-t "symbolic constants are not evaluated" (peval '(= 4 (+ 2 2))))
  (ito:intend-t "symbolic constants are not evaluated" (peval '(= 0 (- 4 4))))
  (ito:intend-t "symbolic constants are not evaluated" (peval '(= 0 0 )))
  (ito:intend-t "symbolic constants are not evaluated" (peval '(= 2.5 2.5)))
  (ito:intend-t "symbolic constants are not evaluated" (peval '(= 2.5 (+ 1.5 1))))
  (ito:intend-f "symbolic constants are not evaluated" (peval '(= 4 2)))
  (ito:intend-f "symbolic constants are not evaluated" (peval '(= 4.4 4.41)))
  (ito:intend-f "symbolic constants are not evaluated" (peval '(= (+ 4.01 0.4) 4.41)))
  (ito:intend-t "symbolic constants are not evaluated" (peval '(string= "abc" "abc")))
  (ito:intend-f "symbolic constants are not evaluated" (peval '(string= "abc" "abcd")))
  (ito:intend-t "symbolic constants are not evaluated" (peval '(string/= "abc" "abcd")))
  (ito:intend-f "symbolic constants are not evaluated" (peval '(string/= "abc" "abc")))
)

(defito ito-peval-on-notground ()
  "peval of non ground term"
  (ito:intend-equal "var is var" 'x        (peval 'x))
  (ito:intend-equal "var in arg" '(f a x)  (peval '(f a x)))
  (ito:intend-equal "var in deep" '(f (g a)(h x)) (peval '(f (g a) (h x))))
  (ito:intend-equal "var in arg2" '(f x a) (peval '(f x a)))
  (ito:intend-equal "var in more deep" '(f (g (h b x)) a) (peval '(f (g (h b x)) a)))
)

;;
(defito ito-all-partialeval() ;;; my style 
  "TEST FOR ALL peval TEST"
  (ito-peval-on-ground)
  (ito-peval-on-notground)
)

(ito-all-partialeval)

