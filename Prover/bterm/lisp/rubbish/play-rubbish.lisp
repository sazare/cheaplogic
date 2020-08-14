;; simple session

(load "load-rubbish.lisp")
(defparameter ccc (readkqc "kqc/data001.kqc"))
(print-clauses ccc)
(dump-clauses ccc)
(defparameter lll (alllids ccc))

(lidsof  (cadr ccc) 0)

(defparameter c7 (nth 6 ccc))

(lidsof c7)
(lidsof c7 0)
(lidsof c7 1)
(lidsof c7 2)
(defparameter l6.02 (lidsof c7 0 2))


(loop for lid in lll collect (cons lid (lsymof lid)))
;((#:L1-1.418 - . Q) (#:L2-1.420 - . Q) (#:L3-1.422 + . P) (#:L4-1.424 + . P)
; (#:L5-1.426 + . R) (#:L6-1.428 + . R) (#:L7-1.430 - . R) (#:L7-2.431 + . Q)
; (#:L7-3.432 - . P) (#:L10-1.434 - . P) (#:L10-2.435 + . Q) (#:L10-3.436 - . R))


;alist
(setq aa '(
 (P ((a b)(x b))((x y)))
 (Q ((x))((a)(b))))
)

(assoc 'P aa)
;(P ((A B) (X B)) ((X Y)))
 
(assoc 'Q aa)
;(Q ((X)) ((A) (B)))

(cadr (assoc 'P aa))
(caddr (assoc 'P aa))


