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

(defun comb1 (e l)
  (if (null l)
    e
    (list (cons e (car l))  (comb1 e (cdr l)))
  )
)

(defun comb0 (l1 l2)
  (if (null l2) 
    l1
    (append (comb1 (car l1) l2) (comb0 (cdr l1) l2))
  )
)

(defun combnn (l1 l2)
  (loop for c1 in l1 append
    (loop for c2 in l2 collect 
       (list c1 c2)
    )
  )
)

;;;
(defun choose2 (a ll)
  (loop for b in ll  collect (cons a b))
)

(defun choose1 (ll)
  (if (null (cdr ll))
    (loop for a in (car ll) collect (list a))
    (loop for a in (car ll) append (choose2 a (choose1 (cdr ll))))
  )
)

(defun lnp2pmap (npl)
  (loop for np in npl collect
    (combnn (nth 1 np) (nth 2 np))
  )
)

(defun make-pmap-noF(llmap)
  (loop for x in (choose1 (lnp2pmap llmap)) collect x)
)


; find a lid in ssi whose olid is ilid
;ex (find-lid-in-clist 'L1-2 '(C8 C9))
(defun find-lid-in-clist (ilid clist)
  (loop for lid in (make-lidlist clist) 
                when (member ilid (olidof lid)) 
                collect lid)
)
;;;
(defun canF (ll lr)
  (and (equal (cidof ll)(cidof lr)) (equal (lsymof ll)(lsymof lr)))
)

(defun canR (ll lr)
  (and (not (equal (cidof ll)(cidof lr))) (equal (lsymof ll)(oppolsymof (lsymof lr))))
)

;;
(defun step-driver (pmap clist)
  (let (pms cid ls rs lcid rcid (cls clist) ll1 rl1 llid rlid umap)
    (loop for pm in pmap do 
      (setq pms (length umap))

      (setq ll1 (car pm)) 
      (setq rl1 (cadr pm))
  
      (setq ls (find-lid-in-clist ll1 clist))
      (when (or (null ls) (> (length ls) 1)) (return (values :fail pmap clist)))
      (setq llid (car ls))
      (setq rs (find-lid-in-clist rl1 clist))
      (when (or (null rs) (> (length rs) 1))  (return (values :fail pmap clist)))
      (setq rlid (car rs))
  
      (setq lcid (cidof llid))
      (setq rcid (cidof rlid))
  
      (when (canR llid rlid) 
        (setq cid (resolve-id llid rlid))
        (unless (eq cid :FAIL)
          (return (values :SUCCESS (append umap (cdr pmap)) (updateclist cid clist)))
        )
      )
  
      (when (canF ll1 rl1) 
        (setq cid (factor-id llid rlid))
        (unless (eq cid :FAIL)
          (return (values :SUCCESS (append umap (cdr pmap)) (updateclist cid clist)))
        )
      )

      (push pm umap)
      ; next is check no progress of the loop.
      (when (eq pms (length umap)) (return (values :FAIL umap clist)))
      finally
        (return (values :SUCCESS umap clist))
    )
  )
)

(defun proof-driver (pmap clist)
  (let ((map pmap)(cs clist) result)
    (loop while map do
      (multiple-value-setq (result map cs) (step-driver map cs))
      (when (eq result :FAIL) (return (list :FAIL map cs))) 
      finally
        (if (and (eq (length cs) 1) (iscontradiction (car cs))) 
          (return (list :SUCCESS cs))
          (return (list :FAIL cs))
        )
    )
  )
)

(defun noF-driver (clist)
  (loop for ss in (exhp-filter-nof (subsetof clist)) collect 
    (let (pm )
      (setq pm (make-pmap-noF (make-lnplist ss)))
      (proof-driver pm ss)
    )
  )
)
;;
(defun remove-cid (cid clist)
  (loop for c in clist unless (eq cid c) collect c)
)

;;
(defun updateclist(cid clist)
  (let*  
    (rcid lcid 
       (proof (proofof cid)) 
       (rule (nth 0 proof))
       (llid (car (nth 3 proof)))
       (rlid (cadr (nth 3 proof))))
    (setq lcid (cidof llid))
    (setq rcid (cidof rlid))

    (cond 
      ((eq rule :RESOLUTION) (cons cid (remove-cid lcid (remove-cid rcid clist))))
      ((eq rule :FACTORING)  (cons cid (remove-cid rcid clist)))
      (t clist)
    )
  )
)

