;; rubbish-gen.lisp


(defun rub-gensym (id)
  (intern (string (gensym id)))
)


