;; rubbish-base.lisp
;; preload oneof rubbish-gen.lisp or rubbish-gen-noran.lisp

(in-package :rubbish)

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


;;; the following are resolv ??

;; basevar : var.1234.1222 => var
(defun basevar (v)
 (subseq (symbol-name v) 0 (position #\. (symbol-name v)))
)

;; basesof : vs => bvs s.t. base of each vars
(defun basesof (vs)
 (loop for v in vs
   collect (basevar v)
 )
)

;; newvar : v -> v.nnn
(defun newvar (v)
 ; (intern (string (rub-gensym (basevar v))) :rubbish )
  (intern (string (rub-gensym (format nil "~a." (basevar v)))) :rubbish)
)

;; for rename : vs <- nvs s.t. new vars of v in vs : p-not
; vs.nvs is the binding form

;; vs don't contain same var
(defun newvars (vs) 
 (loop for v in vs collect (newvar v))
)

;; LID ops
(defparameter  *maxcid* 0)
(defparameter *clist* ())
(defparameter *llist* ())

;; make a lid from cid and n'th of body
(defun make-lid (cid n)
  (let (lid)
    (setf lid (intern (format nil "L~a-~a" (rootof cid) n) :rubbish))
    (pushnew lid *llist*)
    lid
  )
)
;; Ln-m => n

(defun lpairof (lid)
  (let ((slid (string lid)))
    (list 
      (parse-integer (subseq slid 1 (position #\- slid)))
      (parse-integer (subseq slid (1+ (position #\- slid))))
    )
  )
)

;; the code commented out is for goodlooking pcode but slow
(defun lid> (l1 l2)
;  (let ((p1 (lpairof l1))(p2 (lpairof l2)))
;    (cond
;      ((> (car p1)(car p2)) t)
;      ((= (car p1)(car p2)) (> (cadr p1)(cadr p2)))
;      (t nil)
;    )
;  )
(string> (string l1)(string l2))
)

;; make lids for lits with cid
(defun make-lids(cid lits)
  (loop for lit in lits 
        as  lno from 1 to (length lits) collect
        (setlid (make-lid cid lno) cid nil lit)
  )
)
;; make-lids-from-lids for semantx
(defun make-lids-from-lids (cid lids)
  (loop for lid in lids 
        as  lno from 1 to (length lids) collect
        (setlid (make-lid cid lno) cid lid (litof lid))
  )
)

;;;;

; C10.xxx => 10
; L10-i.yyy i is lno
(defun setlid (lid cid plid lit)
  (setf (get lid :cid) cid)
  (set lid lit)
  (setf (get lid :plid) plid)

  ;; all lid has olid, the input lid has itself in olid
  ;; just plid of the input lid is null

  (if plid 
    (setf (get lid :olid) (get plid :olid))
    (setf (get lid :olid) lid)
  )
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

(defun plidof (lid)
  (get lid :plid)
)

(defun olidof (lid)
  (get lid :olid)
)


(defun traceplid (lid)
  (progn
    (format t "~a > " lid)
    (cond 
      ((null (plidof lid)) (format t "input~%"))
      (t (traceplid (plidof lid)))
    )
  )
)

(defun tracep(lid)
  (format t "~a:~a~%" lid (symbol-plist lid))
  (when (plidof lid) (tracep (plidof lid)))
)


;; CID ops
(defun cidfy (name) 
  (intern (format nil "C~a" name) :rubbish)
)

(defun make-cid (n)
  (let ((cid (cidfy n) )) 
    (add-cid n)
    (pushnew cid *clist*)
    cid
  )
)

(defun cnumof (cid)
  (let ((scid (string cid)))
    (parse-integer (subseq scid 1 ))
  )
)

;;;;
(defun add-cid (n)
;   (cond ((< n *maxcid*) (format t "name double ~a~%" n)))
   (setf *maxcid* (max *maxcid* n))
)

(defun new-cid ()
  (make-cid (incf *maxcid*))
)

(defun clearbase ()
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

(defun setcid (cid name vars body ovars)
; name may be number
; vars is var*
; body is lid*
  (setf (get cid :name) name)
  (setf (get cid :vars) vars)
  (setf (get cid :when-born) (incf *when-born*))
  (set cid body)
  (setf (get cid :ovars) ovars)
  cid
)

(defun make-clause (cexp)
  (let (cid ns (name (car cexp)) vars body)
    (if (listp name)
      (let () ;; no name
        (setq cid (new-cid))
        (setq name cid)
        (setq vars (car cexp)) 
        (setq ns (newvars vars))
        (setq body (cdr cexp)))
      (let () ;; has name
        (setq cid (make-cid name))
        (setq vars (cadr cexp)) 
        (setq ns (newvars vars))
        (setq body (cddr cexp)))
    )
    (pushnew cid *input-clauses*)
    (setcid cid name ns (make-lids cid (subsubp vars body ns)) ())
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

(defun when-born (cid)
  (get cid :when-born)
)

(defun lidof (cid i)
  (nth (- i 1) (bodyof cid))
)

(defun rawlits (lids)
 (loop for lid in lids collect
  (litof lid)
 )
)

(defun rawclause (cid)
  (cons
    (nameof cid) 
    (cons 
      (varsof cid)  
      (rawlits (bodyof cid))
    )
  )
)

(defun rawclause0 (cid)
  (cons
    (varsof cid)  
    (rawlits (bodyof cid))
  )
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
    ((eq 1 (length ns)) (nth (car ns) lids));; the return type differ from others... is it ok???
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

;; is contradiction
(defun iscontradiction (cid)
  (null (bodyof cid))
)


;;; Lsymbols
;; lsym and lid
(defun lsymof (lid)
  (let ((lit (litof lid)))
;    (cons (car lit)(cadr lit))
    (intern (format nil "~a~a" (car lit) (cadr lit)) :rubbish)
  )
)

(defun ptolsym (sign psym)
  (intern (format nil "~a~a" sign  psym   :rubbish))
)

;; lsym and oppo
(defun oppo (sign)
  (cond
    ((eq sign '-) '+)
    ((eq sign '+) '-)
  )
)

(defun soppo (sign)
  (cond
    ((string= sign "-") "+")
    ((string= sign "+") "-")
  )
)

(defun signof (lsym)
  (subseq lsym 0 1)
)

(defun psymof (lsym)
  (subseq lsym 1)
)

(defun oppolsymof (lsym)
  (intern (format nil "~a~a" (soppo (signof (string lsym))) (psymof (string lsym))) :rubbish)
)


;; gensym var 

;; (vrootof 'abc.233) => 'abc
(defun vrootof (var)
 (let (sv dotp)
   (setq sv (symbol-name var))
   (setq dotp (position #\. sv))
   (if (null dotp)
     (string var)
     (string (subseq sv 0 dotp))
   )
 )
)

;;;
; input literals

;;; is input literals?
(defun isinputlid (lid)
  (null (plidof lid))
)

;; select input literals 
(defun illist (llist)
 (loop for id in llist when (isinputlid id) collect id)
)

;;; is input clause?
(defun isinputcid (cid)
  (null (get cid :proof))
)

;;; checker well defined clauses
(defun isWFF-literal (lid)
  (or 
    (equal '+ (car (bodyof lid)))
    (equal '- (car (bodyof lid)))
  )
)

(defun check-literals (&optional (lids *llist*))
  (loop for lid in lids unless (iswff-literal lid) collect lid)
)

; list form of clauses
(defun exp-lid (lid)
  (eval lid)
)

(defun exp-body (body)
  (loop for lid in body collect 
    (exp-lid lid)
  )
)

(defun exp-cid (cid)
  (cons
    (nameof cid)
    (cons 
      (varsof cid)
      (exp-body (bodyof cid))
    )
  )
)

(defun exp-clist (&optional (cids *clist*))
  (loop for cid in cids collect 
    (exp-cid cid)
  )
)


;;;
(defun equal-lid (lid1 lid2)
  (equal (litof lid1) (litof lid2))
)


;;;
;;; interactive clause interface
;  (factisf '((() (+ P 1 a))(() (- P 3 a))) )
(defun factisf (facts)
  (prog1 
    (loop for f in facts collect
      (make-clause f)
    )
    (make-lsymlist *llist*)
  )
)

;; macro interface
;(factis (() (+ P 1 a))(() (- P 3 a)))
(defmacro factis (&rest facts)
  `(factisf ',facts)
)

