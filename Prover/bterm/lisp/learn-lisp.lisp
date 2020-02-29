;; Practical Commonlisp CD DB
(load "test.lisp")

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

