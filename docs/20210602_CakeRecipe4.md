#  full oppos
## cake001a

```lisp
(defparameter fkname "kqc/cake/cake001a.kqc")

(load "load-rubbish.lisp")

(setq *max-clauses* 100)
(setq *max-trials* 100)
(setq *max-steps* 100)
(setq *timeout-sec* 5)

(trace prover-gtrail)
(trace unificationsp)
(trace resolve-id)
(trace prover-gtrail)
(trace step-solver)
(trace find-oppolids)


(logstart)
(play-prover-gtrail '(1) fkname)
```

## 特徴
- 必要なopposが全部ある。
- 