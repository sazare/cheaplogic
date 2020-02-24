;(defpackage :sazare.test (:use :common-lisp))
;(in-package :sazare.test)


;; test framework
;; based on the code of ch. 9 of Practical Commonlisp by Peter Seibel.
;;  modified it as a novice commonlisper

(defvar *test-name* nil)

(defmacro deftest (name param desc &body body)
  `(defun ,name ,param
     (let ((*test-name* (append *test-name* (list ',name))))
       (format t "~%test: ~a~%" ,desc)
       (force-output t)
       ,@body)))

(defmacro expect-t (desc form)
    `(let (val)
       (setf val ,form)  ;;; eval form just once
       (report-result ,desc val val ',form val)
     )
  )

(defmacro expect-f (desc form)
    `(let (val)
       (setf val ,form)  ;;; eval form just once
       (report-result ,desc (null val) NIL ',form val)
     )
  )

(defmacro expect-equal (desc expv form)
    `(let (val)
       (setf val ,form)  ;;; eval form just once
       (report-result ,desc (equal ,expv val) ,expv ',form val)
     )
  )

(defmacro expect-notequal (desc expv form)
    `(let (val)
       (setf val ,form)  ;;; eval form just once
       (report-result ,desc (not (equal ,expv val)) ,expv ',form val)
     )
  )

(defmacro expect->(desc form1 form2)
    `(let (val1 val2)
       (setf val1 ,form1)  ;;; eval form just once
       (setf val2 ,form2)  ;;; eval form just once
       (report-result ,desc (> val1 val2) T '(> ,form1 ,form2) T)
     )
  )

(defmacro expect->=(desc form1 form2)
    `(let (val1 val2)
       (setf val1 ,form1)  ;;; eval form just once
       (setf val2 ,form2)  ;;; eval form just once
       (report-result ,desc (>= val1 val2) T '(>= ,form1 ,form2) T)
     )
  )

(defmacro expect-<(desc form1 form2)
    `(let (val1 val2)
       (setf val1 ,form1)  ;;; eval form just once
       (setf val2 ,form2)  ;;; eval form just once
       (report-result ,desc (< val1 val2) T '(> ,form1 ,form2) T)
     )
  )

(defmacro expect-<=(desc form1 form2)
    `(let (val1 val2)
       (setf val1 ,form1)  ;;; eval form just once
       (setf val2 ,form2)  ;;; eval form just once
       (report-result ,desc (<= val1 val2) T '(<= ,form1 ,form2) T)
     )
  )

(defmacro expect-=(desc form1 form2)
    `(let (val1 val2)
       (setf val1 ,form1)  ;;; eval form just once
       (setf val2 ,form2)  ;;; eval form just once
       (report-result ,desc (= val1 val2) T '(= ,form1 ,form2) T)
     )
  )

(defmacro test-set (desc &body forms)
  (let  ((result (gensym)))
  	`(let ((,result t))
	   ,(format t "~%testcase: ~a ~%" desc)
           ,(force-output t)
       	   ,@(loop for f in forms collect `(unless ,f (setf ,result nil)))
	   ,result)
	)
  )

(defun report-result (desc result expv form value)
  (if  result 
    (progn (format t ".")(force-output t))
    (progn
      (format t "~% ~a: Test Failed at ~a" desc *test-name*)
      (format t "~%   Expression: ~a" form)
      (format t "~%    Expected ~a" expv)
      (format t "~%    Evaluated: ~a~%" value)
      (force-output t)
    )
  )
  result
)

