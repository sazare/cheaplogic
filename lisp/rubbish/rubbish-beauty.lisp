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
    (loop for tm* on arg* do
      (beauty-term (car tm*) out)
      (when (cdr tm*) (format out ","))
    )
  )
)

(defun beauty-lit (lit &optional (out t))
  (let ((sign (car lit))(psym (cadr lit))(args (cddr lit)))
    (format out "~a~a" sign psym)
    (format out "(")
    (beauty-term* args)
    (format out ")")
  )
)

(defun beauty-lit* (&optional (lid* *llist*) (out t))
  (loop for lid in lid*
    do
    (beauty-lit (eval lid) out)
  )
)

(defun beauty-lid* (&optional (lid* *llist*) (out t))
  (loop for lid2 on lid*
    do
    (beauty-lit (eval (car lid2)) out)
    (when (cdr lid2) (format out " "))
  )
)


(defun beauty-vars (vars out)
  (when vars
    (format out "∀~{~a ~}" vars)
;    (format out "∀")
;    (loop for vs on vars do
;      (format out "~a" (car vs))
;      (when (cdr vs) (format out " "))
;    )
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
      (format out "~a " cid)
      (beauty-vars (varsof cid) out)
      (format out "[")
      (beauty-lid* (bodyof cid) out)
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
(defun bcs (&optional (cid* *clist*) (out t))
  (beauty-cid* cid* out)
)

(defmacro b1 (&optional cid (out t))
  `(beauty-cid ',cid ,out)
)
