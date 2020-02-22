;; hash-tableの使い方

(defparameter *hhh* (make-hash-table))
(setf (gethash 'v1 *hhh*) '(f x y))
(setf (gethash 'v2 *hhh*) '(g x y))
(setf (gethash 'v3 *hhh*) 'v3)


(loop for k being the hash-keys in *hhh* using (hash-value v) do (format t "~a => ~a~%" k v))

(maphash #'(lambda (k v) (list k v)) *hhh*)

(loop for k being the hash-keys in *hhh* using (hash-value v) collect (list k v))

(hash-table-count *hhh*)

(defun isvar (b a) (not (null (gethash a b))))

(load "test.lisp")
(defparameter *bind* (make-hash-table))
(setf (gethash 'v1 *bind*) '(f x y))
(setf (gethash 'v2 *bind*) '(g x y))
(setf (gethash 'v3 *bind*) 'v3)

(expect-equal "isvar is binding" T (isvar *bind* 'v1))
(expect-notequal "not isvar unbinding " T (isvar *bind* 'x))

