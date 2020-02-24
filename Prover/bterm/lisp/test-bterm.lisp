;; test for binding expression

(load "test.lisp")
(load "bterm.lisp")

;; vars '(x y) is appropriate?

(deftest test-uniq-push ()
  "test for uniq-push"
  (expect-equal "nothing in both" '() (uniq-push '() '()))
  (expect-equal "nothing in blist" '(a) (uniq-push '(a) '()))
  (expect-equal "nothing in alist" '(a) (uniq-push '() '(a)))
  (expect-equal "something in both" '(a b) (uniq-push '(a) '(b)))
  (expect-equal "keeping order1" '(a b c) (uniq-push '(a b) '(b c)))
  (expect-equal "keeping order2" '(a b c) (uniq-push '(a b) '(c b)))
)

(deftest test-binding-of ()
	"binding-of"
	(expect-equal "binding of symbol is NIL" '(x) (binding-of '(x y) 'x))
	(expect-equal "binding of symbol is NIL" NIL (binding-of '(x y) 'a))

	(expect-equal "binding of (b . e) is b" '(x)  (binding-of '(x y) '((x) . (f x))))
	(expect-equal "binding of (b . e) is b" '(x y)  (binding-of '(x y) '((x y) . (f (h x y)))))

	(expect-equal "no binding if no variables in depth" '()  (binding-of '(x y) '(f (h a b))))
	(expect-equal "a binding with no binding and in depth" '(x)  (binding-of '(x y) '(f (h x))))

	(expect-equal "vars in scatterd positions1" '(x y)  (binding-of '(x y) '(f (g x) (h y))))
	(expect-equal "preserve the order in bterm" '(y x)  (binding-of '(x y) '(f (g y) (h x))))
	(expect-equal "vars in scatterd positions3" '(x y)  (binding-of '(x y) '(f x (h x y))))
)


(test-uniq-push)
(test-binding-of)

