;; kosho detect
;; pre-investigation of switch010.kqc

(load "load-rubbish.lisp")

;; play for prover

(setq *max-clauses* 100)
(setq *max-trials* 500)
(setq *max-steps* 100)
(setq *timeout-sec* 5)

(play-prover-gtrail '(C7) "kqc/kosho/switch010a.kqc")


