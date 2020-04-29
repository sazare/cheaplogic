(load "ito.lisp")

(ito-set 
	 "about intend true or false"
	(intend-t "true" (eq 'a 'a))
	(intend-f "false" (eq 'a 'b))
) 

(ito-set
	"about order of number integer"
	(intend-> ">" 4 3)
	(intend->= ">=" 4 3)
	(intend->= ">=" 4 4)
	(intend-< "<" 2 3)
	(intend-<= "<=" 2 3)
	(intend-<= "<=" 3 3)
	(intend-= "=" 13 13)
)
(ito-set
	"about order of number float"
	(intend-> ">" 4.0 3.9)
	(intend->= ">=" 33.2 33.2)
	(intend->= ">=" 4.5 4.5)
	(intend-< "<" 2.99 3.0)
	(intend-<= "<=" 3.0 5.2)
	(intend-<= "<=" 3.0 3.0)
	(intend-<= "=" 3.0 3.0)
)

(ito-set
	 "about plus"
	 (intend-equal "three1" 3 (+ 1 2 ) )
	 (intend-equal "three2" 3 (- 4 1 ) )
	 (intend-notequal "four" 9 (+ 2 2 ) )
	 (intend-notequal "five" 9 (+ 4 2 ) )
	 )
(ito-set
	 "about multi"
	 (intend-equal "four"  4 (* 2 2) )
	 (intend-notequal "two"   2 (* 1 1) )
	 )
(ito-set
	 "about car"
	 (intend-equal "car is abc1" 'abc (car '(abc)))
	 (intend-notequal "car is abc2" 'bbb (car (list 'abc 1 2)))
	 (intend-notequal "car is abc3" 'abc (car '(aaa abc abc)))
	 )


;;; sample ito

(defito ito-a ()
	 "about plus"
	 (intend-equal "three1" 3 (+ 1 2 ) )
	 (intend-equal "three2" 3 (- 4 1 ) )
	 (intend-notequal "four" 9 (+ 2 2 ) )
	 (intend-notequal "five" 9 (+ 4 2 ) )
	 )

(defito ito-b ()
	 "about multi"
	 (intend-equal "four"  4 (* 2 2) )
	 (intend-notequal "two"   2 (* 1 1) )
	 )

(defito ito-car (x) ;; how this parameter is used?
	 "about car"
	 (intend-equal "car is abc1" 'abc (car x))
	 (intend-notequal "car is abc2" 'bbb (car x))
	 (intend-equal "car is abc3" 'abc (car x))
	 )

(defito ito-all ()
	 (ito-set "ito of defito macros"
	   (ito-a)
	   (ito-b)
	   (ito-car '(abc ss))
	   ))

(ito-all)


