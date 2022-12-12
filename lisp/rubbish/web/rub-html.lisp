;; interchange from rubbish/print to rudder/html
; too close now(2022/12/05)

(in-package :rubbish)

(load "html.lisp")

;;

(defun readpage()
  "<form action='/rudder' method='get'> <div><label>KQC PATH</label><input type='string' name='kqcpath'></div><div><input type='submit' name='op' value='readkqc'> <input type='reset' value='Cancel'> </form></div> "
)

(defun footer ()
  "<hr><div><form action='/rudder' method='get'> <div><label>GID or Left</label><input type='string' name='what1' ></br><label>Right</label> <input type='string' name='what2'></div> <input type='submit' name='op' value='gtrail'> <input type='submit' name='op' value='resolve'> <input type='submit' name='op' value='merge'> <input type='submit' name='op' value='clist'> <input type='submit' name='op' value='clist0'> <input type='submit' name='op' value='proof'> <input type='reset' value='Cancel'> </form></div> "
)

;;
(defun clause0 (c &optional (out t))
  (if (isvalid c)
    (format out "VALID ~a~a~%" c (bodyof c))
    (format out "~a=~a~%" c (bodyof c))
  )
)

(defun lify0 (s out) 
  (format out "<div>~a</div>" (clause0 s nil))
)

(defun lisfy0 (ss)
  (with-output-to-string (out)
    (loop for s in ss do (lify0 s out))
  )
)

(defun bpage (body)
  (:head-part "RUDDER" 
    (with-output-to-string (str)
      (format str"<h2>~a</h2><div>~a</div>~a" "clist0" (lisfy0 body) (footer)))
  )
)
 

(defun lify (s out)
  (format out "<div>~a</div>" (print-clause s nil))
)

(defun lisfy (ss )
  (with-output-to-string (out)
    (loop for s in ss do
      (lify s out)
    )
  )
)

(defun apage (body)
  (:head-part "RUDDER" 
    (with-output-to-string (str)
      (format str "<h2>~a</h2><div>~a</div>~a" "clist" (lisfy body) (footer)))
  )
)

(defun ppage (cid)
  (format nil "<h2>~a</h2><div><pre>~a</pre></div>~a" "PROOF"  (with-output-to-string (out) (print-proof0 cid 0 out)) (footer))
)

(defun rudder-undefined-command (opr)
  (:html  "undefined command" (format nil "<h1>~a is not supported</h1>~a~%" opr (footer)))
)

