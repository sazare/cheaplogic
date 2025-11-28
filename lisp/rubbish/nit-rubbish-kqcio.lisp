;; ito for rubbish-kqcio.lisp

(load "load-rubbish-kqcio.lisp")

(defparameter chose001 (readafile "kqc/chose001.kqc"))
(ito:intend-equal "elements of kqc" 2 (length chose001))
(ito:intend-equal "kqc contents same?" '((1 (X Y) (- P X (F Y)) (+ Q (G X Y))) (2 (X) (- P X (F X)) (+ Q (G X B)))) chose001)
;(defparameter cchose001 (readkqc "kqc/chose001.kqc"))


(defparameter schose001 (readastring "((1 (X Y) (- P X (F Y)) (+ Q (G X Y))) (2 (X) (- P X (F X)) (+ Q (G X B))))"))
(ito:intend-equal "skqc contents same?" '((1 (X Y) (- P X (F Y)) (+ Q (G X Y))) (2 (X) (- P X (F X)) (+ Q (G X B)))) schose001)

(defparameter schose001a (readskqc "((1 (W Y) (- P (F Y) W) (+ Q (G W Y))) (2 (X) (+ P X (F X)) (+ Q (G X B))))"))



