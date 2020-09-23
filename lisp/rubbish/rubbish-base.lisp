;; rubbish-base.lisp
;; preload oneof rubbish-gen.lisp or rubbish-gen-noran.lisp

;; isterm ... may be use
(defun isterm (e)
  (cond 
    ((or (integerp e) (floatp e) (stringp e) (atom e)) T)  ;; really it is atom
    (t (and (atom (car e))(isterm* (cdr e))))
  )
)

(defun isterm* (e)
  (cond
    ((null e) T)
    ((and (isterm (car e)) (isterm* (cdr e))))
  )
)

;; LID ops
(defvar *maxcid* 0)
(defvar *clist* ())
(defvar *llist* ())


(defun make-lid (cid n)
  (let (lid)
    (setf lid (rub-gensym (format nil "L~a-~a." (rootof cid) n)))
    (push lid *llist*)
    lid
  )
)

(defun make-lids(cid lits)
  (loop for lit in lits 
        as  lno from 1 to (length lits) collect
    (setlid (make-lid cid lno) cid lit)
  )
)

;;;;

; C10.xxx => 10
; L10-i.yyy i is lno
(defun setlid (lid cid lit)
  (setf (get lid :cid) cid)
  (set lid lit)
  ;(setf (get lid :lit) lit)
  lid
)

(defun cidof (lid)
  (get lid :cid)
)

(defun litof (lid)
  (eval lid)
)

(defun lit*of (lid*)
  (loop for lid in lid* collect 
   (litof lid)
  )
)


;; CID ops

(defun make-cid (n)
  (let ((cid (rub-gensym (format nil "C~a." n))))
    (add-cid n)
    (push cid *clist*)
    cid
  )
)
;;;;
(defun add-cid (n)
   (cond ((eq n *maxcid*) (format t "name double ~a~%" n)))
   (setf *maxcid* (max *maxcid* n))
)

(defun new-cid ()
  (make-cid (incf *maxcid*))
)

(defun clearall ()
  (setf *maxcid* 0)
  (setf *clist* nil)
  (setf *llist* nil)
)
;;;;

;* (subseq "C10.xxx" 1 3)
;"10"
(defun rootof (cid)
 (let (scid dotp)
   (setq scid (symbol-name cid))
   (setq dotp (position #\. scid))
   (if (null dotp) 
     (string (subseq scid 1))
     (string (subseq scid 1 dotp))
   )
 )
)

(defun setcid (cid name vars body)
; name may be number
; vars is var*
; body is lid*
  (setf (get cid :name) name)
  (setf (get cid :vars) vars)
  (set cid body)
  cid
)

(defun make-clause (cexp)
  (let (cid)
    (setf cid (make-cid (car cexp)))
    (setcid cid (car cexp) (cadr cexp) (make-lids cid (cddr cexp)))
  )
)

(defun varsof (cid)
  (get cid :vars)
)

(defun bodyof (cid)
  (eval cid)
)

(defun subsof (cid)
  (get cid :subs)
)

(defun nameof (cid)
  (get cid :name)
)


(defun rawlits (lids)
 (loop for lid in lids collect
  (litof lid)
 )
)

(defun rawclause (cid)
 (list (nameof cid) (varsof cid) (subsof cid) (rawlits (bodyof cid)))
)

;;; primitive ops of basic data
;;; all lids of cids
(defun alllids (cids)
  (loop for cid in cids append (bodyof cid))
)

;;; choose lids of cid
;; when outof ns the lids are null
(defun lidsof (cid &rest ns)
  (let ((lids (bodyof cid)))
   (cond 
    ((null ns) lids)
    (t (choose ns lids))
   )
  )
)

;; choose selects elements at ns;; general
(defun choose (ns os)
 (loop for n in ns collect 
   (nth n os)
 )
)

;;; Lsymbols
;; lsymof
(defun lsymof (lid)
  (let ((lit (litof lid)))
    (cons (car lit)(cadr lit))
  )
)

;; oppo
(defun oppo (sign)
  (cond
    ((eq sign '-) '+)
    ((eq sign '+) '-))
)



;;; Graph level0
(defun push-gr0 (lid gr0)
  (push lid gr0)
)



