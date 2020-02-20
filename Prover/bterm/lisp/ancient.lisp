;; ancient substitution and unification
; the origin of performance measure

(defun isvar (vars sym)
  (member sym vars)
)

;; substitution
;; (defun subst) exists
;; (subst t v expr)
;; (substitute t v expr)

(defun subst* (sigma expr)
  (progn 
    (loop for s in sigma
      do (setf expr (subst (cdr s) (car s) expr))
    )
    expr
  )
)
    

;; disagreement
(defun disagree-list (lis1 lis2)
  (loop
    for e1 in lis1
    for e2 in lis2
    do
    (let ((d (disagree e1 e2)))
      (if (not (null d)) (return d))
    )
  )
)

(defun disagree (e1 e2)
  (if (equal e1 e2) 
    '()
    (if (or (atom e1) (atom e2)) 
      (cons e1 e2)
      (if (not (equal (car e1)(car e2)))
        (cons e1 e2)
        (disagree-list (cdr e1)(cdr e2))
      )
    )
  )
)


(defun switcher (vars dis)
  (if (null dis) 
    '()
    (if  (isvar vars (car dis)) 
      dis
      (if (isvar vars (cdr dis)) 
        (cons (cdr dis)(car dis))
        'NO
      )
    )
  )
)

;; insidep
(defun insidep* (vars v el)
  (cond
    ((null el) NIL)
    ((equal v (car el)) T)
    ((not (insidep1 vars v (car el))) (insidep* vars v (cdr el)))
    (T T)
  )
)

(defun insidep1 (vars v e)
  (cond 
    ((equal v e) T)
    ((atom e) NIL)
    (T (insidep* vars v e))
  )
)

(defun insidep (vars v e)
  (cond 
    ((equal v e) NIL)
    (T (insidep1 vars v e))
  )
)

;; make-unifier

(defun unify (vars e1 e2)
  (let ((sigma ())(ee1 e1) (ee2 e2))
    (if (equal ee1 ee2) 
     '()
     (loop while T 
       do
       (let ((d ()))
;    (format t "ee1:~a~%" ee1)
;    (format t "ee2:~a~%" ee2)
         (setf d (disagree ee1 ee2))
;    (format t "1d:~a~%" d)
         (setf d (switcher vars d))
;    (format t "2d:~a~%" d)
         (when (eq d 'NO) (return 'NO))
         (when (null d) (return (reverse sigma)))
;    (format t "d:~a~%" d)
         (push d sigma)
         (setf ee1 (subst* sigma e1))
         (setf ee2 (subst* sigma e2))
;    (format t "aee1:~a~%" ee1)
;    (format t "aee2:~a~%" ee2)
;    (format t "sigma:~a~%" sigma)
        )
      )
    )
  )
)
