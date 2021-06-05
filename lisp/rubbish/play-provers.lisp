;; this is just load play-prover*.lisp 
;; 2021/06/05
;; it required rebooted of sbcl, this file(play-provers.lisp) load is not a correct way.



(load "play-prover-gt-mer001.lisp") ; ok 5 cons
(load "play-prover-gt-ml002.lisp") ; ok 1 cons

(load "play-prover-gt-presem.lisp") ; seems handy test
(load "play-prover-gt-sem001.lisp") ; ok [] and valids
(load "play-prover-gt-sem002.lisp") ; ok checked print-proof0
(load "play-prover-gt-sem003.lisp") ; ok con and valids. checked lscova
(load "play-prover-gt-sems01.lisp") ; ok 

(load "play-prover-gt.lisp") ; max-clause =100でclause数2736?
(load "play-prover-gt0.lisp")     OK direct []
(load "play-prover-gt000.lisp") OK resolvent with fact
(load "play-prover-gt001.lisp") OK linear proof
(load "play-prover-gt002.lisp")  XXX cid とinput nameのミスマッチかな??
(load "play-prover-gt003.lisp") maybe
(load "play-prover-gt004.lisp") maybe
(load "play-prover-gt1.lisp") ok 
(load "play-prover-gt2.lisp") ok ; same as gt1
(load "play-prover-gt3.lisp") ok single []
(load "play-prover-gt4.lisp") ok x=a []
(load "play-prover-gt5.lisp") ok []s without c4

(load "play-prover-gt6loop.lisp")  ; too many cluses
(load "play-prover-gt7loop.lisp")  ; too many contradictions
(load "play-prover-gt8loop.lisp")  ; too many resolvents, infinite loop
(load "play-prover-gtvv01.lisp")  ; ok
(load "play-prover-gtvv02.lisp")  ; seems ok

(load "play-prover-magia.lisp") ok

; (load "play-gt-time-series-01.lisp")

; kosho is for handy test maybe
(load "play-prover-gt-kosho001.lisp")
(load "play-prover-gt-kosho002.lisp")
(load "play-prover-gt-kosho003.lisp")
(load "play-prover-gt-kosho004.lisp")
(load "play-prover-gt-kosho005.lisp")
(load "play-prover-gt-kosho006.lisp")
(load "play-prover-gt-kosho007.lisp")
(load "play-prover-gt-kosho008.lisp")
(load "play-prover-gt-kosho009.lisp")
(load "play-prover-gt-kosho010.lisp")
(load "play-prover-gt-kosho010a.lisp")

;; following require "(run)" after load
;; but uncirtain
(load "play-prover01.lisp")
(load "play-prover02.lisp")
(load "play-prover03.lisp")
(load "play-prover04.lisp")
(load "play-provervv01.lisp")
(load "play-provervv02a.lisp")
(load "play-provervv02c.lisp")
