;rubbish-print.lisp

(in-package :rubbish)

;; print-cluases show clauses of cids
(defun print-clauses (cids)
  (loop for cid in cids do
    (print-clause cid)
  )
)

;; print clause list

(defun print-clausex (cs)
  (loop for c in cs do
    (if (isvalid c)
      (format t "VALID ~a~a~%" c (bodyof c))
      (format t "~a=~a~%" c (bodyof c))
    )
  )
)

(defun print-literal (lid)
  (cond 
    ((null (varsof (cidof lid))) (format t "~a ().~a " lid (litof lid)))
    (t  (format t "~a ~a.~a " lid (varsof (cidof lid)) (litof lid)))
  )
)

(defun print-literals (lids)
  (loop for lid in lids
    do
    (print-literal lid)
    (format t "~%")
  )
)

(defun print-clause (cid)
  (cond 
    ((isvalid cid)
     (if (bodyof cid)
       (format t "~a: ~a = ~a <VALID>~%" cid (nameof cid)(lit*of (bodyof cid)))
       (format t "~a: ~a = [] <VALID>~%" cid (nameof cid))
     )
    )
    ((iscontradiction cid)
     (if (bodyof cid) 
       (format t "~a: ~a = ~a~%" cid (nameof cid)(lit*of (bodyof cid)))
       (format t "~a: ~a = []~%" cid (nameof cid))
     )
    )
    (t 
     (format t "~a: ~a ~a [~a]~%" cid (nameof cid)(varsof cid)(lit*of (bodyof cid)))
    )
  )
)
 
;; clausesof makes list of cids
(defun clausesof (cids)
  (loop for cid in cids collect
    (clauseof cid)
  )
)

(defun clauseof (cid)
  (list cid (nameof cid)(varsof cid)(lit*of (bodyof cid)))
)

;; dump show symbol-plist on lid, cid
(defun dump-clauses (cids)
  (loop for cid in cids do
    (dump-clause cid)
  )
)


(defun dump-lits (lids)
  (loop for lid in lids do
    (when (boundp lid) (format t " ~a ~a = ~a~%" lid (litof lid) (symbol-plist lid)))
  )
)

(defun dump-clause (cid)
  (cond
    ((isvalid cid) (format t "~a VALID : ~a=~%" cid (symbol-plist cid)))
    ((iscontradiction cid) (format t "~a CONTRADICTION : ~a=~%" cid (symbol-plist cid)))
    (t (format t "~a=~a~%" cid (symbol-plist cid))
       (dump-lits (bodyof cid)))
  )
)

;; convenient functions
(defun dumpcs ()
  (dump-clauses *clist*)
)

;or 
(defun dump-clausex (&rest cids)
  (if (null cids) 
     (dump-clauses *clist*)
     (dump-clauses (car cids))
  )
)

