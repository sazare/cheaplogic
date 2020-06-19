;; can i do throw

(defun catch0 (x)
  (catch 'phase0 
    (cond 
      ((eq x 0) 100)
      (t (throw 'phase0 5)))
  )
)

(catch0 0)
(catch0 3)

(defun catch1a (x y)
  (cond
    ((eq x y) (throw 'phase1 (+ x y)))
    (t (* x y)))
)

(defun catch1 (x y)
  (catch 'phase1
    (catch1a x y)
  )
)

(catch1 3 4)
(catch1 7 7)

(defun catchn (i n)
  (catch 'nth 
    (catchnfn i  n))
)

(defun catchnfn (i n)
  (cond
    ((eq n i) (throw 'nth i))
    ((zerop i) (throw 'nth 0))
    (t (catchnfn (- i 1) n))
  )
)

(defun catchnn (i n)
  (catchnnfn i n)
)

(defun catchnnfn (i n)
  (catch 'nthn
    (cond
      ((eq n i) (throw 'nthn i))
      ((zerop i) (throw 'nthn 0))
      (t (catchnnfn (- i 1) n))
    )
  )
)

;* (trace catchnn)
;(CATCHNN)
;* (trace catchnnfn)
;(CATCHNNFN)
;* (catchnn 7 4)
;  0: (CATCHNN 7 4)
;    1: (CATCHNNFN 7 4)
;      2: (CATCHNNFN 6 4)
;        3: (CATCHNNFN 5 4)
;          4: (CATCHNNFN 4 4)
;          4: CATCHNNFN returned 4
;        3: CATCHNNFN returned 4
;      2: CATCHNNFN returned 4
;    1: CATCHNNFN returned 4
;  0: CATCHNN returned 4
;4

;;; This is not my want

;;; tag should be only

