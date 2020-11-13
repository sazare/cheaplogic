;; sample code for rubbish-kqcio.lisp

(load "load-rubbish.lisp")

(defparameter d3 (readekqc "kqc/datae003.kqc"))
(dump-clauses d3)

