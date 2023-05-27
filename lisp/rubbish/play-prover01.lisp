;; ito-rubbish-prover.lisp
;; 
(load "load-rubbish.lisp")
(load "rubbish-prover-gtrail.lisp")

;; play for prover

;(play-prover-gtrail '(C1)  "kqc/provers/prov001.kqc")


(defparameter a1 (readkqc "kqc/provers/prov001.kqc"))

(defun run ()

(defparameter r7 (resolve-id 'L1-1 'L2-1))
(defparameter r8 (resolve-id (lidof r7 1) 'L3-1))
(defparameter r9 (resolve-id (lidof r8 1) 'L4-1))
(defparameter r10 (resolve-id (lidof r9 1) 'L5-1))
(defparameter r11 (resolve-id (lidof r10 1) 'L6-1))

(ccode  'c8)

(defparameter w1 (resolve-id 'L3-1 'L1-2))

(dump-clause w1) 
;C13=(PROOF (RESOLUTION NIL NIL (L3-1 L1-2)) VARS NIL NAME RESOLVENT)
; L13-1 (+ A A) = (OLID L1-1 PLID L1-1 CID C13)
; L13-2 (+ C A) = (OLID L1-3 PLID L1-3 CID C13)
; L13-3 (+ D A) = (OLID L1-4 PLID L1-4 CID C13)
; L13-4 (+ E A) = (OLID L1-5 PLID L1-5 CID C13)
;NIL

(defparameter w2 (resolve-id 'L5-1 (lidof w1 3))) 
(dump-clause w2)
;C14=(PROOF (RESOLUTION NIL NIL (L5-1 L13-3)) VARS NIL NAME RESOLVENT)
; L14-1 (+ A A) = (OLID L1-1 PLID L13-1 CID C14)
; L14-2 (+ C A) = (OLID L1-3 PLID L13-2 CID C14)
; L14-3 (+ E A) = (OLID L1-5 PLID L13-4 CID C14)
;NIL

)
