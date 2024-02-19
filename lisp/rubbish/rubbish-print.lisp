;rubbish-print.lisp

(in-package :rubbish)

;; print-cluases show clauses of cids
(defun print-clauses (&optional (cids *clist*) (out t))
  (loop for cid in cids do
    (print-clause cid out)
  )
)

;; print clause list

(defun print-clausex (&optional (cs *clist*) (out t))
  (loop for c in cs do
    (if (isvalid c)
      (format out "VALID ~a~a~%" c (bodyof c))
      (format out "~a=~a~%" c (bodyof c))
    )
  )
)

(defun print-literal (lid &optional (out t))
  (cond 
    ((null (varsof (cidof lid))) (format out  "~a ().~a " lid (litof lid)))
    (t  (format out  "~a ~a.~a " lid (varsof (cidof lid)) (litof lid)))
  )
)

(defun print-literals (&optional (lids *llist*) (out t))
  (loop for lid in lids
    do
    (print-literal lid out)
    (format out "~%")
  )
)

(defun print-clause (cid &optional (out t))
  (cond 
    ((isvalid cid)
     (if (bodyof cid)
       (format out "~a: ~a = ~a <VALID>~%" cid (nameof cid)(lit*of (bodyof cid)))
       (format out "~a: ~a = [] <VALID>~%" cid (nameof cid))
     )
    )
    ((iscontradiction cid)
     (if (bodyof cid) 
       (format out "~a: ~a = ~a~%" cid (nameof cid)(lit*of (bodyof cid)))
       (format out "~a: ~a = []~%" cid (nameof cid))
     )
    )
    ((eq cid (nameof cid))
     (format out "~a: ~a [~a]~%" cid (varsof cid)(lit*of (bodyof cid)))
    )
    (t 
     (format out "~a: ~a ~a [~a]~%" cid (nameof cid)(varsof cid)(lit*of (bodyof cid)))
    )
  )
)
 
;; clausesof makes list of cids
(defun clausesof (&optional (cids *clist*))
  (loop for cid in cids collect
    (clauseof cid)
  )
)

(defun clauseof (cid)
  (list cid (nameof cid)(varsof cid)(lit*of (bodyof cid)))
)

;; dump show symbol-plist on lid, cid
(defun dump-clauses (&optional (cids *clist*)(out t))
  (loop for cid in cids do
    (dump-clause cid out)
  )
)


(defun dump-lits (&optional (lids *llist*)(out t))
  (loop for lid in lids do
    (when (boundp lid) (format out " ~a ~a = ~a~%" lid (litof lid) (symbol-plist lid)))
  )
)

(defun dump-clause (cid &optional (out t))
  (cond
    ((isvalid cid) (format out "~a VALID : ~a=~%" cid (symbol-plist cid)))
    ((iscontradiction cid) (format out "~a CONTRADICTION : ~a=~%" cid (symbol-plist cid)))
    (t (format out "~a=~a~%" cid (symbol-plist cid))
       (dump-lits (bodyof cid) out))
  )
)

;; convenient functions
(defun dumpcs (&optional (out t))
  (dump-clauses *clist* out)
)

;or 
(defun dump-clausex (&optional (cids *clist*) (out t))
  (dump-clauses *clist* out)
)

