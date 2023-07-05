(require :gtrail)
(in-package :rubbish)
(make-clause '(() (+ 魔法少女です 恭介)))

(make-clause '((who) (+ 魔法少女です who)(- 契約している who)))
(make-clause '((who) (- 魔法少女です who)(+ 契約している who)))

