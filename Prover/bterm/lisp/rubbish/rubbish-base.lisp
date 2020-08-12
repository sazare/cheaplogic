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
(defun make-lid (cid n)
  (let (lid)
    (setq lid (format nil "L~a-~a." (rootof cid) n))
    (rub-gensym lid)
  )
)

(defun make-lids(cid lits)
  (loop for lit in lits 
        as  lno from 1 to (length lits) collect
    (setlid (make-lid cid lno) cid lit)
  )
)

; C10.xxx => 10
; L10-i.yyy i is lno
(defun setlid (lid cid lit)
  (setf (get lid :cid) cid)
  (setf (get lid :lit) lit)
  lid
)

(defun cidof (lid)
  (get lid :cid)
)

(defun litof (lid)
  (get lid :lit)
)


;; CID ops

(defun make-cid (n)
  (let ((cid (format nil "C~a." n)))
  (rub-gensym cid)
  )
)

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
  (setf (get cid :body) body)
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
  (get cid :body)
)

(defun subsof (cid)
  (get cid :subs)
)

(defun nameof (cid)
  (get cid :name)
)


