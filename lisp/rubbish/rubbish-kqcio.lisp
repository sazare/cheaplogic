;; io functions of kqc

(defun readafile (fname)
 (with-open-file (in fname)
  (read in)
 )
)

(defun readkqc (fname)
 (let ((kqc (readafile fname)))
   (loop for k in kqc 
     collect (make-clause k)
   )
 )
)


(defun readastring (str)
 (with-open-stream (s (make-string-input-stream str))
  (read s)
 )
)

(defun readskqc (str)
 (let ((kqc (readastring str)))
   (loop for k in kqc 
     collect (make-clause k)
   )
 )
)
