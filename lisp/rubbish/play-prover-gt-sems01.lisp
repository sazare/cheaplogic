;; ters for reduce,resolution following

(load "load-rubbish.lisp")

;; play for prover

(setq *max-clauses* 20)
(setq *max-trials* 100)
(setq *max-steps* 100)
(setq *timeout-sec* 2)

(play-prover-gtrail '(1) "kqc/seman/test-recude.kqc")


