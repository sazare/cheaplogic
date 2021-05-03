; no what just is only

(load "load-rubbish.lisp")
(load "rubbish-confact.lisp")

(defparameter fwname "kqc/3doors/j3d-isis.wff")
(defparameter fkname "kqc/3doors/j3d-isis.kqc")

(readekqc fkname)
(init-kb)

;; case what is  and case is is
(defparameter fc1 (make-clause '(() (+ Is 大きい))))
(defparameter fc2 (make-clause '(() (+ Is 大きい耳))))
(defparameter fc3 (make-clause '(() (+ Is 長い鼻))))
(defparameter fc4 (make-clause '(() (+ Is 動物))))

(defparameter kb1 (reduce-kb fc1 *kb*))
(findfact kb1)

(defparameter kb2 (reduce-kb fc2  kb1))
(findfact kb2)

(defparameter kb3 (reduce-kb fc3  kb2))
(findfact kb3)

(defparameter kb4 (reduce-kb fc4  kb3))
(findfact kb4)

(print-proof0 (car kb4))

