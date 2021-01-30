;; simple mech test 3 

(load "load-rubbish.lisp")

;; play for prover

(setq *max-clauses* 100)
(setq *max-trials*  100)
(setq *max-steps*   100)
(setq *timeout-sec* 1)

(play-prover-gtrail '(1 2 3) "kqc/seman/sem003.kqc")

