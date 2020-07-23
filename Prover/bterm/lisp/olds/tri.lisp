;
;

;; sample data
;; input
(defvar i1 '((x).(f x)))
(defvar i2 '((x y).(f x (g x y))))
(defvar i3 '((x y z).(f x (g y z))))

; bindが多すぎないか??
;; binding form
(defvar b1 '((x) . (f x)))
(defvar b2 '((x y) . (f x ((x y).(g x y)))))
(defvar b3 '((x y z).(f x ((y).(g y a)))))

;; def of a binding form
;;; atom = symbol
;;;; symbol is variable or constant

;;; term = (bind . terms)
;;;; a symbol in bind is a variable, otherwise constant

;;; term = symbol | (bind . terms)


; (1) convert input to binding form
; (2) substitution
; (3) unification


;; (1) conversion

(defun conv-term0 (tm)
  (conv-term (car tm) (cdr tm))
)

(defun conv-term (bind in)
  (cond 
    ((and (atom in) (member in bind)) (cons in in))
    ((atom in) in)
    (t (cons (car in) (conv-terms bind (cdr in))))
  )
)


(defun conv-terms (bind tms)
  (cond
    ((null tms) nil)
    (t (cons (conv-term bind (car tms)) (conv-terms bind (cdr tms))))
  )
)


;; 比較のために、普通のtermも必要かも

