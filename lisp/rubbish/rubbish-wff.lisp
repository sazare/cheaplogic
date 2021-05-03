; rubbish-wff.lisp
; convert wff to DNF

(load "rubbish-base.lisp")

;; primitive

(defun neglit (lit)
  (cons  (oppo (car lit)) (cdr lit))
)

(defun negconj (conjs)
  (loop for lit in conjs collect 
    (neglit lit)
  )
)

; newncls
(defun make-newclause (vars lits)
;  (cons (incf *maxcid*) (cons vars lits)) ;; no cid in kqc file is better.
   (cons vars   lits)
)

; eqvivalent : (eqv vars lit rhs) or (vars lit ..) & lhs is one literal !!
; eqv なら clauseに変換。それ以外はそのままにする。clauseとeqvを混ぜた書き方もしたいので。
(defun eqv2c (wff)
  (if (eq 'eqv (car wff))
    (cons
      (make-newclause  (cadr wff) (cons (caddr wff) (negconj (cdddr wff)))) ; l<-r
      (loop for rlit in (cdddr wff) collect 
        (make-newclause (cadr wff) (list (neglit (caddr wff)) rlit))) ; r<-l
    )
    (list (make-newclause (car wff) (cdr wff)))
  )
)

(defun eqvs2cs (wffs)
  (loop with clss = () for wff in wffs do
    (setq clss (append clss (eqv2c wff)))
    finally (return clss)
  )
)

(defun write-kqc (fname kqc)
  (with-open-file (out fname
      :direction :output
      :if-exists :supersede)
    (format out ";~a @ ~a~%" fname (time-now))
    (loop for sexp in kqc do
      (format out "~a~%" sexp)
    )
  )
)
