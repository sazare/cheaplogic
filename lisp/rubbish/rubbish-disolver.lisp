; rubbish-disolver.lisp for inconsistent disolvers

;; constant defintions
(defconstant CEQ 'ceq "CEQ is the predicate '=' used in conversion from mgu.")

; mge is most general equation
; ceq is a predicate of equality in mgu conversion

; this is just in view, not properties
(defun mge-of (cid)
  "make a clause of neg cond of mgu. this is the -C part of L v -C with vars"
  (list 
    (nth 1 (proofof cid))
    (loop for v in (nth 1 (proofof cid))
         as f in (nth 2 (proofof cid))
         collect `(- ,CEQ ,v ,f))
  )
)

