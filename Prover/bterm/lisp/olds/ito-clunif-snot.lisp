; ito-clunif-snot.lisp

(myload "ito.lisp")

(load "clunif-snot.lisp")

(setf unifize2 (make-unifize '(x) '(f x) '(g y)))
(setf ds0 (funcall unifize2 :disagree '()))
(intend-equal "fail" 'NO ds0)

(setf unifize1 (make-unifize '(x) '(f x (g x) y (h x y)) '(f a (g a) b (h a b))))

(setf ds1 (funcall unifize1 :disagree '()))
(intend-equal "first ds" '(x . a) ds)

(setf ds2 (funcall unifize1 :disagree '(x . a)))
(intend-equal "second ds" '(y . b) ds2)


(setf ds3 (funcall unifize1 :disagree '(y . b)))
(intend-equal "mateched" '() ds3)


