;; 
;; from rubbish-kqcio.lisp

(in-package :rubbish)

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

(defun readafile-str (fname)
  (with-open-stream (ins (open fname))
    (let* ((buffer (make-array (file-length ins)
                  :element-type
                  (stream-element-type ins)
                  :fill-pointer t))
                    (position (read-sequence buffer ins)))
     (setf (fill-pointer buffer) position)
     buffer)
  )
)
