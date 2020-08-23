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

;; 0.5th order prover
(defparameter bb '(
 ((P a) (1 2)(3))
 ((P b) (4)(5 6))
 ((P x) (7 8)(9))
 ))


;(assoc '(P b) bb) ;; cant hit

(assoc '(P b) bb :test #'equal)
;((P B) (4) (5 6))


;;;;; case make +P and -P, push lids the value of them

(setf spq (format nil "~a~a" :+ 'Q))
(setf snq (format nil "~a~a" :- 'Q))

(setf pq (make-symbol spq))
(setf nq (make-symbol snq))

(set pq ())
(set nq ())


(defun slsym (lsym)
 (make-symbol (format nil "~a~a" (car lsym)(cdr lsym)))
)
(set (slsym (lsymof (car (lidsof c8 1)))) ())

;(defmacro pushlid (lid lsym)
; `(set ,lsym (cons ,lid ,(eval ,lsym)))
;)
;(pushlid (car (lidsof c8 1)) (slsym (lsymof (car (lidsof c8 1)))))
;(pushlid (car (lidsof c8 2)) (slsym (lsymof (car (lidsof c8 1)))))


;; sybols equality
;* (equal pq (slsym (lsymof (car (lidsof c8 1)))) )
;NIL
;* pq
;#:+Q
;* (slsym (lsymof (car (lidsof c8 1)))) 
;#:+Q

(equal (string pq) (string (slsym (lsymof (car (lidsof c8 1))))))

; this is T. but not in symbol world...

;; ref
;(lidsof c8 2)
;(#:L8-3.436)
;* (litof (car (lidsof c8 2)))
;(- P Z X)
;* (litof (car (lidsof c8 0)))
;(- R X Y)
;* (litof (car (lidsof c8 1)))
;(+ Q Y Z)
;* (lsymof (car (lidsof c8 1)))
;(+ . Q)

(setf oppos '(P (()()) Q (()()) R(()())))
(setf qpn (getf oppos 'Q))
(push 'L10 (car qpn))
(push 'L11 (car qpn))
(car qpn)
(push 'L12 (cadr qpn))
qpn
oppos
;; these looks work...  


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


;;;; case number id 
;sample clitst
(defvar *clist* '(
  (1 . (:vars (x y) :body (2 3)))
  (2 . (:vars () :body (4)))
  )
)

(defvar *llist* '(
  (2 . (:lit (+ P x y) :cid 1))
  (3 . (:lit (- Q x) :cid 1))
  (4 . (:lit (+ Q a) :cid 2))
  )
)

*clist*
;((1 :VARS (X Y) :BODY (2 3)) (2 :VARS NIL :BODY (4)))
*llist*
;((2 :LIT (+ P X Y) :CID 1) (3 :LIT (- Q X) :CID 1) (4 :LIT (+ Q A) :CID 2))
(assoc 2 *clist*)
;(2 :VARS NIL :BODY (4))
(assoc 1 *clist*)
;(1 :VARS (X Y) :BODY (2 3))
(getf (cdr (assoc 1 *clist*)) :vars)
;(X Y)
(getf (cdr (assoc 1 *clist*)) :body)
;(2 3)
(getf (cdr (assoc 2 *llist*)) :lit)
;(+ P X Y)
(getf (cdr (assoc 2 *llist*)) :cid)
;1


;; memo for number id
;; then symbol-plist dontwork...
(defvar *maxlid* 0)
(defvar *maxcid* 0)

(defun makelid ()
  (incf *maxlid*)
)

(defun makecid ()
  (incf *maxcid*)
)


(defun addlit (lit cid);prevlid
  (let ((lid (makelid)))
    (push (list  lid :lit lit :cid cid) *llist*)
    lid)
)

(setf nlid (addlit '(- Q x y) 10))

(defun addcls (cid vars body)
  (push (list cid :vars vars :body body) *clist*)
)

(addcls nlid '(x y) ())

(defun addbody (cid nlid)
  (push cid (getf (getf *clist* cid) :body))
)


(addbody nlid (list nlid))

;;; how can i add body 
(getf (cdr (assoc 10 *clist*)) :body)
;(5)
;; add a lid to body of 10
(push 6 (getf (cdr (assoc 10 *clist*)) :body))
;(6 5)
*clist*
;((10 :VARS (X Y) :BODY (6 5)) (1 :VARS (X Y) :BODY (2 3))
 (2 :VARS NIL :BODY (4)))
 

