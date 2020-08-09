;; rubbish-gen-noran.lisp
;; no random generation of gensym
;; this may cause same symbol conflicts

(defun rub-gensym (id)
  (make-symbol id)
)


