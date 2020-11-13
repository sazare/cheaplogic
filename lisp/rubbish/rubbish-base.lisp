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
 ; (intern (string (rub-gensym (basevar v))))
  (intern (string (rub-gensym (format nil "~a." (basevar v)))))
)

;; for rename : vs <- nvs s.t. new vars of v in vs : p-not
; vs.nvs is the binding form

;; vs don't contain same var
(defun newvars (vs) 
 (loop for v in vs collect (newvar v))
)

;; LID ops
(defvar *maxcid* 0)
(defvar *clist* ())
(defvar *llist* ())

;; make a lid from cid and n'th of body
(defun make-lid (cid n)
  (let (lid)
    (setf lid (intern (format nil "L~a-~a" (rootof cid) n)))
    (pushnew lid *llist*)
    lid
  )
)

;; make lids for lits with cid
(defun make-lids(cid lits)
  (loop for lit in lits 
        as  lno from 1 to (length lits) collect
        (setlid (make-lid cid lno) cid nil lit)
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

  (if (get plid :plid) 
    (setf (get lid :olid) (get plid :olid) )
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

(defun make-cid (n)
  (let ((cid (intern (format nil "C~a" n))))
    (add-cid n)
    (pushnew cid *clist*)
    cid
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
  (let (cid ns (name (car cexp)) (vars (cadr cexp)) (body (cddr cexp)))
    (setf cid (make-cid name))
    (setf ns (newvars vars))
    (setcid cid name ns (make-lids cid (subsubp vars body ns)))
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

;; pickup a n'th literal from cid
(defun pickl (n cid)
  (nth n (bodyof cid))
)

;; is contradiction
(defun iscontradiction (cid)
  (null (bodyof cid))
)


;;; Lsymbols
;; lsymof
(defun lsymof (lid)
  (let ((lit (litof lid)))
;    (cons (car lit)(cadr lit))
    (intern (format nil "~a~a" (car lit) (cadr lit)))
  )
)

;; oppo
(defun oppo (sign)
  (cond
    ((eq sign '-) '+)
    ((eq sign '+) '-))
)

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

