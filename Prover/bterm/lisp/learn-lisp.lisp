;; Practical Commonlisp CD DB
(load "load-test.lisp")

(defvar *vvv* nil)
(defun add-me (me) (push me *vvv*))
(defun make-me (name age)
  (list :name name :age age))

(add-me (make-me "shin" 64))
*vvv*

;; assoc list
(defvar *sss* nil)

(test-set "assoc"
  (setf *sss* (pairlis '(a b c) '(1 2 3)))
  (expect-equal "test for assoc value" '(b . 2) (assoc 'b *sss*))

;; inverse of pairlis exists??
)

;;; property list
(test-set "property list"
  (defvar *plist* ())
  (setf (getf *plist* :a) 123)
  (expect-equal "get on a property list" 123 (getf *plist* :a))
  (setf (getf *plist* :b) '(f x))
  (expect-equal "set on a property list" '(f x) (getf *plist* :b))
)

;;
(test-set "substitute"
  (defvar *lll* '(a b c))
  (expect-equal "atom to atom" '(a 2 c) (substitute 2 'b *lll*))
  (expect-equal "atom to term" '(a (f x) c) (substitute '(f x) 'b *lll*))

)
;;
(test-set "subst"
  (defvar *eee* '(x y))
  (expect-equal "atom to atom" '(y y) (subst 'y 'x *eee*))
  (expect-equal "atom to term" '(x (f x)) (subst '(f x) 'y *eee*))

  (expect-equal "try to make par subst" '((f y) a) (subst '(f y) 'x (subst 'a 'y *eee*)))
  (expect-equal "i want to this" '((f a) a) (subst 'a 'y (subst '(f y) 'x *eee*)))

  (defvar *fff* '((f x)(g y)))
  (expect-equal "into subexp by subst" '((f (g z)) (g a)) (subst '(g z) 'x (subst 'a 'y *fff*)))
)

