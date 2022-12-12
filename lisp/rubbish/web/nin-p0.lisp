;; wakeup google from sbcl, added to nin-3.lisp

;; http://127.0.0.1:5000/start    ask which kqc for input

;; http://127.0.0.1:5000/clist    show clause with lit
;; http://127.0.0.1:5000/clist0   show lid

; from https://github.com/fukamachi/ningle with some modi.

(ql:quickload '(:ningle :clack))

(load "../pre-rubbish.lisp")


;; prepare data

(in-package :rubbish)

(load "../play-prover-gt-ml002.lisp")1

(load "html.lisp")

;; do rubbish
(defvar *app* (make-instance 'ningle:<app>))

;; http://127.0.0.1:5000/
(setf (ningle:route *app* "/") "Welcome to rudder!")

;; apage make a page of print-clauses 


(setf (ningle:route *app* "/clist" :accept '("text/html" "text/xml"))
      #'(lambda (params)
          (declare (ignore params))
          (apage nil (reverse *clist*))
        )
)


(setf (ningle:route *app* "/clist0" :accept '("text/html" "text/xml"))
      #'(lambda (params)
          (declare (ignore params))
          (bpage nil (reverse *clist*))
        )
)

(clack:clackup *app*)

; (uiop/run-program:run-program "open -a \"Safari.app\" http://localhost:5000/hi" :output T)

