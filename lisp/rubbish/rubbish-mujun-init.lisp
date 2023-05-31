(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp"
                                       (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(pushnew #p"/Users/shin/.common-lisp/" asdf:*central-registry*)

(require :gtrail)

