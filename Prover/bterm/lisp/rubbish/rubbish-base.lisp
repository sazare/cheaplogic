;; rubbish-base.lisp
;; preload oneof rubbish-gen.lisp or rubbish-gen-noran.lisp

;; isterm ... may be use
(defun isterm (e)
  (cond 
    ((or (integerp e) (floatp e) (stringp e) (atom e)) T)  ;; really it is atom
    (t (and (atom (car e))(isterm* (cdr e))))
  )
)

(defun isterm* (e)
  (cond
    ((null e) T)
    ((and (isterm (car e)) (isterm* (cdr e))))
  )
)

;; LID ops
(defun make-lid (cid n)
  (let ((lid (format nil "L~a:" n)))
  (rub-gensym lid)
  )


;; CID ops

(defun make-cid (n)
  (let ((cid (format nil "C~a:" n)))
  (rub-gensym cid)
  )
)

(defun make-clause (cexp)
  (let* ((cid (make-cid (car cexp)))
        (vars (cadr cexp))
        (body (make-lids cid (cddr cexp))))
  (set cid `(
             :vars ,vars
             :body ,body))
  )
)

(defun cidof (cid)
  (getf cid :cid)
)

(defun varsof (cid)
  (getf cid :vars)
)

(defun bodyof (cid)
  (getf cid :body)
)



