;; rubbish-gen-noran.lisp
;;; this is a version for ITO
;;; in production, user rubbish-gen.lisp and rub-gensymed var x becomes x.1234

(in-package :rubbish)

(defun rub-gensym (id)
  (intern (string id) :rubbish)
)


