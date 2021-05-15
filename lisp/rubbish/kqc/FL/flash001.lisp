; flash light with EOLO 

(defparameter fwname "kqc/FL/flash001.wff")
(defparameter fkname "kqc/FL/flash001.kqc")


(load "load-rubbish.lisp")
(load "rubbish-confact.lisp")

(readekqc fkname)
(init-kb)

(defparameter fc1 (make-clause '(() (- FL light))))
(defparameter fc2 (make-clause '(() (+ SW on))))
(defparameter fc3 (make-clause '(() (+ BAT empty))))

(defparameter kb1 (reduce-kb fc1 *kb*))
(findfact kb1)

(defparameter kb2 (reduce-kb fc2  kb1))
(findfact kb2)

;; this should be +Bat(empty) not fact but lemma

(defparameter kb3 (reduce-kb fc3  kb2))
(findfact kb3)


