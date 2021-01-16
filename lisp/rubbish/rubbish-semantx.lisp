;; rubbish-semantx.lisp
;; peval => peval-id => apply-semantx

(defun map-to-semantx (lid)
  (let ((lit (litof lid)))
    (cond 
      ((eq '+ (car lit)) (cdr lit))
      ((eq '- (car lit)) (list 'not (cdr lit)))
    )
  )
)

(defun peval-id (lid)
  ; +/- to id/not
  (peval (map-to-semantx lid))
)

;; make clause 
;;; property
;;; binding
;;; lsym if required

;; make a proof step


(defun apply-semantx-id (cid)
  (loop 
    with me = nil
    with pe = nil
    with olids = nil
    with flids = nil
    with vlids = nil
    for lid in (bodyof cid) do
      (setq me (map-to-semantx lid))
;; in the below, something better?
      (setq pe (peval me)) ;; not peval-id for checking e = (peval e). e should be before map-to-semantx. 
; if exist vlids, the clause is valid (cid ()() T) proof: (:semantx-valid (l1-1)) and cid in *vlist*, *clist*
; if exist flids, (cid vars () olids) (:semantx-partial flids)
; o.w., no new cid
      (cond
        ((equal me pe) (push lid olids))    ;; no evaluated
        ((null pe)     (push lid flids))    ;; false
        (t             (push lid vlids))    ;; valid
      )
    finally
    (return (values (reverse vlids) (reverse flids) (reverse olids)))
  )
)

(defun make-valid-clause (cid vlids)
  (let ((newcid (new-cid)))
    (list (list newcid cid () () T) (make-proof newcid cid vlids))
  )
)

(defun make-clause-by-semantx (cid flids olids) ;; flids is not ()
  (let ((newcid (new-cid)))
    (list (make-clause newcid olids) (make-proof newcid cid flids))
  ) 
)

(defun reduct-semantx (cid)
  (let (vlids flids olids)
    (multiple-values-setq (vlids flids olids)(apply-semantx-id cid))
    (cond
      (vlids (make-valid-clause cid vlids))
      ((null flids) cid)
      (T (make-clause-by-semantx cid flids olids)) ;; flids is not ()
    )
  )
)


 
  
