;; new subst and unification

;; what about to use not alist, plist but setq
;; not yet work(2024/02/13)


;; valueかpropertyを使ってsubstitutionを高速化できないだろうか。

; sigma = {x <- (f y)}を
; xのvalueに'(f y)を設定するような
; このとき、xから(fy)を引くのはalistやplistから引くのより早いだろうか


; hashだと高速にならないかな
;(defparameter *hash* (make-hash-table :test 'equal))
;(gethash x t) = (assoc x t)
;(setf (gethash x t) v) でx->vにする


(defun make-hsubst (s*)
  (let (h)
    (setq h (make-hash-table :test 'equal))
    (loop for s in s* do
      (setf (gethash (car s) h) (cdr s))
    )
    h
  )
)

(defun pph (h)
  (maphash #'(lambda (k v) (format t "~a : ~a~%" k v)) h)
)

;; hsubst
(defun hsubst (e hs)
  (cond 
    ((null e) nil)
    ((atom e) 
      (let (r)
        (setq r (gethash e hs))
        (cond
          ((null r) e)
          (t r)
        )
      )
    )
    (t (hsubst* e hs))
  )
)

(defun hsubst* (e* hs)
  "e* is a list"
  (loop for e in e* collect
    (hsubst e hs)
  )
)
        

;; assocを使ってもかわらない
(defun asubst (e s)
  (cond 
    ((null e) nil)
    ((atom e) 
      (let (r)
        (setq r (assoc e s))
        (cond
          ((null r) e)
          (t (cdr r))
        )
      )
    )
    (t (asubst* e s))
  )
)

(defun asubst* (e* s)
  "e* is a list"
  (loop for e in e* collect
    (asubst e s)
  )
)
        
