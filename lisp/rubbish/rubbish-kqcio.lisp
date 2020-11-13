;; io functions of kqc

;; one level read and clausify
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

;; readkqc extended for include another kqcfile
(defun readefile (fname)
 (loop for exp in (readafile fname)
   append 
     (if (eq 'readefile (car exp))
       (eval exp)
       (list exp)
     ) 
 )
)
(defun readekqc (fname)
 (let ((kqc (readefile fname)))
   (loop for k in kqc 
     collect (make-clause k)
   )
 )
)


;; string version of readkqc
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
