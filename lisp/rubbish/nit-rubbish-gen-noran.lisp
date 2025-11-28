
;; ito-rubbish-gen-noran.lisp
;;; 

(load "rubbish-gen-noran.lisp")

(ito:defito ito-rub-gensym ()
  "syntax types"
  (ito:intend-equal "value has no random" "C12:" (symbol-name (rub-gensym "C12:")))
)


(ito:defito ito-all-gen-noran ()
  "TESTS FOR GEN-NORAN "
  (ito-rub-gensym)
)

(ito-all-gen-noran)

