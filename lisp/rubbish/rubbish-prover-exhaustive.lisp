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
;ex (exh-mylid 'L1-2 '(C8 C9))

(defun exh-mylid (ilid ssi)
  "I find the lid whose olid is ilid but not equal."
  (loop for cid in ssi append
    (loop for lid in (bodyof cid) when (and (not (eq (olidof lid) lid)) (eq (olidof lid) ilid))
      append (list lid)
    )
  )
)


;; make nplist



;; make llpair of a clist
