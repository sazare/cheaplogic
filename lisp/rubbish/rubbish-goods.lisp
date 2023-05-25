;; utilities for myself

(in-package :rubbish)

(defun rp (path)
  (readkqc path)
  (print-clauses)
)

(defmacro pc (&rest cs)
  `(print-clauses ',(or cs *clist*))
)


;;
(defmacro pg (&rest g)
  `(prover-gtrail ',g)
)

(defmacro ppg (g p)
  `(play-prover-gtrail ',g ,p)
)


