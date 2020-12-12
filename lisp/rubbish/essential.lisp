;; essential functions of common lisp

;; time-now return a string of current date and time
(defun time-now ()
  (let (sec min hr day mon year dow daylight-p zone)
    (multiple-value-setq (sec min hr day mon year dow daylight-p zone)
      (decode-universal-time (get-universal-time)))
    ;; format of 0 prefix decimal from p250 in Practical Common Lisp
    (format nil "~4,'0d~2,'0d~2,'0d.~2,'0d~2,'0d~2,'0d" year (- mon 1) day hr min sec)
  )
)


