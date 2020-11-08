;rubbish-print.lisp

;; print-cluases show clauses of cids
(defun print-clauses (cids)
  (loop for cid in cids do
    (print-clause cid)
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
    ((null (varsof cid))
     (format t "~a: ~a () ~a~%" cid (nameof cid)(lit*of (bodyof cid)))
    )
    (t 
     (format t "~a: ~a ~a ~a~%" cid (nameof cid)(varsof cid)(lit*of (bodyof cid)))
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

(defun dump-clause (cid)
  (cond
    ((iscontradiction cid) (format t "~a CONTRADICTION : ~a=~%" cid (symbol-plist cid)))
    (t (format t "~a=~a~%" cid (symbol-plist cid))
       (dump-lits (bodyof cid)))
  )
)

(defun dump-lits (lids)
  (loop for lid in lids do
    (when (boundp lid) (format t " ~a ~a = ~a~%" lid (litof lid) (symbol-plist lid)))
  )
)


(defun dumpcs ()
  (dump-clauses *clist*)
)


