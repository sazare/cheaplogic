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
)

;;; property list
(test-set "property list"
  (defparameter *plist* ())
  (setf (getf *plist* :a) 123)
  (expect-equal "get on a property list" 123 (getf *plist* :a))
)

;;
(test-set "substitute"
  (defvar *lll* '(a b c))
  (expect-equal "atom to atom" '(a 2 c) (substitute 2 'b *lll*))
  (expect-equal "atom to atom" '(a (f x) c) (substitute '(f x) 'b *lll*))
)

