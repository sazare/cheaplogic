;; kosho detect

(load "load-rubbish.lisp")

;; play for prover

(setq *max-clauses* 100)
(setq *max-trials* 100)
(setq *max-steps* 100)
(setq *timeout-sec* 1)

(play-prover-gtrail '(C1 C2 C3) "kqc/kosho/switch008.kqc")


