;; play for prover
;; moved to ito-rubbish-prover.lisp

(load "load-rubbish.lisp")
(load "rubbish-prover.lisp")

(defparameter a1 (readskqc "((1 () (+ A a)(+ B a)(+ C a)(+ D a)(+ E a))(2 () (- A a)) (3 () (- B a))(4 ()(- C a))(5 ()(- D a))(6 () (- E a)))"))

(defparameter r7 (resolve-id 'L1-1 'L2-1))
(defparameter r8 (resolve-id 'L7-1 'L3-1))
(defparameter r9 (resolve-id 'L8-1 'L4-1))
(defparameter r10 (resolve-id 'L9-1 'L5-1))
(defparameter r11 (resolve-id 'L10-1 'L6-1))
(defparameter r12 (resolve-id 'L8-2 'L5-1))
; to ito-rubbish-prover.lisp


(ccode  'c8)
;(L1-3 L1-4 L1-5)
(loop for l in (ccode 'c8) collect (eval l))
;((+ C A) (+ D A) (+ E A))
(loop for l in (bodyof 'c8) collect (eval l))
;((+ C A) (+ D A) (+ E A))
;; occasionaly these are same, but generally different.
;; use variables, it becomes clear

(resolve-id 'L3-1 'L1-2)
;C13
;* (dump-clause 'C13)
;C13=(PROOF (RESOLUTION NIL NIL (L3-1 L1-2)) VARS NIL NAME RESOLVENT)
; L13-1 (+ A A) = (OLID L1-1 PLID L1-1 CID C13)
; L13-2 (+ C A) = (OLID L1-3 PLID L1-3 CID C13)
; L13-3 (+ D A) = (OLID L1-4 PLID L1-4 CID C13)
; L13-4 (+ E A) = (OLID L1-5 PLID L1-5 CID C13)
;NIL
(resolve-id 'L5-1 'L13-3)
;C14
;* (dump-clause 'C14)
;C14=(PROOF (RESOLUTION NIL NIL (L5-1 L13-3)) VARS NIL NAME RESOLVENT)
; L14-1 (+ A A) = (OLID L1-1 PLID L13-1 CID C14)
; L14-2 (+ C A) = (OLID L1-3 PLID L13-2 CID C14)
; L14-3 (+ E A) = (OLID L1-5 PLID L13-4 CID C14)
;NIL


;;;;; with vars1

(defparameter a2 (readskqc "((21 (x y z w u) (+ A x y)(+ B y z)(+ C z w)(+ D w u)(+ E u x))(22 () (- A a b)) (23 () (- B b c))(24 ()(- C c d))(25 ()(- D d e))(26 (x) (- E x x)))"))

(dump-clauses a2)


(defparameter a3 (readskqc "((41 (x y z w u) (+ A x y)(+ B y z)(+ C z w)) (42 (w u x) (- B w u)(+ E u x)) (43 () (- A a b)) (44 (x y) (- C x y) (+ D  x y))(45 ()(- D d n))(46 ()(- E d e))(47 (x) (- E x x)))"))

(dump-clauses a3)
;C41=(VARS (X.429 Y.430 Z.431 W.432 U.433) NAME 41)
; L41-1 (+ A X.429 Y.430) = (OLID L41-1 PLID NIL CID C41)
; L41-2 (+ B Y.430 Z.431) = (OLID L41-2 PLID NIL CID C41)
; L41-3 (+ C Z.431 W.432) = (OLID L41-3 PLID NIL CID C41)
;C42=(VARS (W.434 U.435 X.436) NAME 42)
; L42-1 (- B W.434 U.435) = (OLID L42-1 PLID NIL CID C42)
; L42-2 (+ E U.435 X.436) = (OLID L42-2 PLID NIL CID C42)
;C43=(VARS NIL NAME 43)
; L43-1 (- A A B) = (OLID L43-1 PLID NIL CID C43)
;C44=(VARS (X.437 Y.438) NAME 44)
; L44-1 (- C X.437 Y.438) = (OLID L44-1 PLID NIL CID C44)
; L44-2 (+ D X.437 Y.438) = (OLID L44-2 PLID NIL CID C44)
;C45=(VARS NIL NAME 45)
; L45-1 (- D D N) = (OLID L45-1 PLID NIL CID C45)
;C46=(VARS NIL NAME 46)
; L46-1 (- E D E) = (OLID L46-1 PLID NIL CID C46)
;C47=(VARS (X.439) NAME 47)
; L47-1 (- E X.439 X.439) = (OLID L47-1 PLID NIL CID C47)
;NIL

(defparameter r48 (resolve-id 'L41-2 'L42-1))
(dump-clause r48)
;C48=(PROOF
;     (RESOLUTION (X.429 Y.430 Z.431 W.432 U.433 W.434 U.435 X.436)
;      (X.440 W.445 U.446 W.443 U.444 W.445 U.446 X.447) (L41-2 L42-1))
;     VARS (X.440 W.443 U.444 W.445 U.446 X.447) NAME RESOLVENT)
; L48-1 (+ A X.440 W.445) = (OLID L41-1 PLID L41-1 CID C48)
; L48-2 (+ C U.446 W.443) = (OLID L41-3 PLID L41-3 CID C48)
; L48-3 (+ E U.446 X.447) = (OLID L42-2 PLID L42-2 CID C48)
;NIL


(defparameter r49 (resolve-id 'L48-1 'L43-1))
(dump-clause r49)
;C29=(PROOF
;     (RESOLUTION (X.445 W.448 U.449 W.450 U.451 X.452)
;      (A W.454 U.455 B U.457 X.458) (L28-1 L23-1))
;     VARS (W.454 U.455 U.457 X.458) NAME RESOLVENT)
; L29-1 (+ C U.457 W.454) = (OLID L21-3 PLID L28-2 CID C29)
; L29-2 (+ E U.457 X.458) = (OLID L22-2 PLID L28-3 CID C29)
;NIL

(defparameter r50 (resolve-id 'L49-1 'L44-1))
(dump-clause r50)

(defparameter r51 (resolve-id 'l50-1 'l46-1))
(dump-clause r51)

(defparameter r52 (resolve-id 'l51-1 'l45-1))
(dump-clause r52)

(defparameter r3s '(c48 c49 c50 c51 c52))


(dump-clauses (append a3 r3s))
(ccode 'c48)
(canonic 'c48)

