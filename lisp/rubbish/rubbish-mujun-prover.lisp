;; mujun-prover


(in-package :rubbish)

(defun mujun-prover ()
  (let (sexp g kqc) 
    (setq sexp sb-ext:*posix-argv*)
    (setq g (nth 1 sexp))
    (setq kqc (nth 2 sexp))
    (mujun-prover-inside g kqc) 
  )
)


