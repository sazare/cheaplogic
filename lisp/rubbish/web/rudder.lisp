;; wakeup google from sbcl, added to nin-3.lisp

; from https://github.com/fukamachi/ningle with some modi.

(ql:quickload '(:ningle :clack))

(load "../pre-rubbish.lisp")

(in-package :rubbish)

(load "fileio.lisp")
(load "rub-html.lisp")

;; the next step should be done under a web operation
; (load "../play-prover-gt-ml002.lisp")



(defun rudder-start ()
  (:html "RUDDER START" (readpage (with-output-to-string (out) (show-parameter0 out))))
)

(defun string-clauses (clist)
  (with-output-to-string (out) (print-clauses clist out))
)

(defun string-clausex (clist)
  (with-output-to-string (out) (print-clausex clist out))
)

(defun string-proof0 (cid ix)
  (with-output-to-string (out) (print-proof0 cid ix out))
)

(defun rudder-proof (params)
  (let (cid)
    (cond 
      (params (setq cid (cdr (assoc "what1" params :test 'string=)))
              (dpage (format nil "proof of ~a" cid) (string-proof0 (intern cid :rubbish) 0)))
      (t (rudder-undefined-command "op"))
    )
  )
)

(defun rudder-readkqc (params)
  (let (path)
    (common-lisp:in-package :rubbish)
    (cond 
      (params (setq path (cdr (assoc "kqcpath" params :test 'string=)))
              (cond 
                (path (readkqc path)
                      (cond 
                        (*clist* (dpage "claues" (string-clauses (reverse *clist*))))
                        (t (rudder-undefined-command path) path)
                      )) 
                (t (rudder-undefined-command path) path)
              ))
      (t (rudder-undefined-command "op"))
    )
  )
)

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
                 (dpage "summary" (with-output-to-string (out) (summary0 out))))
            (t (rudder-undefined-command gid))
          )
      )
      (t (rudder-undefined-command "op"))
    )
  )
)

(defun rudder-invariant (params)
 (let (cid scid iv pc pc0 cc pinf)
   (cond 
      (params 
        (setq scid (cdr (assoc "what1" params :test 'string=)))
        (setq cid (intern scid :rubbish))
        (cond 
          (cid 
            (setq iv (invariantof cid))
            (setq pinf (pinfof cid))
            (setq pc (pcode cid))
            (setq pc0 (pcode0 cid))
            (setq cc (ccode cid))
            (dpage "invariant" (with-output-to-string (out) (format out "ccode: ~a~%pinfo: ~a~%pcode0: ~a~%pcode: ~a~%invariant mgu:~a~%       clause: ~a~%" cc pinf pc0 pc (car iv) (cadr iv)))))
 
          (t (rudder-undefined-command cid))
        )
      )
    )
  )
)

;; do rubbish
(defvar *app* (make-instance 'ningle:<app>))

;; http://127.0.0.1:5000/
(setf (ningle:route *app* "/") "Welcome to rudder!")

;; my main loop in rudder server
(defun rudder-proc (params)
  (let (opr)
    (cond 
      (params (setq opr (cdr (assoc "op" params :test 'string=))))
      (t (rudder-start))
    )
    (setq *peval-active* nil)              
    (cond
      ((equal opr "gtrail") (rudder-gtrail params))
      ((equal opr "clist")(dpage "claues" (string-clauses (reverse *clist*))))
      ((equal opr "clist0")(dpage "clauses with lid" (string-clausex (reverse *clist*))))
      ((equal opr "proof") (rudder-proof params))
      ((equal opr "start") (rudder-start))
      ((equal opr "invariant") (rudder-invariant params))
      ((null opr) (rudder-start))
      ((equal opr "readkqc")(rudder-readkqc params)(dpage "clauses" (string-clauses (reverse *clist*))))
      (t (rudder-undefined-command opr))
    )
  )
)

(defun rudder-readfile ()
  (readfile-to-string "css/rudder.css")
)

(setf (ningle:route *app* "/css" :accept '("text/html" "text/xml"))
      #'(lambda (params)
          (declare (ignore params))
          (rudder-readfile)
        )
)

(setf (ningle:route *app* "/rudder" :accept '("text/html" "text/xml"))
      #'(lambda (params) (rudder-proc params))
)

(clack:clackup *app*)

; (uiop/run-program:run-program "open -a \"Safari.app\" http://localhost:5000/rudder" :output T)

