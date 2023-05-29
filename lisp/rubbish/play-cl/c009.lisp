;; (load "c009.lisp")

(prog (x)
  (setq x (uiop:run-program "./c009-1.sh" :force-output t))
  ;(setq x (uiop:run-program "sbcl --script 'c009-1.sh'" :force-output t))
  (format t "value = ~a~%" x)
)
