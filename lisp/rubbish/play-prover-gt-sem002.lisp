;; simple mech test 2

(load "load-rubbish.lisp")

;; play for prover

(setq *max-clauses* 100)
(setq *max-trials*  100)
(setq *max-steps*   100)
(setq *timeout-sec* 1)

(play-prover-gtrail '(C2 C3 C4) "kqc/seman/sem002.kqc")



