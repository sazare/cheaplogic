;; flog is extended log for output to file

(in-package :rubbish)

; 1 append and supersede
; 2 format args

(defun create-flog (logfile)
  (unless (probe-file logfile)
    (with-open-file (out logfile
                   :direction :output
                   :if-exists :supersede)
    )
  )
)

(defun new-flog (logfile)
  (with-open-file (out logfile
                 :direction :output
                 :if-exists :supersede)
  )
)

(defun flog (logfile format &rest args)
  (cond
    ((eq logfile t)
     (format t "~a " (local-time:now))
     (apply #'format t format args)
     (terpri t)
    )
    (t  
      (with-open-file (out logfile :direction :output :if-exists :append)
        (format out "~a " (local-time:now))
        (apply #'format out format args)
        (terpri out)
      )
    )
  )
)

(defun fmsg (logfile format &rest args)
  (cond
    ((eq logfile t)
      (apply #'format t format args)
    )
    (t  
      (with-open-file (out logfile :direction :output :if-exists :append)
          (format out "~a~%"  (with-output-to-string (os) (apply #'format os format args)))
      )
    )
  )
)

