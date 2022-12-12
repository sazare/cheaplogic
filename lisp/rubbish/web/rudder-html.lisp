(in-package :rubbish)

(defun clause0 (c &optional (out t))
  (if (isvalid c)
    (format out "VALID ~a~a~%" c (bodyof c))
    (format out "~a=~a~%" c (bodyof c))
  )
)

(defun lify0 (s)
  (format nil "<div>~a</div>" (clause0 s nil))
)

(defun lisfy0 (ss)
  (let ((lis ""))
    (loop for s in ss do
      (setq lis (format nil "~a~a" lis (lify0 s)))
    )
  lis)
)

(defun bpage (out body)
  (format out 
    "<html><head><title>RUDDER</title></head>~%<body><h2>list test</h2><div>~a</div></body></html>" 
    (lisfy0 body))
)

(defun conpage ()
"<form action="/go" method="get"> <input type="hidden" name="op" value="resolve"></br> <div><label>Left:</label><input type="string" name="llid" value="L"></br></div> <div><label>Right:</label><input type="string" name="rlid" value="L"></br></div> <input type="submit" value="Confirm"></br> <input type="reset" value="Cancel"> </form>
"


