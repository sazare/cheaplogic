
;;;;; case make +P and -P, push lids the value of them

(setf spq (format nil "~a~a" :+ 'Q))
(setf snq (format nil "~a~a" :- 'Q))

(setf pq (make-symbol spq))
(setf nq (make-symbol snq))

(set pq ())
(set nq ())


(defun slsym (lsym)
 (make-symbol (format nil "~a~a" (car lsym)(cdr lsym)))
)
(set (slsym (lsymof (car (lidsof c8 1)))) ())

;(defmacro pushlid (lid lsym)
; `(set ,lsym (cons ,lid ,(eval ,lsym)))
;)
;(pushlid (car (lidsof c8 1)) (slsym (lsymof (car (lidsof c8 1)))))
;(pushlid (car (lidsof c8 2)) (slsym (lsymof (car (lidsof c8 1)))))


;; sybols equality
;* (equal pq (slsym (lsymof (car (lidsof c8 1)))) )
;NIL
;* pq
;#:+Q
;* (slsym (lsymof (car (lidsof c8 1)))) 
;#:+Q

(equal (string pq) (string (slsym (lsymof (car (lidsof c8 1))))))

; this is T. but not in symbol world...


;; ref
;(lidsof c8 2)
;(#:L8-3.436)
;* (litof (car (lidsof c8 2)))
;(- P Z X)
;* (litof (car (lidsof c8 0)))
;(- R X Y)
;* (litof (car (lidsof c8 1)))
;(+ Q Y Z)
;* (lsymof (car (lidsof c8 1)))
;(+ . Q)

(setf oppos '(P (()()) Q (()()) R(()())))
(setf qpn (getf oppos 'Q))
(push 'L10 (car qpn))
(push 'L11 (car qpn))
(car qpn)
(push 'L12 (cadr qpn))
qpn
oppos
;; these looks work...  

