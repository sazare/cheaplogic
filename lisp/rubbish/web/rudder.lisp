;; wakeup google from sbcl, added to nin-3.lisp

; from https://github.com/fukamachi/ningle with some modi.

(ql:quickload '(:ningle :clack))

(load "../pre-rubbish.lisp")

(in-package :rubbish)

(load "rub-html.lisp")

;; the next step should be done under a web operation
; (load "../play-prover-gt-ml002.lisp")

(defun rudder-prover-gtrail (goal)
  (let ()
    (logstart)
    (prover-gtrail goal) ; goal is a list of cid
  )
)

(defun rudder-gtrail (params)
  (let (gid sgid)
    (cond 
      (params 
        (setq sgid (cdr (assoc "what1" params :test 'string=)))
        (setq gid (intern sgid :rubbish))  ;; now what1 is only cid as "C1", but what1 will "C1 C2 ..." 
          (cond 
            (gid (rudder-prover-gtrail (list gid)) 
                 (apage (reverse *clist*)))
            (t (rudder-undefined-command gid))
          )
      )
      (t (rudder-undefined-command "op"))
    )
  )
)

(defun rudder-proof (params)
  (let (cid)
    (cond 
      (params (setq cid (cdr (assoc "what1" params :test 'string=)))
              (ppage (intern cid :rubbish)))
      (t (rudder-undefined-command "op"))
    )
  )
)

(defun rudder-start ()
  (:html "RUDDER START" (readpage))
)

(defun rudder-readkqc (params)
  (let (path)
    (common-lisp:in-package :rubbish)
    (cond 
      (params (setq path (cdr (assoc "kqcpath" params :test 'string=)))
              (cond 
                (path (readkqc path)
                      (cond 
                        (*clist* (apage (reverse *clist*)))
                        (t (rudder-undefined-command path) path)
                      )) 
                (t (rudder-undefined-command path) path)
              ))
      (t (rudder-undefined-command "op"))
    )
  )
)

;; do rubbish
(defvar *app* (make-instance 'ningle:<app>))

;; http://127.0.0.1:5000/
(setf (ningle:route *app* "/") "Welcome to rudder!")

;; apage make a page of print-clauses 


(setf (ningle:route *app* "/clist" :accept '("text/html" "text/xml"))
      #'(lambda (params)
          (declare (ignore params))
          (apage (reverse *clist*))
        )
)

(setf (ningle:route *app* "/clist0" :accept '("text/html" "text/xml"))
      #'(lambda (params)
          (declare (ignore params))
          (bpage (reverse *clist*))
        )
)

(defun rudder-proc (params)
  (let (opr)
    (cond 
      (params (setq opr (cdr (assoc "op" params :test 'string=))))
      (t (rudder-undefined-command params))
    )
    (setq *peval-active* nil)              
    (cond
      ((equal opr "gtrail") (rudder-gtrail params))
      ((equal opr "clist")(apage (reverse *clist*)))
      ((equal opr "clist0")(bpage (reverse *clist*)))
      ((equal opr "proof")(rudder-proof params))
      ((equal opr "start") (rudder-start))
      ((equal opr "readkqc")(rudder-readkqc params)(apage (reverse *clist*)))
      (t (rudder-undefined-command opr))
    )
  )
)

(setf (ningle:route *app* "/rudder" :accept '("text/html" "text/xml"))
      #'(lambda (params) (rudder-proc params))
)

(clack:clackup *app*)

; (uiop/run-program:run-program "open -a \"Safari.app\" http://localhost:5000/hi" :output T)

