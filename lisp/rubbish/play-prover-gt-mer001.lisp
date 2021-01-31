;; simple mech test 1

(load "load-rubbish.lisp")

;; play for prover

(setq *max-clauses* 100)
(setq *max-trials* 100)
(setq *max-steps* 100)
(setq *timeout-sec* 1)

;(play-prover-gtrail '(1) "kqc/merge/merge001.kqc")
;(play-prover-gtrail '(5) "kqc/merge/merge001.kqc")
(play-prover-gtrail '(1 5) "kqc/merge/merge001.kqc")

