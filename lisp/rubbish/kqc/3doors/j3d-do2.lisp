; var in j3d-do2.wff and test for object a alone

(defparameter fwname "kqc/3doors/j3d-do2.wff")
(defparameter fkname "kqc/3doors/j3d-do2.kqc")

;; fact reduction
(load "load-rubbish.lisp")
(load "rubbish-confact.lisp")

(readekqc fkname)
(init-kb)


(defparameter fc1 (make-clause '(() (+ Is it 大きい))))
(defparameter fc2 (make-clause '(() (+ Has it 大きい耳))))
(defparameter fc3 (make-clause '(() (+ Has it 長い鼻))))
(defparameter fc4 (make-clause '(() (+ Is it 動物))))


(defparameter kb1 (reduce-kb fc1 *kb*))

(defparameter kb2 (reduce-kb fc2  kb1))

(defparameter kb3 (reduce-kb fc3  kb2))

(defparameter kb4 (reduce-kb fc4  kb3))

(unless (findfact kb1) (format t "OK1~%"))
(unless (findfact kb2) (format t "OK2~%"))
(unless (findfact kb3) (format t "OK3~%"))
(when (findfact kb4) (format t "OK4--final ~%"))

(print-proof0 (car kb4))

