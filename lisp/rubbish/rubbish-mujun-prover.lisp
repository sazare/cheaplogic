;; mujun-prover

(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp"
                                       (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(pushnew #p"/Users/shin/.common-lisp/" asdf:*central-registry*)


(require :gtrail)
(in-package :rubbish)

(defun mujun-prover ()
  (let (g kqc ofile) 

    (setq sexp sb-ext:*posix-argv*)
    (setq g (nth 1 sexp))
    (setq kqc (nth 2 sexp))
    (setq ofile (nth 3 sexp))
    (with-open-file (out "work.txt"
                         :direction :output
                         :if-exists :supersede)
     (format out "in rubbish-mujun-prover~%")
    ; (format out "~a ~a~%" g kqc)
    (format out "~a ~a ~a~%" g kqc ofile)
    )
  )
)


