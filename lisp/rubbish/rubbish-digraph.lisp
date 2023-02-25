;; for cl-digraph
(ql:quickload 'cl-digraph.dot)

(in-package :rubbish)

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

(defun write-p2graph (dg filename)
  (let ()
    (digraph.dot:draw dg :filename filename :format :png)
    filename
  )
)
