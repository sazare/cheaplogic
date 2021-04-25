; some senarios for 3doors interaction

;1) make kqc from wwf
(defparameter fwname "kqc/3doors/j3d-knowledge.wff")
(defparameter fkname "kqc/3doors/j3d-knowledge.kqc")
(load "load-rubbish.lisp")
(load "rubbish-wff.lisp")
(defparameter wff (readafile  fwname))
(defparameter cls (eqvs2cs wff))
(write-kqc fkname cls)

(quit)


;2) 
(load "load-rubbish.lisp")
(load "rubbish-confact.lisp")

(defparameter fkname "kqc/3doors/j3d-knowledge.kqc")

; read kqc
(readekqc fkname)

; set *kb*
(init-kb)

;make the answer's fact
; by hand maker in this dev stage
(setq nf1 (make-clause '(() (+ 大きい))))
(defparameter fc1 (make-clause '(() (+ 大きい))))
(defparameter fc2 (make-clause '(() (+ 大きい耳))))
(defparameter fc3 (make-clause '(() (+ 長い鼻))))
(defparameter fc4 (make-clause '(() (+ 動物))))


;; repeat steps
(defparameter kb1 (reduce-kb fc1 *kb*))
(findfact kb1)

(defparameter kb2 (reduce-kb fc2  kb1))
(findfact kb2)

(defparameter kb3 (reduce-kb fc3  kb2))
(findfact kb3)

(defparameter kb4 (reduce-kb fc4  kb3))
(findfact kb4)

* 全部の条件がきえてunitにならないと答えとみなされない??
* ほかで使う条件が残っていなければ、それをのぞいてWhatを答えだとみなすこともできるが、
　それは問を作る側の問題。

* 






