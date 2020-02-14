(load "test.lisp")

(deftest test-a ()
	 "about plus"
	 (test "three1" 3 (+ 1 2 ) )
	 (test "three2" 3 (- 4 1 ) )
	 (test "four" 4 (+ 2 2 ) )
	 (test "five" 6 (+ 4 2 ) )
	 )
(deftest test-b ()
	 "about multi"
	 (test "four" 4 (* 2 2) )
	 (test "two"  1 (* 1 1) )
	 )
(deftest test-car (x)
	 "about car"
	 (test "car is abc" 'abc (car x))
	 )

(deftest test-all ()
	 (test-set  "testset"
	   (test-a)
	   (test-b)
	   (test-car '(abc ss))
	   )
	 )

(test-all)


