;; test script for time-series

(load "load-rubbish.lisp")

;; play for prover

(setq *max-clauses* 50)
(setq *max-trials* 100)
(setq *max-steps* 100)
(setq *timeout-sec* 1)

(start-prover-gtrail "kqc/time-series/ts-0.kqc") ;C2
(start-prover-gtrail "kqc/time-series/ts-1.kqc") ;C3
; step 1 0 and 1 conflict

;; if do the previous, the following require remove C2(ts-0)
(start-prover-gtrail "kqc/time-series/ts-2.kqc") ;C4
; step 2 1 and 2 no conflict without 0

(start-prover-gtrail "kqc/time-series/ts-3.kqc") ;C5
; step 3 1,2 and 3 no conflict

(logstart)

;(prover-gtrail (cidlistfy 1))
;(prover-gtrail '(C3))

