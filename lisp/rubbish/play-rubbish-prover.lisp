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


(cmarker  'c8)
;(L1-3 L1-4 L1-5)
(loop for l in (cmarker 'c8) collect (eval l))
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
* (resolve-id 'L5-1 'L13-3)
;C14
;* (dump-clause 'C14)
;C14=(PROOF (RESOLUTION NIL NIL (L5-1 L13-3)) VARS NIL NAME RESOLVENT)
; L14-1 (+ A A) = (OLID L1-1 PLID L13-1 CID C14)
; L14-2 (+ C A) = (OLID L1-3 PLID L13-2 CID C14)
; L14-3 (+ E A) = (OLID L1-5 PLID L13-4 CID C14)
;NIL


;;;;; with vars1

(defparameter a2 (readskqc "((11 (x y z w u) (+ A x y)(+ B y z)(+ C z w)(+ D w u)(+ E u x))(12 () (- A a b)) (13 () (- B b c))(14 ()(- C c d))(15 ()(- D d e))(16 (x) (- E x x)))"))

(dump-clauses a2)
;C11=(PROOF (RESOLUTION NIL NIL (L10-1 L6-1)) VARS
;     (X.428 Y.429 Z.430 W.431 U.432) NAME 11)
; L11-1 (+ A X.428 Y.429) = (OLID L11-1 PLID NIL CID C11)
; L11-2 (+ B Y.429 Z.430) = (OLID L11-2 PLID NIL CID C11)
; L11-3 (+ C Z.430 W.431) = (OLID L11-3 PLID NIL CID C11)
; L11-4 (+ D W.431 U.432) = (OLID L11-4 PLID NIL CID C11)
; L11-5 (+ E U.432 X.428) = (OLID L11-5 PLID NIL CID C11)
;C12=(PROOF (RESOLUTION NIL NIL (L8-2 L5-1)) VARS NIL NAME 12)
; L12-1 (- A A B) = (OLID L12-1 PLID NIL CID C12)
;C13=(PROOF (RESOLUTION NIL NIL (L3-1 L1-2)) VARS NIL NAME 13)
; L13-1 (- B B C) = (OLID L13-1 PLID NIL CID C13)
;C14=(PROOF (RESOLUTION NIL NIL (L5-1 L13-3)) VARS NIL NAME 14)
; L14-1 (- C C D) = (OLID L14-1 PLID NIL CID C14)
;C15=(VARS NIL NAME 15)
; L15-1 (- D D E) = (OLID L15-1 PLID NIL CID C15)
;C16=(VARS (X.433) NAME 16)
; L16-1 (- E X.433 X.433) = (OLID L16-1 PLID NIL CID C16)
;NIL
;

(defparameter a3 (readskqc "((21 (x y z w u) (+ A x y)(+ B y z)(+ C z w)) (22 (w u x) (- B w u)(+ E u x)) (23 () (- A a b)) (24 (x y) (- C x y) (+ D  x y))(25 ()(- D d n))(26 ()(- E d e))(27 (x) (- E x x)))"))

(resolve-id 'L21-2 'L22-1)
;C28
;* (dump-clause 'c28)
;C28=(PROOF
;     (RESOLUTION (X.434 Y.435 Z.436 W.437 U.438 W.439 U.440 X.441)
;      (X.445 W.450 U.451 W.448 U.449 W.450 U.451 X.452) (L21-2 L22-1))
;     VARS (X.445 W.448 U.449 W.450 U.451 X.452) NAME RESOLVENT)
; L28-1 (+ A X.445 W.450) = (OLID L21-1 PLID L21-1 CID C28)
; L28-2 (+ C U.451 W.448) = (OLID L21-3 PLID L21-3 CID C28)
; L28-3 (+ E U.451 X.452) = (OLID L22-2 PLID L22-2 CID C28)
;NIL
(resolve-id 'L28-1 'L23-1)
;C29
;* (dump-clause 'c29)
;C29=(PROOF
;     (RESOLUTION (X.445 W.448 U.449 W.450 U.451 X.452)
;      (A W.454 U.455 B U.457 X.458) (L28-1 L23-1))
;     VARS (W.454 U.455 U.457 X.458) NAME RESOLVENT)
; L29-1 (+ C U.457 W.454) = (OLID L21-3 PLID L28-2 CID C29)
; L29-2 (+ E U.457 X.458) = (OLID L22-2 PLID L28-3 CID C29)
;NIL
(resolve-id 'L29-1 'L24-1)
;C30
;* (dump-clause 'c30)
;C30=(PROOF
;     (RESOLUTION (W.454 U.455 U.457 X.458 X.442 Y.443)
;      (Y.464 U.460 X.463 X.462 X.463 Y.464) (L29-1 L24-1))
;     VARS (U.460 X.462 X.463 Y.464) NAME RESOLVENT)
; L30-1 (+ E X.463 X.462) = (OLID L22-2 PLID L29-2 CID C30)
; L30-2 (+ D X.463 Y.464) = (OLID L24-2 PLID L24-2 CID C30)
;NIL
(resolve-id 'l30-1 'l26-1)
;C31
;* (dump-clause 'c31)
;C31=(PROOF
;     (RESOLUTION (U.460 X.462 X.463 Y.464) (U.465 E D Y.468) (L30-1 L26-1))
;     VARS (U.465 Y.468) NAME RESOLVENT)
; L31-1 (+ D D Y.468) = (OLID L24-2 PLID L30-2 CID C31)
;NIL
(resolve-id 'l31-1 'l25-1)
;C32

(defparameter r3 '(c28 c29 c30 c31 c32))


(dump-clauses (append a3 r3))
(cmarker 'c28)
(canonic 'c28)

