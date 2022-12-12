

(in-package :rubbish)

(defmacro jama (llist)
  `(loop for y in ,llist collect
    (let ((nam (lsymof y)))
      (if (not (boundp nam)) (intern (string nam) :rubbish))
      (pushnew y nam)
      nam
    )
  )
)


(defun jamf (llist)
  (loop for y in llist collect
    (let ((nam (lsymof y)))
      (if (boundp nam) (intern (string nam) :rubbish) (set nam ()))
      (set nam (union (cons y nil) (eval nam)))
    )
  )
)

