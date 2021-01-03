;; io functions of kqc

;; one level read and clausify

(defun readafile0 (fname)
 (with-open-file (in fname)
  (read in)
 )
)

(defun readafile (fname)
 (with-open-file (ins fname)
   (let (data)
     (loop until (eq :eof (setf data (read ins nil :eof)))
       collect 
          data
       )
     )
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
     (cond 
       ((equal 'readefile (car exp)) (eval exp))
       ((equal 'eval (car exp)) (eval exp) ())
       (t (list exp))
     ) 
 )
)

(defun readekqc (fname)
 (let ((kqc (readefile fname)))
   (format t "kqc reading ... ~a" fname)
   (prog1 
     (loop for k in kqc 
       collect (make-clause k)
     )
     (format t "... end~%")
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

;;; writeafile
(defun writeafile (fname objects)
  (with-open-file (out fname 
      :direction :output
      :if-exists :supersede)

    (print objects out)
  )
)

