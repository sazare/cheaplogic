;; ito for all disag modules
;; this version of ITO test on no gensym randomness.
(load "load-rubbish.lisp")

(load "nit-rubbish-unif.lisp")
;(load "nit-rubbish-gen-noran.lisp")
(load "rubbish-gen.lisp")
;(load "nit-rubbish-base-noran.lisp")
(load "nit-rubbish-base.lisp")
(load "nit-rubbish-kqcio.lisp")
(load "nit-rubbish-base.lisp")
(load "nit-rubbish-reso.lisp")
(load "nit-rubbish-resoid.lisp")

(load "nit-rubbish-peval.lisp")

;; rubbish-tools should be run before resoid(used them)
(load "rubbish-tools.lisp")
(load "nit-rubbish-tools.lisp") ;; this contains local nit-functions and do ito

