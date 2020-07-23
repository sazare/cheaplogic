(myload "ito.lisp")

;; refer to Practical Common Lisp Ch 21 

(defito ito-symbol ()
  "symbol specifiction in COMMONLISP"
  (ito-set "symbol is a atom?" T (eql ':foo :foo))
  (ito-set "atom is a symbol" T (eql ':foo 'foo))
  (ito-set "#: means uninterned sybol" NIL (eql '#:foo '#:foo))


  (ito-set "what is symbol-name" "FOO" (symbol-name :ff))
)
;; no return from (let ((a (gensym))(b (gensym)) (list a b)) 


(ito-symbol)

