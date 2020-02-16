(load "test.lisp")

(deftest test-a ()
	 "about plus"
	 (expect-equal "three1" 3 (+ 1 2 ) )
	 (expect-equal "three2" 3 (- 4 1 ) )
	 (expect-equal "four" 4 (+ 2 2 ) )
	 (expect-equal "five" 6 (+ 4 2 ) )
	 )
(deftest test-b ()
	 "about multi"
	 (expect-equal "four" 4 (* 2 2) )
	 (expect-equal "two"  1 (* 1 1) )
	 )
(deftest test-car (x)
	 "about car"
	 (expect-equal "car is abc" 'abc (car x))
	 )

(deftest test-all ()
	 (test-set  "testset"
	   (test-a)
	   (test-b)
	   (test-car '(abc ss))
	   )
	 )

(test-all)


