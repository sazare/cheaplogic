;;  rubbish-prover-exhaustive.lisp

(in-package :rubbish)

; exhaustive-prover

; make all lid of clist
(defun make-lidlist(clist)
  "clist -> all lids"
  (loop for cid in clist append
    (bodyof cid)
  )
)

; find lids with lsym in lids
(defun getlllist (lsym lids)
  "lids -> lids has lsym"
  (loop for lid in lids when (eq lsym (lsymof lid)) collect lid)
)

; make-ppnlist is another implementation of make-nplist
(defun make-ppnlist (clist)
  "clist -> (pre pos neg)*"
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

;;; pairint over pred

(defun kickout (s l)
  (loop for e in l
    when (not (equal s e))
    collect e
  )
)

(defun mapput (p1 pss)
  (loop for ps in pss collect
    (cons p1 ps)
  )
)

(defun pairvh (v h vs hs)
  (mapput (list v h) (pairv vs hs))
)

(defun pairh (v vs hs)
  (if (null vs)
    (list (list (list v (car hs))))
    (loop for h in hs append
      (pairvh v h vs (kickout h hs))
    )
  )
)

(defun pairv (vs hs)
  (pairh (car vs) (cdr vs) hs) 
)

(defun pairing (pl sl)
  (pairv pl sl)
)

;;;;
;(ppn2pplist (make-ppnlist (car (exhp-filter-nof (subsetof ss1)))))
;(ppn2pplist (make-ppnlist (car (exhp-filter-nof (subsetof ss1)))))
;((((L1-3 L5-1))) (((L1-1 L3-1) (L1-2 L4-1)) ((L1-1 L4-1) (L1-2 L3-1))))
;;
;; (pplist2pms ..)
;; ((((L1-3 L5-1) (L1-1 L3-1) (L1-2 L4-1)) ((L1-3 L5-1) (L1-1 L4-1) (L1-2 L3-1))))
(defun ppn2pplist (ppnlist)
  (loop for ppn in ppnlist collect
    (pairing (nth 1 ppn)(nth 2 ppn))
  )
)
;
(defun pplist2pms (pplist)
  (if (cdr pplist) 
    (let (ppltail)
      (setq ppltail (pplist2pms (cdr pplist)))
      (loop for ap in (car pplist) append
        (loop for tp in ppltail collect
          (append ap tp)
        )
      )
    )
    (car pplist)
  )
)
 

(defun pairpath(clist)
  (loop for ss in (exhp-filter-nof (subsetof clist)) append
    (pairplist (ppn2pnlist (make-ppnlist ss)))
  )
)
 
(defun make-pmap-noF (ppnlist)
  (pplist2pms (ppn2pplist ppnlist))
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

(defun remove-cid (cid clist)
  (loop for c in clist unless (eq cid c) collect c)
)

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


;;; nof-prover
(defun balance-nof (ppn)
  "for no Fctoring, + and - has same length"
  (and
    (nth 1 ppn)
    (nth 2 ppn)
    (eq (length (nth 1 ppn)) (length (nth 2 ppn)))
  )
)

(defun exhp-filter-noF (ss)
  "for no Filtering, the clauses set has at least 2, and balanced ppn"
  (loop for s in ss 
    when 
      (and 
        (> (length s) 1) 
        (loop for ppn in (make-ppnlist s) always (balance-nof ppn))
      )
    collect s
  )
)

(defun noF-driver (clist)
  "for no Fctoring clause set, do proof-driver"
  (loop for ss in (exhp-filter-nof (subsetof clist)) collect 
    (let (pms)
      (setq pms (make-pmap-noF (make-ppnlist ss)))
      (loop for pm in pms collect  ;;why car
        (proof-driver pm ss)
      )
    )
  )
)

