;; ito of asubst

(load "play-newsubst.lisp")


(ito:defito ito-asubst ()
  "aasubst is subst with assoclist"
  (ito:intend-equal "miss var" 'b (asubst 'b '((x . a))))
  (ito:intend-equal "hit var" 'a (asubst 'x '((x . a)))) 
  (ito:intend-equal "miss var 2compo" 'z (asubst 'z '((y . b)(x . a)))) 
  (ito:intend-equal "hit var 2compo" 'a (asubst 'x '((y . b)(x . a)))) 
  (ito:intend-equal "miss in form" '(f x y) (asubst '(f x y) '((xx . a)(xy . b)(xz . c)))) 
  (ito:intend-equal "miss in form" '(f a b w) (asubst '(f x y w) '((x . a)(y . b)(z . c))))
)


(ito-asubst)

