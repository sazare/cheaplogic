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



;;; from here, alist version
;; こういうことをするのか?
; assume lll is a list of all lids
(setf *slidlist* (map 'list #'string lll)) ;; stringify

(defun findid (id idlist sidlist)
  (loop named findsid 
    for sid in sidlist as ssm in idlist do
     (when (equal id sid) (return-from findsid ssm))
  )
)

(findid "L1-1.418" lll *slidlist*) ;; (#:L1-1.418)

(eq (car lll) (findid "L1-1.418" lll *slidlist*)) ;; is T ok


;; in this way, when make a resolvent, i should add it's id to *lidlist* with string of it to *slidlist*
;; seems time consuming...


;; this seems very time consuming... what i worked on efficiency on unification...

; (find "A" '("B" "A") :test 'equal)
;; this is not symbol but the string



 (defvar ccc (readskqc "((1 (x) (+ P x))(2 () (- P a)))"))
;CCC
ccc
;(#:C1.417 #:C2.419)
(print-clauses ccc)
;C1.417: 1 (X) ((+ P X))
;C2.419: 2 () ((- P A))
;NIL
(dump-clauses ccc)
;(BODY (L1-1.418) VARS (X) NAME 1)
; L1-1.418 (LIT (+ P X) CID C1.417)
;(BODY (L2-1.420) VARS NIL NAME 2)
; L2-1.420 (LIT (- P A) CID C2.419)
;NIL
(setq l11 (lidsof (car ccc) 0))
;(#:L1-1.418)
(setq l21 (lidsof (cadr ccc) 0))
;(#:L2-1.420)


