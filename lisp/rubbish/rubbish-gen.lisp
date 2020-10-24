;; rubbish-gen.lisp

;; this for new var or id
;; gensym makes symbol, rub-gensym makes atom


(defun rub-gensym (id)
  (intern (string (gensym id)))
)


