;; assume called from run-program

#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp"
                                       (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))


;;; for ASDF
(pushnew #p"/Users/shin/.common-lisp/" asdf:*central-registry*)


(require :gtrail)
(in-package :rubbish)
(readkqc "kqc/ml002.kqc")
(print-clauses *clist*)


