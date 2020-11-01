;; tools is for ITO work

;; primitive structure of ITO
; preparation:
;  set binding and plist for atoms
;
; ito run
;  run rubbish functions  
;  and intend check
;
; clear and reset 
;  clear preparation and
;  clear ito's effects


; for variables gensym version

(defun isprefix (prefix var)
  (let ((sp (string prefix))(sv (string var))(plen (length (string prefix))))
    (string= sp sv :start1 0 :end1 plen :start2 0 :end2 plen)
  )
)

(defun isprefixs (pxs vs)
  (loop for p in pxs as v in vs always
    (isprefix p v)
  )
)


(defun intend-ru-clause (note cid body &rest plist)
   (and 
    (intend-equal (format nil "~a body" note) body (eval cid))
    (or
        (intend-equal "name" (get cid :name) (getf plist :name))
        (isprefixs  (get cid :vars) (getf plist :vars))
    )
   )
)

(defun intend-ru-literal (note lid lit &rest plist)
   (and 
    (intend-equal "lit" lit (eval lid))
    (loop for pp on plist by #'cddr always
      (or 
       ;(intend-equal (format nil "~a oild" note) (get lid :olid) (getf plist :olid))
       (intend-equal (format nil "~a oild" note) (get lid :olid) (getf plist :olid))
       (intend-equal "plid" (get lid :plid) (getf plist :plid))
       (intend-equal "cid"  (get lid :cid) (getf plist :cid))
      )
    )
   )
)

; for atom plist etup
(defmacro setatom (atm bind &rest plist)
  `(let ()
    (setq ,atm ,bind)
    (fsetplist ',atm ',plist)
  )
)

(defun fsetplist (atm plist)
  (loop for pr on plist by #'cddr do
     (setf (get atm (car pr)) (cadr pr))
   )
)


; cid, lid combination


; proof info in cid


