; performance test functions


(defun perf-fn (n fn)
 (time (dotimes (i n)(funcall fn)))
)
(defun performance (what N)
 (format t "~%** ~a of ~a times**" what N)
 (with-open-file (*standard-output* "/dev/null"  :if-exists :overwrite :direction :output)
  (perf-fn  N what)
  )
)

;; usage
; (defparameter PN 10000)
; (performance `ito-unifications PN)
; (performance `ito-unificationp PN)
; (performance `ito-unificationsp PN)



