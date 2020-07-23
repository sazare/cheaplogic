; alpha-unif-snot.lisp
;; seq notation

;;; unification
;; unifys: E x E -> NO | S
; when vs =(x) empty subst must be ((x . x))
; 
; naive version

(defun unifys0 (vs e1 e2 mgu)
 (prog (ds s1 m1)
  (setf ds (disagree e1 e2))
  (cond 
    ((null ds) (return mgu))
    (t (let ((de1 (car ds))(de2 (cdr ds)))
      (setf s1 (unifiable vs de1 de2))

      (cond ((equal s1 'NO)(return 'NO)))

      (setf e1 (subst1s e1 s1))
      (setf e2 (subst1s e2 s1))
      (setf mgu (subsub1s mgu s1))

      (setf m1 (unifys0 vs e1 e2 mgu))

      (return m1)
      )
    )
  )
 )
)

(defun unifys (vs e1 e2)
 (unifys0 vs e1 e2 (emptysigma vs))
)

(defun emptysigma (vs)
  (if (null vs) ()
    (cons (sigma (car vs)(car vs)) (emptysigma (cdr vs)))
  )
)

(defun disagree (e1 e2) ;; () or pair
 (cond
  ((equal e1 e2) ())
  ((or (atom e1)(atom e2)) (cons e1 e2))
  ((equal (car e1)(car e2)) (disagree* (cdr e1) (cdr e2)))
  (t (cons e1 e2))
 )
)

(defun disagree* (e*1 e*2) ;; () or pair
  (if
    (null e*1) ()
    (let 
      ((da (disagree (car e*1)(car e*2))))
       (if
         (null da)(disagree* (cdr e*1)(cdr e*2))
         da
       )
    )
  )
)

(defun unifiable (vs e1 e2)
  (cond
    ((equal e1 e2) (sigma e1 e1))
    ((isvar vs e1) 
      (if
        (insidep e1 e2) 'NO
        (sigma e1 e2)
      )
    )
    ((isvar vs e2) 
      (if
        (insidep e2 e1) 'NO
        (sigma e2 e1)
      )
    )
    (t 'NO)
  )
)
      
(defun insidep (s e)
  (if (equal s e) nil
   (insidep1 s e))
)  

(defun insidep1 (s e)
  (if (equal s e) T
   (if (not (atom e)) (insidep1* s (cdr e))
      NIL 
   )
  )
)

(defun insidep1* (s e*)
  (if (null e*) nil
    (or (insidep1 s (car e*)) (insidep1* s (cdr e*)))
  )
)

