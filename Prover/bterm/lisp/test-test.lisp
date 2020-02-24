(load "test.lisp")

(test-set 
	 "about expect true or false"
	(expect-t "true" (eq 'a 'a))
	(expect-f "false" (eq 'a 'b))
) 

(test-set
	"about order of number integer"
	(expect-> ">" 4 3)
	(expect->= ">=" 4 3)
	(expect->= ">=" 4 4)
	(expect-< "<" 2 3)
	(expect-<= "<=" 2 3)
	(expect-<= "<=" 3 3)
	(expect-= "=" 13 13)
)
(test-set
	"about order of number float"
	(expect-> ">" 4.0 3.9)
	(expect->= ">=" 33.2 33.2)
	(expect->= ">=" 4.5 4.5)
	(expect-< "<" 2.99 3.0)
	(expect-<= "<=" 3.0 5.2)
	(expect-<= "<=" 3.0 3.0)
	(expect-<= "=" 3.0 3.0)
)

(test-set
	 "about plus"
	 (expect-equal "three1" 3 (+ 1 2 ) )
	 (expect-equal "three2" 3 (- 4 1 ) )
	 (expect-notequal "four" 9 (+ 2 2 ) )
	 (expect-notequal "five" 9 (+ 4 2 ) )
	 )
(test-set
	 "about multi"
	 (expect-equal "four"  4 (* 2 2) )
	 (expect-notequal "two"   2 (* 1 1) )
	 )
(test-set
	 "about car"
	 (expect-equal "car is abc1" 'abc (car '(abc)))
	 (expect-notequal "car is abc2" 'bbb (car (list 'abc 1 2)))
	 (expect-notequal "car is abc3" 'abc (car '(aaa abc abc)))
	 )

(deftest test-a ()
	 "about plus"
	 (expect-equal "three1" 3 (+ 1 2 ) )
	 (expect-equal "three2" 3 (- 4 1 ) )
	 (expect-notequal "four" 9 (+ 2 2 ) )
	 (expect-notequal "five" 9 (+ 4 2 ) )
	 )
(deftest test-b ()
	 "about multi"
	 (expect-equal "four"  4 (* 2 2) )
	 (expect-notequal "two"   2 (* 1 1) )
	 )
(deftest test-car (x) ;; how this parameter is used?
	 "about car"
	 (expect-equal "car is abc1" 'abc (car x))
	 (expect-notequal "car is abc2" 'bbb (car x))
	 (expect-equal "car is abc3" 'abc (car x))
	 )

(deftest test-all ()
	 (test-set "test of deftest macros"
	   (test-a)
	   (test-b)
	   (test-car '(abc ss))
	   ))

(test-all)

