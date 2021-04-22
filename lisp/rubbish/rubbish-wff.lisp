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
(defun make-newclause (lits)
  (cons (incf *maxcid*) (cons '()  lits))
)

; eqvivalent : (eqv lit rhs)
; eqv なら clauseに変換。それ以外はそのままにする。clauseとeqvを混ぜた書き方もしたいので。
(defun eqv2c (wff)
  (if (eq 'eqv (car wff))
    (cons
      (make-newclause  (cons (cadr wff) (negconj (cddr wff))))
      (loop for rlit in (cddr wff) collect (make-newclause (list (neglit (cadr wff)) rlit)))
    )
    (make-newclause wff)
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
