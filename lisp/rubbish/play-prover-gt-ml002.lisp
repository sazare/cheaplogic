
;; ters for reduce on input

;(load "load-rubbish.lisp")
(require :rubbish)

;; play for prover

(setq *max-clauses* 50)
(setq *max-trials* 100)
(setq *max-steps* 100)
(setq *timeout-sec* 1)

(play-prover-gtrail '(1) "kqc/ml002.kqc")

