;;; common lispの実験か?
;; simple session

;(load "load-rubbish.lisp")
(require :gtrail)
(in-package :rubbish)

(defparameter ccc (readafile "kqc/data001.kqc"))


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

(defun new-lid ()
  (incf *maxlid*)
)

(defun add-cid (n)
   (setf *maxcid* (max *maxcid* n))
)

(defun new-cid ()
  (incf *maxcid*)
)

(defun clearall ()
  (setf *clist* nil)
  (setf *llist* nil)
)
    
(defun new-lit (lit cid); initially no prevlid
  (let ((lid (new-lid)))
    (push (list  lid :lit lit :cid cid :plid nil) *llist*)
    lid)
)

(defun make-lit (lit cid plid);prevlid must
  (let ((lid (new-lid)))
    (push (list  lid :lit lit :cid cid :plid :plid) *llist*)
    lid)
)

(setf alid (new-lit '(- Q x y) 10))
(setf nlid (make-lit '(- Q x y) 10 1))

(defun make-cls (cid vars body)
  (push (list cid :vars vars :body body) *clist*)
)
(make-cls nlid '(x y) ())

;; alist -> assoc for getf, plist -> getf 
(defun make-body (cid nlid)
  (push cid (getf (cdr (assoc cid *clist*)) :body))
)

(make-body nlid (list nlid))

(defun entry-new-cls (cls)
  (let ((cid (car cls))(vars (cadr cls))(body (cddr cls)))
    (make-cls (add-cid cid) vars (loop for lit in body collect (new-lit lit cid)))
  )
)

(defun entry-resot (vars body) ;; resot is temporaly form of a clause
  (make-cls ((new-cid)  vars (loop for lit in body collect (new-lit lit cid))))
)

;;; how can i make- body 
;(getf (cdr (assoc 10 *clist*)) :body)
;(5)
;; make- a lid to body of 10
;(push 6 (getf (cdr (assoc 10 *clist*)) :body))
;(6 5)
;*clist*
;((10 :VARS (X Y) :BODY (6 5)) (1 :VARS (X Y) :BODY (2 3))
; (2 :VARS NIL :BODY (4)))

;(make-lit '(+ P x y) 10)
;(make-lit '(+ Q x) 11)
;(make-lit '(- R y) 12)
;(make-cls 5 '(x y) '(10 11 12))


(clearall)  ;; ok
(entry-new-cls '(1 (x y) (+ P x y)(- Q x)(+ R y)))


