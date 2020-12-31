;; ito-rubbish-peval.lisp
;;; 
(myload "ito.lisp") ; for general ito
;(load "ito-rubbish-tools.lisp") ; for rubbish, contains ito.lisp

; load file be tested
(load "rubbish-peval.lisp")

(defito ito-peval-on-ground ()
  "peval of ground term"
  (intend-equal "symbolic constants are not evaluated" '(f a) (peval '(f a)))
  (intend-equal "symbolic constants are not evaluated" '(+ 2 a) (peval '(+ 2 a)))
  (intend-equal "symbolic constants are not evaluated" '(+ a 2) (peval '(+ a 2)))

  (intend-t "symbolic constants are not evaluated" (peval '(= 4 (+ 2 2))))
  (intend-t "symbolic constants are not evaluated" (peval '(= 0 (- 4 4))))
  (intend-t "symbolic constants are not evaluated" (peval '(= 0 0 )))
  (intend-t "symbolic constants are not evaluated" (peval '(= 2.5 2.5)))
  (intend-t "symbolic constants are not evaluated" (peval '(= 2.5 (+ 1.5 1))))
  (intend-f "symbolic constants are not evaluated" (peval '(= 4 2)))
  (intend-f "symbolic constants are not evaluated" (peval '(= 4.4 4.41)))
  (intend-f "symbolic constants are not evaluated" (peval '(= (+ 4.01 0.4) 4.41)))
  (intend-t "symbolic constants are not evaluated" (peval '(string= "abc" "abc")))
  (intend-f "symbolic constants are not evaluated" (peval '(string= "abc" "abcd")))
  (intend-t "symbolic constants are not evaluated" (peval '(string/= "abc" "abcd")))
  (intend-f "symbolic constants are not evaluated" (peval '(string/= "abc" "abc")))
)

(defito ito-peval-on-notground ()
  "peval of non ground term"
  (intend-equal "var is var" 'x        (peval 'x))
  (intend-equal "var in arg" '(f a x)  (peval '(f a x)))
  (intend-equal "var in deep" '(f (g a)(h x)) (peval '(f (g a) (h x))))
  (intend-equal "var in arg2" '(f x a) (peval '(f x a)))
  (intend-equal "var in more deep" '(f (g (h b x)) a) (peval '(f (g (h b x)) a)))
)

;;
(defito ito-all-partialeval() ;;; my style 
  "TEST FOR ALL TEST"
  (ito-peval-on-ground)
  (ito-peval-on-notground)
)

(ito-all-partialeval)

