
(setq sexp (nth 2 sb-ext:*posix-argv*))


(let (c00 (s (make-string-input-stream (nth 2 sb-ext:*posix-argv*) ))) 

   (setq c00 (read s))

   (format t "1st = ~a~%" c00)
   (format t "car 1st = ~a~%" (car c00))
   (format t "cadr 1st = ~a~%" (cadr c00))

   (format t "2nd = ~a~%" (nth 3 sb-ext:*posix-argv*))
)



