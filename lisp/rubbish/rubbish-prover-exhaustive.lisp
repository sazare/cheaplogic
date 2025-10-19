;;  rubbish-prover-exhaustive.lisp
;;; EXHP はclistベースで証明を作る

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

;;; pairing

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

;;;; ppn : pred pos neg
;;;; pplist : pair list
;;;; pms : pair map

(defun ppn2pplist (ppnlist)
  (loop for ppn in ppnlist collect
    (pairing (nth 1 ppn)(nth 2 ppn))
  )
)

;;
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

;;;;
;;  make pair map from ppnlist
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
;; simple resolable or factorble
(defun reducible (lid1 lid2)
  (let* ((vs (append (varsof (cidof lid1)) (varsof (cidof lid2))))
         (a1 (latomicof lid1))
         (a2 (latomicof lid2)) 
         (sig (funification vs a1 a2)))

     (not (eq :NO sig))
  )
)

(defun canF (ll lr)
  (and 
    (equal (cidof ll)(cidof lr)) 
    (equal (lsymof ll)(lsymof lr)) 
    (reducible  ll lr)
  )
)

(defun canR (ll lr)
  (and 
    (not (equal (cidof ll)(cidof lr))) 
    (equal (lsymof ll)(oppolsymof (lsymof lr))) 
    (reducible  ll lr)
  )
)

(defun remove-cid (cid clist)
  (loop for c in clist unless (eq cid c) collect c)
)

;; update clist ad step prover
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
      (when (or (null ls) (> (length ls) 1)) (return (values :FAIL pmap clist)))
      (setq llid (car ls))
      (setq rs (find-lid-in-clist rl1 clist))
      (when (or (null rs) (> (length rs) 1))  (return (values :FAIL pmap clist)))
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

;; 検討中。factoringが必要なときのpairing
(defun なにかn:mのときpairをつくるやつ(ppn)
  (and
    (nth 1 ppn)
    (nth 2 ppn)
    (let ((l1 (nth 1 ppn)) (l2 (nth 2 ppn)))
      (cond 
        ((> (length l1)(length l2)) (effort-pairing l1 l2))
        ((< (length l1)(length l2)) (effort-pairing l2 l1))
        (t t)
      )
    )
  )
)

;;;
;;; possible no F
(defun balance-nof (ppn)
  "for no Fctoring, + and - has same length, and unifiable"
  (and
    (nth 1 ppn)
    (nth 2 ppn)
    (eq (length (nth 1 ppn)) (length (nth 2 ppn)))
  )
)


; F free
(defun noneedF (s)
  (and 
    (> (length s) 1) 
    (loop for ppn in (make-ppnlist s) always (balance-nof ppn))
  )
)

(defun noF-driver (ss)
  (let (pms)
    (setq pms (make-pmap-noF (make-ppnlist ss)))
    (loop for pm in pms collect (proof-driver pm ss)
    )
  )
)

;;; for every subsets do something
(defun subtraverse (clist filterfn driver)
  (let ((ss nil)(res nil))
    (loop while (setq ss (nextset ss clist)) 
      when (funcall filterfn ss) append (funcall driver ss)
    )
  )
)

;; sample of subtraverse
(defun nof-prover (ss)
  (subtraverse ss #'noneedF #'noF-driver)
)

