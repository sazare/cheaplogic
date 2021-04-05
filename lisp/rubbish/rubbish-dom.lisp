;; rubbish-dom.lisp
;; concern EO-LO 
;; runctions over domain specific

(defun is-unique-dom (vars x y)
  (unless (or (isvar vars x) (isvar vars y))
    (eq x y)
  )
)

;(defun is-uniq (x y) ; x y are constants
;  (eq x y)
;)

(defmacro is-uniq (x y)
  `(eq ',x ',y)
)


