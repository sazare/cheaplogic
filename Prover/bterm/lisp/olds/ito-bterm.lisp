;; ito for binding expression

(myload "ito.lisp")
(load "bterm.lisp")

;; vars '(x y) is appropriate?

(defito ito-uniq-push ()
  "ito for uniq-push"
  (intend-equal "nothing in both" '() (uniq-push '() '()))
  (intend-equal "nothing in blist" '(a) (uniq-push '(a) '()))
  (intend-equal "nothing in alist" '(a) (uniq-push '() '(a)))
  (intend-equal "something in both" '(a b) (uniq-push '(a) '(b)))
  (intend-equal "keeping order1" '(a b c) (uniq-push '(a b) '(b c)))
  (intend-equal "keeping order2" '(a b c) (uniq-push '(a b) '(c b)))
)

(defito ito-binding-of ()
	"binding-of"
	(intend-equal "binding of symbol is NIL" '(x) (binding-of '(x y) 'x))
	(intend-equal "binding of symbol is NIL" NIL (binding-of '(x y) 'a))

	(intend-equal "binding of (b . e) is b" '(x)  (binding-of '(x y) '((x) . (f x))))
	(intend-equal "binding of (b . e) is b" '(x y)  (binding-of '(x y) '((x y) . (f (h x y)))))

	(intend-equal "no binding if no variables in depth" '()  (binding-of '(x y) '(f (h a b))))
	(intend-equal "a binding with no binding and in depth" '(x)  (binding-of '(x y) '(f (h x))))

	(intend-equal "vars in scatterd positions1" '(x y)  (binding-of '(x y) '(f (g x) (h y))))
	(intend-equal "preserve the order in bterm" '(y x)  (binding-of '(x y) '(f (g y) (h x))))
	(intend-equal "vars in scatterd positions3" '(x y)  (binding-of '(x y) '(f x (h x y))))
)


(ito-uniq-push)
(ito-binding-of)

