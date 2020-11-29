;; sample code for rubbish-kqcio.lisp

(load "load-rubbish.lisp")

(defparameter d3 (readekqc "kqc/datae003.kqc"))
(dump-clausex d3)


(readekqc "kqc/lover/love001.kqc")
(readekqc "kqc/fact/fact001.kqc")
(readekqc "kqc/data001.kqc")
(readekqc "kqc/data002.kqc")


(readekqc "kqc/chose001.kqc")
(readekqc "kqc/chose002.kqc")
(readekqc "kqc/data0001.kqc")
(readekqc "kqc/data001.kqc")
(readekqc "kqc/data001p.kqc")  ;; fail at eval last
(readekqc "kqc/data002.kqc")
(readekqc "kqc/datae003.kqc")
(readekqc "kqc/datae004.kqc")
(readekqc "kqc/flash001.kqc")


