;; kosho detect

(load "load-rubbish.lisp")

;; play for prover

(setq *max-clauses* 100)
(setq *max-trials* 500)
(setq *max-steps* 100)
(setq *timeout-sec* 5)

(play-prover-gtrail '(C1 C2) "kqc/kosho/switch009.kqc")


