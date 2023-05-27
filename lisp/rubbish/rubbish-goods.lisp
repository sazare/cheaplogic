;; utility macros for myself

(in-package :rubbish)

(defun rp (path)
  (readekqc path)
  (print-clauses)
)

(defmacro pc (&rest cs)
  `(print-clauses ',(or cs *clist*))
)

;;
(defmacro pg (&rest g)
  `(prover-gtrail ',g)
)

(defmacro ppg (p &rest g)
  `(play-prover-gtrail ',g ,p)
)

(defmacro sp (g)
  `(show-parameter0 ',g t)
)

(defmacro pr0 (c)
  `(print-proof0 ',c)
)

(defmacro ppr (c)
  `(print-proof ',c)
)



