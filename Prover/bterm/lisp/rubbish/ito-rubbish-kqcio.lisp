;; ito for rubbish-kqcio.lisp

(myload "ito.lisp")
(load "load-rubbish-kqcio.lisp")

(defparameter chose001 (readkqc "kqc/chose001.kqc"))
(intend-equal "elements of kqc" 2 (length chose001))
(intend-equal "contents same?" '((1 (X Y) ((- P X (F Y)) (+ Q (G X Y)))) (2 (X) ((- P X (F X)) (+ Q (G X B))))) chose001)




