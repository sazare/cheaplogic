(load "ito.lisp")

(ito-set 
	 "about intent true or false"
	(intent-t "true" (eq 'a 'a))
	(intent-f "false" (eq 'a 'b))
) 

(ito-set
	"about order of number integer"
	(intent-> ">" 4 3)
	(intent->= ">=" 4 3)
	(intent->= ">=" 4 4)
	(intent-< "<" 2 3)
	(intent-<= "<=" 2 3)
	(intent-<= "<=" 3 3)
	(intent-= "=" 13 13)
)
(ito-set
	"about order of number float"
	(intent-> ">" 4.0 3.9)
	(intent->= ">=" 33.2 33.2)
	(intent->= ">=" 4.5 4.5)
	(intent-< "<" 2.99 3.0)
	(intent-<= "<=" 3.0 5.2)
	(intent-<= "<=" 3.0 3.0)
	(intent-<= "=" 3.0 3.0)
)

(ito-set
	 "about plus"
	 (intent-equal "three1" 3 (+ 1 2 ) )
	 (intent-equal "three2" 3 (- 4 1 ) )
	 (intent-notequal "four" 9 (+ 2 2 ) )
	 (intent-notequal "five" 9 (+ 4 2 ) )
	 )
(ito-set
	 "about multi"
	 (intent-equal "four"  4 (* 2 2) )
	 (intent-notequal "two"   2 (* 1 1) )
	 )
(ito-set
	 "about car"
	 (intent-equal "car is abc1" 'abc (car '(abc)))
	 (intent-notequal "car is abc2" 'bbb (car (list 'abc 1 2)))
	 (intent-notequal "car is abc3" 'abc (car '(aaa abc abc)))
	 )


;;; sample ito

(defito ito-a ()
	 "about plus"
	 (intent-equal "three1" 3 (+ 1 2 ) )
	 (intent-equal "three2" 3 (- 4 1 ) )
	 (intent-notequal "four" 9 (+ 2 2 ) )
	 (intent-notequal "five" 9 (+ 4 2 ) )
	 )

(defito ito-b ()
	 "about multi"
	 (intent-equal "four"  4 (* 2 2) )
	 (intent-notequal "two"   2 (* 1 1) )
	 )

(defito ito-car (x) ;; how this parameter is used?
	 "about car"
	 (intent-equal "car is abc1" 'abc (car x))
	 (intent-notequal "car is abc2" 'bbb (car x))
	 (intent-equal "car is abc3" 'abc (car x))
	 )

(defito ito-all ()
	 (ito-set "ito of defito macros"
	   (ito-a)
	   (ito-b)
	   (ito-car '(abc ss))
	   ))

(ito-all)


