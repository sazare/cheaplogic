; Cake making

(defparameter fkname "kqc/cake/cake001a.kqc")

(load "load-rubbish.lisp")

(setq *max-clauses* 50)
(setq *max-trials* 100)
(setq *max-steps* 100)
(setq *timeout-sec* 5)

(play-prover-gtrail '(1) fkname)


