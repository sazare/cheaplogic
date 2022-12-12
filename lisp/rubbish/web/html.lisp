;; pure html operation

;; DON'T WORK 
(in-package :rubbish)

;(string-map '(aa bb cc) "<li>~a</li>")
;(string-map '(aa bb cc) "<p>~a</p>")
;(string-map '(100 1000 50) "<p>~a</p>")
;(string-map '("aa" "bbb" "cc") "<li>~a</li>")
;(string-map '("aa" "bbb" "cc") "<ol>~a</ol>")
;(string-map '(\"aa\" \"bbb\" \"cc\") "<ol>~a</ol>")

(defun string-map (ss fmt)
  (with-output-to-string (r) 
    (loop for s in ss do (format r fmt s))
  )
)

;;(defun seqence (ss fn)
;;  (loop for s in ss with r = "" do
;;    (setq r (format nil "~a~a" r (apply fn (list s))))
;;    finally (return r)
;;  )
;;)

;(defun lify (c)
;  (format nil "<li>~a</li>" c)
;)

(defun divfy (&rest ss)
  (format nil "<div>~a</div>" ss)
)

;(defmacro :li (s)
;  `(format nil "<li>~a</li>" ,s)
;)
  
(defmacro :div (ss)
  `(format nil "<div>~a</div>" ,ss)
)

; this is good or not?1
;  (divfy (seqence '("abab" "cccc") 'lify)


(defmacro :li (&rest cs)
  `(format nil "~{<li>~a</li> ~}" ',cs)
)

; above probrem: <div><li>aaa</><li>bbb</><li>ccc</></>

; recipe

; string from format directly
; (with-output-to-string (out) (format out "<li>~a</li>" "data"))

; from recipe p83 "3-2 Reading CSV Data"
; string of list
; (format nil "~{~a~~}" '("abc" "def" "ghi"))
; string of comma in list
; (format nil "~{~a~^, ~}" '("abc" "def" "ghi"))

(defun formfy (action method body)
  (format nil "<form action=\"~a\" method=\"~a\">~a</form>" action method body)
)

;"<!DOCTYPE html><head><meta charset='utf-8'><title>hello</title></head><body><div>23</div></body></html>"

(defun :head-part (title body)
  (format nil "<!DOCTYPE html><head><meta charset='utf-8'> <link rel='stylesheet' href='css/rudder.css'/> <title>~a</title></head><body>~a</body></html>" title body)
)

(defun :html (title body)
  (:head-part title body)
)

