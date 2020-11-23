;; play example with some proofs from same clause set

(load "load-rubbish.lisp")
(load "rubbish-prover.lisp")

(defparameter a3 (readkqc "kqc/provers/prov003.kqc"))

(defparameter *lsyms* (make-lsymtolids *llist*))


(defun run ()

(defparameter r48 (resolve-id 'L41-2 'L42-1))

;(dump-clause r48)
;C48=(PROOF
;     (RESOLUTION (X.429 Y.430 Z.431 W.432 U.433 W.434 U.435 X.436)
;      (X.440 W.445 U.446 W.443 U.444 W.445 U.446 X.447) (L41-2 L42-1))
;     VARS (X.440 W.443 U.444 W.445 U.446 X.447) NAME RESOLVENT)
; L48-1 (+ A X.440 W.445) = (OLID L41-1 PLID L41-1 CID C48)
; L48-2 (+ C U.446 W.443) = (OLID L41-3 PLID L41-3 CID C48)
; L48-3 (+ E U.446 X.447) = (OLID L42-2 PLID L42-2 CID C48)
;NIL


(defparameter r49 (resolve-id (lidof 'c48 1) 'L43-1))
;(dump-clause r49)
;C29=(PROOF
;     (RESOLUTION (X.445 W.448 U.449 W.450 U.451 X.452)
;      (A W.454 U.455 B U.457 X.458) (L28-1 L23-1))
;     VARS (W.454 U.455 U.457 X.458) NAME RESOLVENT)
; L29-1 (+ C U.457 W.454) = (OLID L21-3 PLID L28-2 CID C29)
; L29-2 (+ E U.457 X.458) = (OLID L22-2 PLID L28-3 CID C29)
;NIL

(defparameter r50 (resolve-id (lidof 'C49 1) 'L44-1))
;(dump-clause r50)

(defparameter r51 (resolve-id (lidof 'C50 1) 'l46-1))
;(dump-clause r51)

(defparameter r52 (resolve-id (lidof 'c51 1) 'l45-1))
(dump-clause r52)

(defparameter r3s (list r48 r49 r50 r51 r52))


(dump-clausex (append a3 r3s))
(ccode 'c48)
(canonic 'c48)
)

