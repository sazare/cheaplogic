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
(defun step-forward (pmap clist)
  (prog (cid lcid rcid (cls clist) ll1 rl1 llid rlid)
    (setq ll1 (caar pmap)) 
    (setq rl1 (cadar pmap))

    (setq llid (car (find-lid-in-clist ll1 clist)))
    (setq rlid (car (find-lid-in-clist rl1 clist)))

    (setq lcid (cidof llid))
    (setq rcid (cidof rlid))

    (when (canR llid rlid) 
      (setq cid (resolve-id llid rlid))
      (unless (eq cid :FAIL)
        (return (values (cdr pmap) (updateclist cid clist)))
      )
    )

    (when (canF ll1 rl1) 
      (setq cid (factor-id llid rlid))
      (unless (eq cid :FAIL)
        (return (values (cdr pmap) (updateclist cid clist)))
      )
    )
  )
)

(defun exec-prove (pmap clist)
  (let ((map pmap)(cs clist))
    (loop while pmap do
      (multiple-value-setq (map cs) (step-forward map cs))
    )
  )
)

;;
(defun remove-cid (cid clist)
  (loop for c in clist unless (eq cid c) collect c)
)


;;
(defun updateclist(cid clist)
  (let*  (rcid lcid (proof (proofof cid)) (rule (nth 0 proof))(llid (car (nth 3 proof)))(rlid (cadr (nth 3 proof))))
;    (setq lcid (cidof (car (find-lid-in-clist llid clist))))
;    (setq rcid (cidof (car (find-lid-in-clist rlid clist))))
    (setq lcid (cidof llid))
    (setq rcid (cidof rlid))

    (cond 
      ((eq rule :resolution) (cons cid (remove-cid lcid (remove-cid rcid clist))))
      ((eq rule :factoring)  (cons cid (remove-cid rlid clist)))
      (t clist)
    )
  )
)

;;;
(defun canF (ll lr)
  (and (equal (cidof ll)(cidof lr)) (equal (lsymof ll)(lsymof lr)))
)

(defun canR (ll lr)
  (and (not (equal (cidof ll)(cidof lr))) (equal (lsymof ll)(oppolsymof (lsymof lr))))
)

(defun proofstep (clist imap)
   "imap is a pair list of inputlid. clist is just a clauses list"
  (prog(rms rcs rcid )
     (loop for m in imap do
       (let ((ill (car m))(ilr (cadr m)) ll lr)
         (setq ll (find-lid-in-clist ill clist))
         (setq lr (find-lid-in-clist ilr clist))
         (cond
           ((canR ll lr) (setq rcid (resolve-id ll lr)))
           ((canF ll lr) (setq rcid (factor-id ll lr)))
           (t (push m rms) (setq imap (cdr imap)))
         )
         (when (not (eq :fail rcid) )
           (return (values (update clist rcid) (update imap m)))
         ) 
       )
     )
  )   
)


;;;;
;(defun next-pmap (pmap)
;  (let (cand rem)
;    (setq cand (car pmap))
;    (setq rem (cdr pmap))
;    
;  )
;)
;
;(defun updatepmap(pmap cid)
;  "pmap = (llid rlid)*"
;  (let*  ((proof (proofof cid)) (rule (nth 0 proof))(llid (car (nth 3 proof)))(rlid (cadr (nth 3 proof))))
;    pmap
;  )
;)
;
;
