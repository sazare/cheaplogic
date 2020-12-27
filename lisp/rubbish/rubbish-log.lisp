;; logging 



;; *rubbish-log*
(defparameter *rubbish-log* nil)

(defun logreset ()
  (setq *rubbish-log* nil)
)

(defun logshow ()
  (loop for log in *rubbish-log* 
    do (format t "~a~%" log)
  )
)

;; about logging-active control
(defparameter *logging-active* nil)

(defun logstart ()
  (setq *logging-active* T)
)

(defun logstop ()
  (setq *logging-active* nil)
)

(defun logstate ()
  (format t "*logging-active*=~a~%" *logging-active*)
)


;; loggging function
;; (time-now) may be (- (time-now) *start-time*) is more understandable. 
;;  but *start-time* can be accessible from anywhere? and the computation cost?.

(defun rubbish-log (&rest message)
  (and
    *logging-active*
    (push (cons (time-now) message) *rubbish-log*)
  )
)

