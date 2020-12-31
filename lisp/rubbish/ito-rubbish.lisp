;; ito for all disag modules
;; this version of ITO test on no gensym randomness.
(load "load-rubbish.lisp")

(load "ito-rubbish-unif.lisp")
;(load "ito-rubbish-gen-noran.lisp")
(load "rubbish-gen.lisp")
;(load "ito-rubbish-base-noran.lisp")
(load "ito-rubbish-base.lisp")
(load "ito-rubbish-kqcio.lisp")
(load "ito-rubbish-base.lisp")
(load "ito-rubbish-reso.lisp")
(load "ito-rubbish-resoid.lisp")

(load "ito-rubbish-peval.lisp")

;; rubbish-tools should be run before resoid(used them)
(load "rubbish-tools.lisp")
(load "ito-rubbish-tools.lisp") ;; this contains local ito-functions and do ito

