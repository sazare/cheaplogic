;; interchange from rubbish/print to rudder/html
; too close now(2022/12/05)

(in-package :rubbish)

(load "html.lisp")

;;

(defun readpage(paramlist)
  (format nil "<form action='/rudder' method='get'> <div>PARAMETERS~%<pre>~a</pre></div> <div><label>KQC PATH</label><input type='string' name='kqcpath'></div><div><input type='submit' name='op' value='readkqc'> <input type='reset' value='Cancel'></div> </form>" paramlist)
)

(defun footer ()
  "<hr><form action='/rudder' method='get'> 
<div><label width='200px'>GID or Left</label><input type='string' name='what1' ></br><label width='200px'>Right</label> <input type='string' width='300' name='what2'></div> <div><input type='submit' width='200px'  name='op' value='gtrail'> <input type='submit' name='op' value='resolve'> <input type='submit' name='op' value='merge'> <input type='submit' name='op' value='clist'> <input type='submit' name='op' value='clist0'> <input type='submit' name='op' value='proof'> <br> <input type='submit' name='op' value='invariant'> <input type='reset' value='Cancel'></div> </form> "
)


(defun dpage (title body)
  (:head-part "RUDDER" 
    (format nil "<h2>~a</h2><div><pre>~a</pre></div>~a" title body (footer)))
)

(defun rudder-undefined-command (opr)
  (:html  "undefined command" (format nil "<h1>~a is not supported</h1>~a~%" opr (footer)))
)

