(load "test.lisp")

;; refer to Practical Common Lisp Ch 21 

(deftest test-symbol ()
  "symbol specifiction in COMMONLISP"
  (test-set "symbol is a atom?" T (eql ':foo :foo))
  (test-set "atom is a symbol" T (eql ':foo 'foo))
  (test-set "#: means uninterned sybol" NIL (eql '#:foo '#:foo))


  (test-set "what is symbol-name" "FOO" (symbol-name :ff))
)
;; no return from (let ((a (gensym))(b (gensym)) (list a b)) 


(test-symbol)

