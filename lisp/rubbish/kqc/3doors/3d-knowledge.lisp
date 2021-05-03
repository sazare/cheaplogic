;; origianl 
; for japanese knowlegd
(defparameter fwname "kqc/3doors/3d-knowledge.wff")
(defparameter fkname "kqc/3doors/3d-knowledge.kqc")

(load "load-rubbish.lisp")
(load "rubbish-confact.lisp")

(readekqc fkname)
(init-kb)

(defparameter fc1 (make-clause '(() (+ Ookii))))
(defparameter fc2 (make-clause '(() (+ OokiiMimi))))
(defparameter fc3 (make-clause '(() (+ NagaiHana))))
(defparameter fc4 (make-clause '(() (+ Doubutsu))))

(defparameter kb1 (reduce-kb fc1 *kb*))
(findfact kb1)

(defparameter kb2 (reduce-kb fc2  kb1))
(findfact kb2)

(defparameter kb3 (reduce-kb fc3  kb2))
(findfact kb3)

(defparameter kb4 (reduce-kb fc4  kb3))
(findfact kb4)

(print-proof0 (car kb4))


