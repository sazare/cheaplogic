; performance of play-disag.lisp

(load "ito-disag.lisp")
(load "perf.lisp")
 
(defparameter PN 10000)
(performance `ito-unifications PN)
(performance `ito-unificationp PN)
(performance `ito-unificationsp PN)

;(performance `ito-unificationp PN)
;(performance `ito-unifications PN)
;(performance `ito-unificationsp PN)