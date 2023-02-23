; rubbish-analyze.lisp for analyzing tools on proofs
(in-package :rubbish)

;;; trans of mapn
(defun trans-mat (adjm)
  (loop for i from 0 to (1- (length adjm)) collect
    (loop for j from 0 to (1- (length adjm)) collect
      (nth i (nth j adjm))
    )
  )
)


;;; make-adjmatrix nnmap to adjent matrix for R
(defun conv-to-bitmap (size aline)
  (loop with flat = (second aline)
    for i from 0  to size collect
      (if (member i flat) 1 0)
  )
)

(defun conv-to-adjacent (mapn)
  "convert mapn to adjcent matrix. node number is the size of mapn"
  (loop for line in mapn collect
    (conv-to-bitmap (1- (length mapn)) line)
  )
)

;; write R Adjcent matirx form
(defun writeadjm (fname adjm)
  (with-open-file (out fname 
      :direction :output
      :if-exists :supersede)
    (let ((elem1 T))
      (format out "mjda= c(~%")
      (loop for line in adjm do
        (loop for a in line do
          (if elem1
            (progn (format out "~a" a) (setq elem1 nil))
            (format out ",~a" a)
          )
        )
        (terpri out)
      )
      (format out ")~%")
    )
  )
)

;;; writebfile write a file a s-exp a line
(defun writebfile (fname objects)
  (with-open-file (out fname 
      :direction :output
      :if-exists :supersede)
    (loop for o in objects do
      (if o 
        (format out "~a~%"  o)
        (format out "\(\)~%")
      )
    )
  )
)

