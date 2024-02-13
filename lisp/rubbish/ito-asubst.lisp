;; ito of asubst
(myload "ito.lisp")

(load "play-newsubst.lisp")


(defito ito-asubst ()
  "aasubst is subst with assoclist"
  (intend-equal "miss var" 'b (asubst 'b '((x . a))))
  (intend-equal "hit var" 'a (asubst 'x '((x . a)))) 
  (intend-equal "miss var 2compo" 'z (asubst 'z '((y . b)(x . a)))) 
  (intend-equal "hit var 2compo" 'a (asubst 'x '((y . b)(x . a)))) 
  (intend-equal "miss in form" '(f x y) (asubst '(f x y) '((xx . a)(xy . b)(xz . c)))) 
  (intend-equal "miss in form" '(f a b w) (asubst '(f x y w) '((x . a)(y . b)(z . c))))
)


(ito-asubst)

