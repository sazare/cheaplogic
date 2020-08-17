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

(defparameter c8 (nth 7 ccc))
(defparameter c9 (nth 8 ccc))
(lidsof c8)
(setq l81 (car (lidsof c8 0)))
(setq l91 (car (lidsof c9 0)))
(remof l81)
(setq r1 (resolve-id l81 l91))

r1
;((A B Z) (X Y Z) (#:L8-2.435 #:L8-3.436))
;is (sig vars body)

(lidsof c8)
;(#:L8-1.434 #:L8-2.435 #:L8-3.436)
(cadr r1)
;(#:L8-2.435 #:L8-3.436)
(litof (caadr r1))
;(+ Q Y Z)
(litof (cadadr r1))
;(- P Z X)

;このrについての問題
; 1. (cadr r)はlidのlistだがそのidは親のidなのでつけかえが必要
; 2. rのcidは作っていないので、作るときその関連付けがひつよう
; 3. varsの整理が必要
; 4. lidにsubsubpしてもliteralはかわっていない。

;(subsubp vs exp sig)



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


(defparameter bb '(
 ((P a) (1 2)(3))
 ((P b) (4)(5 6))
 ((P x) (7 8)(9))
 ))


;(assoc '(P b) bb) ;; cant hit

(assoc '(P b) bb :test #'equal)
;((P B) (4) (5 6))


