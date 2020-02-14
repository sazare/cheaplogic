(load "test.lisp")

(test-set
	 "about plus"
	 (test-equal "three1" 3 (+ 1 2 ) )
	 (test-equal "three2" 3 (- 4 1 ) )
	 (test-notequal "four" 9 (+ 2 2 ) )
	 (test-notequal "five" 9 (+ 4 2 ) )
	 )
(test-set
	 "about multi"
	 (test-equal "four"  4 (* 2 2) )
	 (test-notequal "two"   2 (* 1 1) )
	 )
(test-set
	 "about car"
	 (test-equal "car is abc1" 'abc (car '(abc)))
	 (test-notequal "car is abc2" 'bbb (car (list 'abc 1 2)))
	 (test-notequal "car is abc3" 'abc (car '(aaa abc abc)))
	 )

(deftest test-a ()
	 "about plus"
	 (test-equal "three1" 3 (+ 1 2 ) )
	 (test-equal "three2" 3 (- 4 1 ) )
	 (test-notequal "four" 9 (+ 2 2 ) )
	 (test-notequal "five" 9 (+ 4 2 ) )
	 )
(deftest test-b ()
	 "about multi"
	 (test-equal "four"  4 (* 2 2) )
	 (test-notequal "two"   2 (* 1 1) )
	 )
(deftest test-car (x) ;; how this parameter is used?
	 "about car"
	 (test-equal "car is abc1" 'abc (car x))
	 (test-notequal "car is abc2" 'bbb (car x))
	 (test-equal "car is abc3" 'abc (car x))
	 )

(deftest test-all ()
	 (test-set "test of deftest macros"
	   (test-a)
	   (test-b)
	   (test-car '(abc ss))
	   ))

(test-all)

