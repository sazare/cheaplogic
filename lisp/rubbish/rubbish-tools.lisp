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

;; same terms and lits

(defun intend-ru-sameterm (note vars eterm term)
  (cond 
    ((atom eterm)
      (cond 
        ((isvar vars term) (isprefix eterm term))
        (t (intend-equal note eterm term))))
     ((equal (car eterm)(car term)) 
        (intend-ru-sameterms note vars (cdr eterm)(cdr term)))
     (t (intend-equal note (car eterm)(car term)))
  )
)
 

(defun intend-ru-sameterms (note vars ets ts)
  (loop for et1 in ets as t1 in ts do
    (intend-ru-sameterm note vars et1 t1)
  )
)

(defun intend-ru-samelit (note lid elit)
  (let ((lit (eval lid)))
    (intend-equal "same sign" (car elit) (car lit))
    (intend-ru-sameterm "same atom" (varsof (cidof lid)) (cdr elit)(cdr lit)) ;; except sign
  )
)


(defun intend-ru-clause (note cid body &key name vars)
  (progn
    (intend-equal (format nil "~a body" note) body (eval cid))
    (intend-equal "name" name (get cid :name))
    (intend-t     "vars" (isprefixs vars (get  cid :vars)))
  )
)

(defun intend-ru-literal (note lid lit &key olid plid cid)
  (progn
    (intend-ru-samelit "lit" lid lit)
    (intend-equal (format nil "~a oild" note) olid (get lid :olid))
    (intend-equal "plid" plid (get lid :plid))
    (intend-equal "cid"  cid (get lid :cid))
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

(defun remove-props (atm)
  (loop for pn on (symbol-plist atm) by #'cddr do
    (remove-prop atm (car pn))
  )
)

(defun remove-prop (atm pn)
  (remf (symbol-plist atm) pn)
)

(defun remove-atom (atm)
  (remove-props atm)
  (makunbound atm) ;; make not (boundp atm)
)

; proof info in cid


