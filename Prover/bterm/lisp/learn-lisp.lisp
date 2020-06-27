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

;; continuation
;; first just loop on expr
; (loop for x in x1 collect x)
; (loop for a in x1 for b in x2 do (format t "~a:~a~%" a b))
; (loop for a in x1 for b in x2 collect (cons a b))
; (loop for s1 in '((a)(b)(c)) append s1 )

(test-set "double loop"
  (defvar x1 '(1 2 3))
  (defvar x2 '(a b c))
  (expect-equal "double loop" '((1 . a)(2 . b)(3 . c)) 
    (loop for a in x1 for b in x2 collect (cons a b)))
)

(defun traverse2 (e1 e2)
  (cond 
    ((or (atom e1)(atom e2))(cons e1 e2))
    (t (loop for se1 in e1 for se2 in e2 collect (traverse2 se1 se2)))
  )
)

(defun traversediff (e1 e2)
  (cond 
;    ((equal e1 e2) ())
    ((or (atom e1)(atom e2))(list (cons e1 e2)))
    (t (loop for se1 in e1 for se2 in e2 unless (equal se1 se2) append (traversediff se1 se2)))
  )
)

(test-set "traverse2"
  (expect-equal "traverse2 lists" '((x . a)(y . z)) (traverse2 '(x y) '(a z)))
  (expect-equal "traverse2 lists have same" '((x . a)(b . b)(y . z)) (traverse2 '(x b y) '(a b z)))
)

(test-set "traversediff"
  (expect-equal "traversediff same" '() (traversediff '(x y) '(x y)))
  (expect-equal "traversediff same depth" '() (traversediff '((f x) y) '((f x) y)))
  (expect-equal "traversediff lists" '((x . a)(y . z)) (traversediff '(x y) '(a z)))
  (expect-equal "traversediff lists have same" '((x . a)(y . z)) (traversediff '(x b y) '(a b z)))
  (expect-equal "traversediff depth" '((x . a)(y . z)) (traversediff '(x (b y)) '(a (b z))))
)

;; I/O
;; 標準出力を捨てる方法
(with-open-file (*standard-output* "/dev/null" :if-exists :supersede :direction :output)
 (format t "You cant see me~%")
 )

