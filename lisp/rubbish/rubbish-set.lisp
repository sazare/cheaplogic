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

;;;; nextset
;; (nextset '(c d) '(a b c d e))
;; (0 0 1 1 0) => (0 0 1 1 1) => (c d e)

(defun nextset (s w)
  (objectize (nextbinary (binarize s w)) w)
)

(defun binarize (s w)
  (loop for e in w collect (if (member e s) 1 0))
)

(defun objectize (b w) 
  (loop for e in w as c in b when (eq c 1) collect e)
)

(defun nextbinary (b)
  (let ((c 1))
      (loop for d in b collect
        (if (eq 1 c)
          (cond
            ((eq d 1) (setq c 1) 0)
            ((eq d 0) (setq c 0) 1)
          )
          d
        )
      )
  )
)



