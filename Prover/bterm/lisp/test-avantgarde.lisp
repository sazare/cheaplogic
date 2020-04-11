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

(defun queen (sigma v e)
  (cond 
    ((null (assoc v sigma)) (cons sigma (cons v e)))
    (t "how replace the element is difficult in assoc")
;; and cant setf to replace it
  )
)

(defun jack (sigma v e)
  (if (null sigma) (setf sigma (make-hash-table)))
  (setf (gethash v sigma) e)
  sigma
)

(defvar s1 nil)

(setf s1 (jack s1 'x 1))
(expect-equal "1" 1 (gethash 'x s1))

(setf s1 (jack s1 'y 2))
(expect-equal "1" 1 (gethash 'x s1))
(expect-equal "2" 2 (gethash 'y s1))

