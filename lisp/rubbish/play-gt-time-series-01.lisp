;; test script for time-series

(load "load-rubbish.lisp")

;; play for prover

(setq *max-clauses* 50)
(setq *max-trials* 100)
(setq *max-steps* 100)
(setq *timeout-sec* 1)

(start-prover-gtrail "kqc/time-series/ts0.kqc")
;(start-prover-gtrail "kqc/time-series/ts1.kqc")
;(start-prover-gtrail "kqc/time-series/ts2.kqc")
;(start-prover-gtrail "kqc/time-series/ts3.kqc")

(log-start)

;(play-prover-gtrail (cidlistfy 1))
(play-prover-gtrail '(C1))

