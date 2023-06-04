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
      ((eq (ruleof cid) :REDUCED-BY-SYNTAX)
        (let* ((pr (proofof cid))(rlid (cadr (rpairof cid)))(flits (cadddr pr)))
          (cond
            ((iscontradiction cid) 
              (format out "~a~a ~a [] removed are..~a~%~a" (nspace ind) cid rlid rlid (nspace ind)))
            (t 
              (format out "~a~a ~a ~a removed are..~a~%~a" (nspace ind) cid rlid  (bodyof cid) rlid (nspace ind)))
          )
          (let ()
            (if (null (plidof rlid)) (format out "input1~%") (format out " in~%"))
            (print-proof0 (cidof rlid) (+ 2 ind) out)
          )
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
      ((eq (ruleof cid) :REDUCED-BY-SYNTAX)
        (let* ((pr (proofof cid))(rlid (cadr (rpairof cid))) (flits (cadddr pr)))
          (cond
            ((iscontradiction cid) 
              (format out "~a~a ~a [] removed are..~a~%~a" (nspace ind) cid rlid rlid (nspace ind)))
            (t 
              (format out "~a~a ~a ~a removed are..~a~%~a" (nspace ind) cid rlid (bodyof cid) rlid (nspace ind)))
          )
          (let ()
            (print-proof (cidof rlid) (+ 2 ind) out)
          )
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
    ((eq code :REDUCED-BY-SEMANTIX) :SM)
    ((eq code :REDUCED-BY-SYNTAX) :SN)
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

(defun strip-p2c (p2c)
  (loop for p2 in p2c when (second p2) collect (second p2))
)

(defun p2c-memberp (p1 c2)
  (member p1 c2 :test 'equal)  
)

(defun p2c-containp (c1 c2)
  "c1's pair appears in c2. dont care the order."
  (loop for p1 in c1 always
    (p2c-memberp p1 c2)
  )
)


(defun headequal (c1 c2)
  "c1 appears in c2 leftside." 
  (loop for cl in c1 as cr in c2 always (equal cl cr))
)

;; p2cs is (strip-p2c p2cs)
(defun p2-table (p2cs)
  "check p2c-containp on x y. not y x. if p2cs is sorted with <, it check little to larger."
  (loop for ps on p2cs collect
    (list (first ps) 
      (loop for p2 in (cdr ps) when (p2c-containp (first ps) (first p2)) collect p2)
    )
  )
)

;; p2cs is (strip-p2c p2cs)
(defun p2-xoss (p2cs)
  (loop for pl in p2cs collect
    (cons pl
      (loop for pr in p2cs 
         when (p2c-containp pl pr) unless (equal pl pr) collect pr
      )
    )
  )
)

;; p2xp is better looking than p2-xoss
;(defun p2xp (lcl* &optional (out t))
;  (loop for cl* in lcl* do
;    (format out "~a~%" (first cl*))
;    (loop for ll in (second cl*) unless (equal (first cl*) ll) do
;      (format out "  ~a~%" ll)
;    )
;  )
;)
;; utility
;;;
;(defun sp2cs (p2cs)
;  "p2cs = (num list)..."
;  (let* (np2cs)
;    (setq np2cs (loop for p2 in p2cs when (second p2) collect (list (length (second p2)) (second p2))))
;    (sort (copy-list np2cs) '< :key 'first)
;  )
;)
;
;(defun sp2c (p2cs)
;  "p2cs = (num list)..."
;  (let (p2c)
;   (setq p2c (loop for nc in p2cs when (second nc) collect (second nc)))
;   (sort (copy-list p2c) '< :key 'length)
;  )
;)
;
;(defun cnext (code p2cs)
;  "cnext is a 1 longer than code in p2cs"
;  (let (next)
;    (setq next (loop for ps in p2cs 
;                when (and (equal (length ps) (1+ (length code) )) (headequal code ps))
;                collect ps))
;    next
;  )
;)
;
(defun n-ring (n np2c)
  (loop for x in np2c when (eq (length x) n) collect x)
)
;
;(defun p2-adjmap-level (nexts np2c)
;  (loop while nexts with nl = () do
;    (setq news (cnext (pop nexts) np2c))
;    (setq nl (append nl news))
;  finally
;    (return nl)
;  )
;)
;
;
;(defun p2-adjmap (np2c)
;  (let* ((roots (n-ring 1 np2c)) (nexts roots)(nl nexts)(alls nl))
;    (loop while nl do
;      (setq nl (p2-adjmap-level nl np2c))
;      (setq nexts (append nexts nl))
;      (setq alls (append alls nl))
;    finally
;      (return alls)
;    )
;  )
;)
;
;
;; weak version

(defun wnext (code p2cs)
  "wnext is a 1 longer than code in p2cs"
  (let (next)
    (setq next (loop for ps in p2cs 
                when (and (equal (length ps) (1+ (length code))) (p2c-containp code ps))
                collect ps))
    next
  )
)

(defun p2-wadjmap-level (nexts np2c)
  (let (news)
    (loop while nexts with nl = () do
      (setq news (wnext (pop nexts) np2c))
      (setq nl (append nl news))
    finally
      (return nl)
    )
  )
)
(defun p2-wadjmap (np2c)
  (let* ((roots (n-ring 1 np2c)) (nexts roots)(nl nexts)(alls nl))
    (loop while nl do
      (setq nl (p2-wadjmap-level nl np2c))
      (setq nexts (append nexts nl))
      (setq alls (append alls nl))
    finally
      (return alls)
    )
  )
)

;; new style 
; find p2code of p2c in allp2c(sccp2)
;; (find-next-p2codes  nil sccp2n)
(defun find-next-p2codes (p2c allp2c)
  "find all elements of next of p2c in allp2c"
  (loop for x in allp2c as y from 0 
    when (eq (length (car x)) (1+ (length p2c)))
    when (p2c-containp p2c (car x)) 
    collect x)
)

;; (find-next-p2c nil sccp2)
(defun find-next-p2c (p2c allp2c)
  "next level p2codes of p2c in allp2c"
  (loop for x in allp2c as y from 0 
    when (eq (length (car x)) (1+ (length p2c)))
    when (p2c-containp p2c (car x)) 
    collect (car x))
)

;;; same p2c in other arrow7s targets
;;; then many identical source p2c in map.

(defun make-nnmap (sccp2)
  (let* ((pool '(nil)) level nnmap checked)
    (loop while pool do
      (loop for x in pool with targ = nil when (not (member x checked)) do
        (pushnew x checked)
        (setq targ (find-next-p2c x sccp2))
        (setq level (append level targ))
        (setq nnmap (cons (list x targ) nnmap))
      )
      (setq pool level)
      (setq level nil)
    )
    (reverse nnmap)
  )
)

;; transfer nnmap(1:n) to adj map(1:1).
(defun nnmap-to-adjmap (map)
  (loop for n-ns in map append
    (loop with s = (first n-ns) for n in (second n-ns) collect (list s n))
  )
)

;; find number of p2c with assoc in sccp2n(from numbering-sccp2)
(defun p2c-n (p2c sccp2n)
  (third (assoc p2c sccp2n :test 'equal))
)

(defun n-p2c (n sccp2n)
  (loop for x in sccp2n when (equal n (third x)) do (return (first x)))
)

(defun p2c-n* (p2c* sccp2n)
  (loop for p2c in p2c* collect
    (p2c-n p2c sccp2n)
  )
)

(defun arrow-in-number (arrow sccp2n)
  (list 
    (p2c-n (first arrow) sccp2n) 
    (p2c-n* (second arrow) sccp2n)
  )
)

(defun map-in-number (amap sccp2n)
  (sort (loop for arrow in amap collect (arrow-in-number arrow sccp2n)) '< :key 'car)
)

;; numbering sccp2 rigthside
(defun numbering-sccp2 (sccp2)
  (loop for x in sccp2 as n from 0 collect 
    (append x (list n ))
  )
)


;; p2toc 
(defun p2toc (p2)
  "find cid from p2code"
  (loop for x in *clist* when (equal p2 (p2code x)) collect x)
)

