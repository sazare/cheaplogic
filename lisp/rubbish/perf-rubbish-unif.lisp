; performance of unif-disag.lisp

(load "ito-rubbish-unif.lisp")
(myload "perf.lisp")
 
(defparameter PN 10000)
(performance `ito-unifications PN)
(performance `ito-unificationp PN)
(performance `ito-unificationsp PN)

;(performance `ito-unificationp PN)
;(performance `ito-unifications PN)
;(performance `ito-unificationsp PN)
