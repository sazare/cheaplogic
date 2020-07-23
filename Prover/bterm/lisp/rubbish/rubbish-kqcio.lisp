;; io functions of kqc

(defun readkqc (fname)
 (with-open-file (in fname)
  (read in)
 )
)


