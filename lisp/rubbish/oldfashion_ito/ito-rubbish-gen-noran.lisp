
;; ito-rubbish-gen-noran.lisp
;;; 

(myload "ito.lisp")
(load "rubbish-gen-noran.lisp")

(defito ito-rub-gensym ()
  "syntax types"
  (intend-equal "value has no random" "C12:" (symbol-name (rub-gensym "C12:")))
)


(defito ito-all-gen-noran ()
  "TESTS FOR GEN-NORAN "
  (ito-rub-gensym)
)

(ito-all-gen-noran)

