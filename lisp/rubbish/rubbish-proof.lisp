; rubbish-proof.lisp

(in-package :rubbish)

;; proof manager

;; find all contradictions
(defun lscova ()
  (loop with con = () with val = () 
    for cid in *clist* 
    when (and (iscontradiction cid)(not (isvalid cid))) do (push cid con)
    when (isvalid cid) do (push cid val)
    finally (return (list con val))
  )
)

;; rule = :reso, :merge, :rename
;; proof is (rule vars sigma parents)
;;  parents = (left::Lid . right::Lid)

(defun entry-proof (cid rule vars sigma conflicts)
  (setf (get cid :proof)  (list rule vars sigma conflicts))
)

(defun proofof (cid)
  (get cid :proof)
)

(defun ruleof (cid)
  (car (proofof cid))
)

(defun sigof (cid)
  (list (cadr (proofof cid)) (caddr (proofof cid)))
)

(defun rpairof (cid)
  (cadddr (proofof cid))
)

(defun truesof (cid)
  (cadddr (proofof cid))
)


(defun print-literal0 (lid &optional (ind 0)(out t))
  (format out "~a" (nspace ind))
  (print-literal lid out)
)

(defun print-clause0 (cid &optional (ind 0) (out t))
  (cond
    ((isvalid cid)
     (if (bodyof cid)
       (format out  "~a~a: ~a = ~a <VALID>~%" (nspace ind) cid (nameof cid)(lit*of (bodyof cid)))
       (format out  "~a~a: ~a = [] <VALID>~%" (nspace ind) cid (nameof cid))
     )
    )
    ((iscontradiction cid)
     (if (bodyof cid)
       (format out "~a~a: ~a = ~a~%" (nspace ind) cid (nameof cid)(lit*of (bodyof cid)))
       (format out "~a~a: ~a = []~%" (nspace ind) cid (nameof cid))
     )
    )
    (t
     (format out "~a~a: ~a ~a [~a]~%" (nspace ind) cid (nameof cid)(varsof cid)(lit*of (bodyof cid)))
    )
  )
)

(defun print-proof0 (cid &optional (ind 0) (out t))
  (let ()
    (print-clause0 cid ind out)
    (cond
      ((eq (ruleof cid) :resolution)
        (let* ((llid (car (rpairof cid)))(rlid (cadr (rpairof cid))))
          (cond 
            ((iscontradiction cid) 
               (format out "~a~a [] ~a : <~a:~a>~%" (nspace ind) cid (ruleof cid) llid rlid))
            ((car (proofof cid)) 
               (format out "~a~a ~a ~a : <~a:~a>~%" (nspace ind) cid (bodyof cid) (ruleof cid)  llid rlid))
            (t (format out "~ainput0 ~% ~a ~a~%" (nspace ind) cid (bodyof cid)) )
          )
          (let ()
            (print-literal0 llid (+ 2 ind) out)
            (if (null (plidof llid)) (format out "input1~%") (format out " in~%"))
            (print-proof0  (cidof llid) (+ 2 ind) out))
          (let () 
            (print-literal0 rlid (+ 2 ind) out)
            (if (null (plidof llid)) (format t "input2~%") (format out " in~%") )
            (print-proof0  (cidof rlid) (+ 2 ind) out))
        )
      )
      ((eq (ruleof cid) :REDUCED-BY-SEMANTIX)
        (let* ((pr (proofof cid))(flits (cadddr pr)))
          (cond
            ((iscontradiction cid) 
              (format out "~a~a ~a [] removed are..~a~%~a" (nspace ind) cid (ruleof cid) flits (nspace ind)))
            (t 
              (format out "~a~a ~a ~a removed are..~a~%~a" (nspace ind) cid (ruleof cid) (bodyof cid) flits (nspace ind)))
          )
          (loop for flid in flits do 
            (print-literal0 flid (+ 2 ind) out)
            (format out "~%")
            (print-proof0 (cidof flid) (+ 2 ind) out))
        )
      )
    )
  )
)

(defun print-proof (cid &optional (ind 0) (out t))
  (let ()
    (print-clause0 cid ind out)
    (cond
      ((eq (ruleof cid) :resolution)
        (let* ((llid (car (rpairof cid)))(rlid (cadr (rpairof cid))))
          (cond 
            ((iscontradiction cid) 
               (format out "~a~a [] ~a : <~a:~a>~%" (nspace ind) cid (ruleof cid) llid rlid))
            ((car (proofof cid)) 
               (format out "~a~a ~a ~a : <~a:~a>~%" (nspace ind) cid (bodyof cid) (ruleof cid)  llid rlid))
            (t (format out "~ainput ~a ~a~%" (nspace ind) cid (bodyof cid)) )
          )
          (let ()
            (print-literal0 llid (+ 2 ind) out)
            (if (null (plidof llid)) (format out "input") (format out " in"))
            (terpri out)
            (print-proof  (cidof llid) (+ 2 ind) out))
          (let () 
            (print-literal0 rlid (+ 2 ind) out)
            (if (null (plidof llid)) (format t "input") (format out " in") )
            (terpri out)
            (print-proof  (cidof rlid) (+ 2 ind) out))
        )
      )
      ((eq (ruleof cid) :REDUCED-BY-SEMANTIX)
        (let* ((pr (proofof cid))(flits (cadddr pr)))
          (cond
            ((iscontradiction cid) 
              (format out "~a~a ~a [] removed are..~a~%~a" (nspace ind) cid (ruleof cid) flits (nspace ind)))
            (t 
              (format out "~a~a ~a ~a removed are..~a~%~a" (nspace ind) cid (ruleof cid) (bodyof cid) flits (nspace ind)))
          )
          (loop for flid in flits do 
            (print-literal0 flid (+ 2 ind) out)
            (terpri out)
            (print-proof (cidof flid) (+ 2 ind) out))
        )
      )
    )
  )
)

;; list of proof
;; code of rule may not useful in some cases. keep this code for future.
(defun code-of-rule (code)
  (cond
    ((eq code :RESOLUTION) :RS)
    ((eq code :REDUCED-BY-SEMANTIX) :SX)
    (t code)
  )
)


(defun list-proof0 (cid)
  (cond
    ((ruleof cid) 
      (cons cid
        (cons (ruleof cid)
          (let* ((pr (proofof cid))(flits (cadddr pr)) )
            (loop for flid in flits collect 
              (list flid (list-proof0 (cidof flid)))
            )
          )
        )
      )
    )
    (t (list cid :input))
  )
)


(defun cids-proof (cid)
  (cond
    ((ruleof cid) 
      (append (list cid)
        (let* ((pr (proofof cid)) (flits (cadddr pr)) )
            (loop for flid in flits append
              (cids-proof (cidof flid)))
            )
          )
        )
    (t (list cid))
  )
)

(defun cids-of-proof (cid)
  (uniq (cids-proof cid))
)

;; depth of proof tree
;; estimation of proof0
(defun depth-lid (lid)
  (depth-cid (cidof lid))
)

;; input clause's depth is 0
(defun depth-cid (cid)
  (cond 
    ((eq :RESOLUTION (ruleof cid))(let ((pr (rpairof cid)))
       (1+ (max (depth-lid (car pr))(depth-lid (cadr pr))))))
    ((eq :REDUCED-BY-SEMANTIX (ruleof cid)) 
       (1+ (loop for lid in (nth 3 (proofof cid)) maximize (depth-lid lid))))
    (t 0)
  )
)

;; depth of a proof 
(defun depth-proof0 (cid)
  (1+ (depth-cid cid))
)

;; MORE PROOF METRICS 
(defun depth-of-proof (cid)
  (depth-proof0 cid)
)

(defun inclauses-of-proof (cid)
  (uniq (loop for lid in (pcode cid) collect (cidof lid)))
)

(defun inliterals-of-proof (cid)
  (pcode cid)
)

(defun preds-of-proof (cid)
  (uniq (loop for lid in (pcode 'c35) collect (psymoflid lid)))
)

;;;; invariant of clause in Σ

(defun invariantof (cid)
  (list 
    (list-mgu cid)
    (with-output-to-string (out) (print-clause0 cid 0 out))
  )
)

;; EXPERIMENTALS
;;; for p2code comparing
;;

;RUBBISH(142): (cadr (nth 3 snps))
;
;((L1-1 L2-1) (L2-1 L2-2))
;RUBBISH(143): (cadr (nth 7 snps))
;
;((L1-1 L2-1) (L10-1 L2-3) (L2-2 L3-1))
;RUBBISH(144): (cadr (nth 8 snps))
;
;((L1-1 L2-1) (L2-1 L2-2) (L2-3 L7-1))
;RUBBISH(139): (p2c-containp (cadr (nth 3 snps))(cadr (nth 3 snps)))
;
;T
;RUBBISH(140): (p2c-containp (cadr (nth 3 snps))(cadr (nth 7 snps)))
;
;NIL
;RUBBISH(141): (p2c-containp (cadr (nth 3 snps))(cadr (nth 8 snps)))
;
;T

(defun p2c-memberp (p1 c2)
  (member p1 c2 :test 'equal)  
)

(defun p2c-containp (c1 c2)
  (loop for p1 in c1 always
    (p2c-memberp p1 c2)
  )
)

(defun p2-table (p2cs)
  (loop for ps on p2cs collect
    (list (cadar ps) 
      (loop for p2 in (cdr ps) when (p2c-containp (cadar ps) (cadr p2)) collect (cadr p2))
    )
  )
)

(defun p2-xoss (p2cs)
  (loop for pl in p2cs collect
    (list pl
      (loop for pr in p2cs 
         when (p2c-containp pl pr) collect pr
      )
    )
  )
)


; (setq p2cs (analyze-p2code0 *clist*))
; (setq np2cs (loop for p2 in p2cs collect (list (length (cadr p2)) (cadr p2))))
; (setq snpcs (sort np2cs (lambda (x y) (< (car x)(car y)))))
; (p2-table (cdr snpcs))
; (setq p2c (loop for nc in p2cs when nc collect (cadr nc)))
; (p2-xoss p2c)

 


