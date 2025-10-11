;; rubbish-combi.lisp
;; combination algorithms

(in-package :rubbish)

(defun putelem (e s)
  (cons e s)
)

(defun subsetof (s)
  (cond
    ((null s) nil)
    ((null (cdr s)) (list s))
    (t
      (let ((ss (subsetof (cdr s))))
        (append (list (list (car s)) )
                ss
                (loop for e in ss collect (cons (car s) e))
        )
      )
    )
  )  
)


(defun balance (pnp)
  (and
    (nth 1 pnp)
    (nth 2 pnp)
  )
)

(defun exhp-filter (ss)
  (loop for s in ss 
    when 
      (and 
        (> (length s) 1) 
        (loop for pnp in (make-lnplist s) always (balance pnp))
      )
    collect s
  )
)

(defun balance-nof (pnp)
  (and
    (nth 1 pnp)
    (nth 2 pnp)
    (eq (length (nth 1 pnp)) (length (nth 2 pnp)))
  )
)

(defun exhp-filter-noF (ss)
  (loop for s in ss 
    when 
      (and 
        (> (length s) 1) 
        (loop for pnp in (make-lnplist s) always (balance-nof pnp))
      )
    collect s
  )


)
