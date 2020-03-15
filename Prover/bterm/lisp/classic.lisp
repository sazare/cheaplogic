
;; ancient substitution and unification
; the origin of performance measure

(defun isvar (vars sym)
  (member sym vars)
)

;; substitution

;; this subst* is a simple parallel substition
(defun psubst* (sigma expr)
;; expr is not an atom
  (loop for e in expr
    collecting (psubst sigma e)
  )
)

(defun spsubst (sigma expr)
  (cond
    ((null sigma) expr)
    ((eq (caar sigma) expr) (cdar sigma))
    (t (spsubst (cdr sigma) expr))
  )
)

(defun psubst (sigma expr)
  (cond 
    ((atom expr)(spsubst sigma expr))
    (t (psubst* sigma expr))
  )
)

;;; disagreement
(defun disagree* (lis1 lis2)
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
        (disagree* (cdr e1)(cdr e2))
      )
    )
  )
)

;; switcher make psubst pair from DS
;; this version just check which is variable, or 'NO
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
;; v is just a symbol. not concern var or not.
(defun insidep* (s el)
  (cond
    ((null el) NIL)
    ((equal s (car el)) T)
    ((not (insidep1 s (car el))) (insidep* s (cdr el)))
    (T T)
  )
)

(defun insidep1 (s e)
  (cond 
    ((equal s e) T)
    ((atom e) NIL)
    ((not (insidep1 s (car e))) (insidep* s (cdr e)))
  )
)

(defun insidep (s e)
  (cond 
    ((equal s e) NIL)
    (T (insidep1 s e))
  )
)

;; how to make unifier
; (unify vars e1 e2)
; 

;;; make-unifier
;
(defun unify (vars e1 e2)
  (let ((sigma ())(ee1 e1) (ee2 e2))
    (if (equal ee1 ee2) 
     '()
     (loop while T 
       do
       (let ((d ()))
         (setf d (disagree ee1 ee2))
         (setf d (switcher vars d))
         (when (eq d 'NO) (return 'NO))
;; sort for let be unique psubst 
;; this is time consumer. for speedup, dont do sort, and dont check of equality of mgu.
         (when (null d) (return (sort sigma (lambda (x y) (string< (car x)(car y))))))
;; the next line is for sigma commutative
;; time consumer
         (setf sigma (subst (cdr d)(car d) sigma))
         (push d sigma)
         (setf ee1 (subst (cdr d) (car d) ee1))
         (setf ee2 (subst (cdr d) (car d) ee2))
;;why the followings are incorrect?
;         (setf ee1 (subst* sigma e1))
;         (setf ee2 (subst* sigma e2))
        )
      )
    )
  )
)


;(defun sunify (vars e1 e2)
;  (let ((sigma ())(ee1 e1) (ee2 e2))
;    (if (equal ee1 ee2) 
;     '()
;     (loop while T 
;       do
;       (let ((d ()))
;         (setf d (disagree ee1 ee2))
;         (setf d (switcher vars d))
;         (when (eq d 'NO) (return 'NO))
;         (when (null d) (return (reverse sigma)))
;         (push d sigma)
;         (setf ee1 (subst (cdr d) (car d) ee1))
;         (setf ee2 (subst (cdr d) (car d) ee2))
;        )
;      )
;    )
;  )
;)
