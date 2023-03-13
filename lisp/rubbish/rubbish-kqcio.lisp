;; io functions of kqc

(in-package :rubbish)

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

(defparameter *kqcfile* "")

(defun warn-syntax (ls)
  (loop for l in (check-literals ls) do
    (format t "~a: ~a~%" l (bodyof l))
  )
)

(defun readkqc (fname)
 (let ((kqc (readafile fname)))
   (loop for k in kqc 
     collect (make-clause k)
   )
   (setq *kqcfile* fname)
   (make-lsymlist *llist*)
   (warn-syntax *llist*)
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
   (format t "kqc reading: ~a~%" fname)
   (prog1 
     (loop for k in kqc 
       do (format t ".")
       collect (make-clause k)
     )
     (format t "~%")
     (setq *kqcfile* fname)
     (make-lsymlist *llist*)
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

(defun writekqc (fname kqc)
  (with-open-file (out fname 
      :direction :output
      :if-exists :supersede)

    (format out ";~a~%" fname)

    (loop for cls in kqc do
      (print cls out)
    )
  )
)
