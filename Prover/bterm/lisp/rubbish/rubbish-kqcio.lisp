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


