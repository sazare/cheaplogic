;; utility macros for myself

(in-package :rubbish)

(defun rp (path)
  (readekqc path)
  (print-clauses)
)

(defmacro pcs (&rest cs)
  `(print-clauses ',(or cs *clist*))
)

(defmacro p1 (cid)
  `(print-clause ',cid )
)

;;
(defmacro pg (&rest g)
  `(prover-gtrail ',g)
)

(defmacro ppg (p &rest g)
  `(play-prover-gtrail ',g ,p)
)

(defmacro spa (g)
  `(show-parameter0 ',g t)
)

(defmacro pr0 (c)
  `(print-proof0 ',c)
)

(defmacro ppr (c)
  `(print-proof ',c)
)

(defmacro sm ()
  `(summary0 t)
)

(defun print-list (mm)
  (loop for x in mm do (format t "~a~%" x))
)

(defun pf (f)
  (print-list (readafile f))
)



