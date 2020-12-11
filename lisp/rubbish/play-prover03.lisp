;; play example with some proofs from same clause set

(load "load-rubbish.lisp")
(load "rubbish-prover.lisp")

(defparameter a3 (readkqc "kqc/provers/prov003.kqc"))

(defparameter *lsyms* (make-lsymlist *llist*))


(defun run ()
  
  (defparameter r8 (resolve-id 'L1-2 'L2-1))
  
  ;(dump-clause r8)
  
  (defparameter r9 (resolve-id (lidof 'c8 1) 'L3-1))
  ;(dump-clause r9)
  
  (defparameter r10 (resolve-id (lidof 'C9 1) 'L4-1))
  ;(dump-clause r10)
  
  (defparameter r11 (resolve-id (lidof 'C10 1) 'l6-1))
  ;(dump-clause r11)
  
  (defparameter r12 (resolve-id (lidof 'c11 1) 'l5-1))
  (dump-clause r12)
  
  (defparameter r3s (list r8 r9 r10 r11 r12))
  
  
  (dump-clausex (append a3 r3s))
  (ccode 'c8)
  (canonic 'c8)
)

