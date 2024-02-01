;rubbish-beauty.lisp

(in-package :rubbish)

;; beauty clause list

(defun beauty-term (term &optional (out t))
  (let ()
    (cond
      ((atom term) (format out "~a" term))
      (t (let ((fsym (car term))(args (cdr term)))
           (format out "~a\(" fsym)
           (beauty-term* args)
           (format out "\)")
         )
      )
    )
  )
)

(defun beauty-term* (arg* &optional (out t))
  (let ()
    (format out "(")
    (loop for tm* on arg* do
      (beauty-term (car tm*) out)
      (when (cdr tm*) (format out ","))
    finally
      (format out ")")
    )
  )
)

(defun beauty-lit (lit &optional (out t))
  (let ((sign (car lit))(psym (cadr lit))(args (cddr lit)))
    (format out "~a~a" sign psym)
     (beauty-term* args)
  )
)

(defun beauty-lit* (&optional (lid* *llist*) (out t))
  (loop for lid in lid*
    do
    (beauty-lit (eval lid) out)
  )
)

(defun beauty-lid* (&optional (lid* *llist*) (out t))
  (loop for lid in lid*
    do
    (beauty-lit (eval lid) out)
    (format out " ")
  )
)

(defun beauty-cid (cid &optional (out t))
  (cond 
    ((isvalid cid)
     (cond 
       ((bodyof cid)
         (format out "~a = <VALID>~%" cid) (beauty-lid* (bodyof cid) out))
       (t (format out "~a = [] <VALID>~%" cid))
     )
    )
    ((iscontradiction cid)
     (cond
       ((bodyof cid) 
         (format out "~a = " cid) (beauty-lid* (bodyof cid) out))
       (t (format out "~a = []~%" cid))
     )
    )
    (t 
     (format out "~a ~a.[" cid(varsof cid))
      (beauty-lid* (bodyof cid))
     (format out "]")
    )
  )
)

(defun beauty-cid* (&optional (cid* *clist*) (out t))
  (loop for cid in cid* do
    (cond
      ((isvalid cid) (format out "VALID ~a~a~%" cid (bodyof cid)))
      (t (beauty-cid cid out) (format out "~%"))
    )
  )
)


;;; ui
(defmacro bcs (&rest cs)
  `(beauty-cid* ,(or cs *clist*))
)

