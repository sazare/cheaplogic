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

;;; 


(defun comb1 (e l)
  "make (e) and (e. m) in ∀m ∈ l"
  (if (null l)
    e
    (list (cons e (car l))  (comb1 e (cdr l)))
  )
)

(defun combnn (l1 l2)
  "make all pair of l1 and l2 as same length"
  (loop for c1 in l1 append
    (loop for c2 in l2 collect 
       (list c1 c2)
    )
  )
)

;;;  subset ops
(defun choose2 (a ll)
  "a,ll -> (a . b) for all b ∈ ll"
  (loop for b in ll  collect (cons a b))
)

(defun choose1 (ll)
  (if (null (cdr ll))
    (loop for a in (car ll) collect (list a))
    (loop for a in (car ll) append (choose2 a (choose1 (cdr ll))))
  )
)

