;; for cl-digraph
(ql:quickload 'cl-digraph.dot)

(in-package :rubbish)

;; this is a simple coverter
(defun make-p2graph (mapn)
  (let (dg)
    (setq dg (digraph:make-digraph :initial-vertices 
                 (loop for i from 0 to (1- (length mapn)) collect i)))
    (loop for arrow in mapn do
      (loop for node in (second arrow) do
        (digraph:insert-edge dg (first arrow) node)
      )
    )
    dg
  )
) 

;; this is shorter but complex interface. i may not use this
;(defun make-p2graph2 (nn adja)
;  (let (dg)
;    (setq dg (digraph:make-digraph :initial-vertices 
;                 (loop for i from 0 to (1- nn) collect i)))
;    (loop for (s e) in adja do (digraph:insert-edge dg s e))
;    dg
;  )
;)

(defun write-p2graph (dg filename)
  (digraph.dot:draw dg :filename filename :format :png)
)

(defun write-p2g (dg sccp2n filename)
  (let ()
    (write-p2graph dg (concatenate 'string filename ".png"))
    (write-report sccp2n (concatenate 'string filename ".txt"))
  )
)


