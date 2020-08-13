;rubbish-print.lisp

;; print-cluases show clauses of cids
(defun print-clauses (cids)
  (loop for cid in cids do
    (print-clause cid)
  )
)

(defun print-clause (cid)
  (cond 
    ((null (varsof cid))
     (format t "~a: ~a () ~a~%" cid (nameof cid)(litsof (bodyof cid)))
    )
    (t 
     (format t "~a: ~a ~a ~a~%" cid (nameof cid)(varsof cid)(litsof (bodyof cid)))
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
  (list cid (nameof cid)(varsof cid)(litsof (bodyof cid)))
)

(defun litsof (lids)
  (loop for lid in lids collect
    (litof lid)
  )
)
   
;; dump show symbol-plist on lid, cid
(defun dump-clauses (cids)
  (loop for cid in cids do
    (dump-clause cid)
  )
)

(defun dump-clause (cid)
  (format t "~a~%" (symbol-plist cid))
  (dump-lits (bodyof cid))
)

(defun dump-lits (lids)
  (loop for lid in lids do
    (format t " ~a~%" (symbol-plist lid))
  )
)



