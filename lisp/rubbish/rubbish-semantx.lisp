;; rubbish-semantx.lisp

(in-package :rubbish)

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
    with tlids = nil
    for lid in (bodyof cid) do
      (setq me (map-to-semantx lid))
;; in the below, something better?
      (setq pe (peval me)) ;; not peval-id for checking e = (peval e). e should be before map-to-semantx. 
; if exist tlids, the clause is valid (cid ()() T) proof: (:semantx-valid (l1-1)) and cid in *vlist*, *clist*
; if exist flids, (cid vars () olids) (:semantx-partial flids)
; o.w., no new cid
      (cond
        ((equal me pe) (push lid olids))    ;; no evaluated
        ((null pe)     (push lid flids))    ;; false
        (t             (push lid tlids))    ;; valid
      )
    finally
    (return (values (reverse tlids) (reverse flids) (reverse olids)))
  )
)

(defun make-valid-clause (cid tlids flids olids)
  (let ((newcid (new-cid))) ;; no mgu, vars aren't changed. maybe too many vars
    (setcid newcid :REDUCED (varsof cid) (append flids olids) ())  ; :REDUCED is the name
    (setf (get newcid :VALID) T)
    (entry-proof newcid :REDUCED-BY-SEMANTIX () () tlids)     ; then here is the true lids.. 
    newcid
  )
)


;; ** newcid must has rename the lid by newcid, valid is not the case.
(defun make-clause-by-reduced (cid flids olids) ;; flids is not ()
  "new clause"
  (let ((newcid (new-cid)))
    (setcid newcid :REDUCED (varsof cid) (make-lids-from-lids newcid olids) ()) ;; when REDUCE
    (entry-proof newcid :REDUCED-BY-SEMANTIX () () flids)     ; then here is the falses
    newcid
  ) 
)

(defparameter *validlist* nil)

(defun reduce-by-semantx (cid)
  (let (tlids flids olids)
    (multiple-value-setq (tlids flids olids)(apply-semantx-id cid))
    (cond
      (tlids (push (make-valid-clause cid tlids flids olids) *validlist*) nil) ;; is this in *clist* *llist*?
      ((null flids) cid)
      (T (make-clause-by-reduced cid flids olids)) ;; flids is not ()
    )
  )
)

(defun isvalid (cid)
  (get cid :VALID)
)

 
