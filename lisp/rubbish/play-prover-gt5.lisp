;; 2 clauses goal
(load "load-rubbish.lisp")
(load "rubbish-prover-gtrail.lisp")

;; play prov5.kqc has slightly complex one

(play-prover-gtrail '(C1 C2)  "kqc/provers/prov5.kqc")

