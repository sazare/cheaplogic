;;  rubbish-prover-exhaustive.lisp

(in-package :rubbish)

; exhaustive-prover

;(defun exh-prover (clist))
; make a pnlist

; make the lllist
(defun make-lidlist(clist)
  (loop for cid in clist append
    (bodyof cid)
  )
)

;
(defun getlllist (lsym lids)
  (loop for lid in lids when (eq lsym (lsymof lid)) collect lid)
)

; make-lnplist is another implementation of make-nplist
(defun make-lnplist (clist)
  (let (lidlist psymlist)
    (setq lidlist (make-lidlist clist))
    (setq psymlist (make-psymlist lidlist))

    (loop for psym in psymlist collect
       (let ((pl (ptolsym '+ psym)) (nl (ptolsym '- psym)))
         (list psym (getlllist pl lidlist) (getlllist nl lidlist) )
       )
    )
  )
)


; make the llmap
;; llmap has all combination of llpair

; loop for an entry of llmap resolve the paire repeatly
;; ? factoring or resolution combinations are ok??
;;; the timing of factoring is not clear!!

; exhaustive-prover in a ss

(defun exh-prover-on-aset (llmap)
; do 1:1 pair 

;; if n:n, it cause combinations of R

;; if n:n, It may be acomplished with F.

;; if not n:n, then factoring must. complicated , think tomorrow.


)

; find a lid in ssi whose olid is ilid
;ex (find-lid-in-clist 'L1-2 '(C8 C9))
(defun find-lid-in-clist (ilid clist)
  (loop for lid in (make-lidlist clist) when (member ilid (olidof lid))
    collect lid
  )
)

;; find-lid-in-clist = clidof
;(defun find-lid-in-clist (ilid clist)
;  "I find the lid whose olid is ilid but not equal."
;  (loop for cid in clist append
;    (loop for lid in (bodyof cid) when (and (not (eq (olidof lid) lid)) (eq (olidof lid) ilid))
;      append (list lid)
;    )
;  )
;)

;;  find lid has ilid in lidlist
(defun find-lid-in-llist(ilid llist)
  "llist may be make-lidlist"
  (loop for lid in llist 
    when (member ilid (olidof lid) )
    collect lid
  )
)


;;
(defun updateclist(clist cid)
  (let*  ((proof (proofof cid)) (rule (nth 0 proof))(llid (car (nth 3 proof)))(rlid (cadr (nth 3 proof))))
    (cond 
      ((eq rule :resolution) (cons cid (remove-cid llid (remove-cid rlid clist))))
      ((eq rule :factoring)  (cons cid (remove-cid llid (remove-cid rlid clist))))
      (t clist)
    )
  )
)
 
;;;
(defun next-pmap (pmap)
  (car pmap)
)

(defun updatepmap(pmap cid)
  "pmap = (llid rlid)*"
  (let*  ((proof (proofof cid)) (rule (nth 0 proof))(llid (car (nth 3 proof)))(rlid (cadr (nth 3 proof))))
    pmap
  )
)


