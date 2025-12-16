;; unifier matrix of P for same signs and oppo signs

(in-package :rubbish)

(defun make-umatrix (clist)
  (let (ppns ppn)
    (setq ppns (make-ppnlist clist))
    (loop for pred in (make-psymlist (make-lidlist clist)) 
      collect
      (let ()
        (setq ppn (assoc pred ppns))
        (list pred 
           (make-umatrix-p (nth 1 ppn)(nth 1 ppn))
           (make-umatrix-p (nth 2 ppn)(nth 2 ppn))
           (make-umatrix-p (nth 1 ppn)(nth 2 ppn)))
      )
    )
  )
)

(defun make-umatrix-p (llids rlids)
  (cons
    (list llids rlids)
    (loop for llid in llids collect
      (loop for rlid in rlids collect
        (unify-atoms llid rlid)
      )
    )
  )
)

(defun strip-mgu-raw (mgu)
  (let (vs ts)
    (loop for v in (nth 0 mgu) as tm in (nth 1 mgu)
      when (not (equal v tm ) )  do
        (push v vs)
        (push tm ts)
    ) 
    (if (null vs) 
      :∅
      (list (reverse vs)(reverse ts))
    )
  )
)

(defun pum-row0 (lid ml)
  (format t "~a |" lid)
  (loop for am in  ml do
    (if (eq :NO am)
      (format t "|NO")
      (format t "|~a" (strip-mgu-raw am))
    )
  finally 
    (format t "|~%")
  )
)

(defun pum-p0 (aum)
  "ums = ((ll1 ll2) (m11 m12 ...)(m21 m22 ...)...(mk1 mk2 ...))"
  (let (rt ct)
    (setq rt (nth 0 (car aum)))
    (setq ct (nth 1 (car aum)))

    (format t "     |" )
    (loop for cn in ct do (format t "~a|" cn)) 
    (format t "~%")
    (loop for aml in (cdr aum) as rn in rt do
      (pum-row0 rn aml)
    ) 
  )
)

(defun pum0 (ums)
  (let (pred)
    (setq pred (nth 0 ums))
    (format t "~%~a PxP~%" pred)
    (pum-p0 (nth 1 ums))
    (format t "~%~a NxN~%" pred)
    (pum-p0 (nth 2 ums))
    (format t "~%~a PxN~%" pred)
    (pum-p0 (nth 3 ums))
  )
) 

(defun pums0 (umss)
 (loop for ums in umss do
   (pum0 ums)
 )
)

;;; 
(defun strip-mgu-eq (mgu)
  (let (forms)
    (loop for v in (nth 0 mgu) as tm in (nth 1 mgu)
      when (not (equal v tm ) ) do 
        (push (list v '= tm) forms)
    ) 
    (if (null forms) 
      :∅
      (reverse forms)
    )
  )
)

(defun pm2sm(ml)
  (loop for am in  ml collect
    (cond
     ((atom am) am)
     (t (strip-mgu-eq am) )
    )
  )
)

(defun string-of-nth (n tl)
  (let (nn)
    (if (< n (length tl))
      (nth n tl)
      ""
    )
  )
)
(defun p-eterm (tm)
  (unless (null tm) 
    (if (eq '= (nth 1 tm))
      (format t "~a=~a~a|" (nth 0 tm)(nth 2 tm) #\tab)
      (format t "~a~a|" tm #\tab)
    )
  )
) 

(defun pum-row-s (lid ml)
  (let (sml mh)
    (setq sml (pm2sm ml))
    (setq mh (max-length sml))

    (loop for n from 0 to mh do
      (if (eq n 0)
        (format t "~a~a" lid #\tab)
        (format t "~a" #\tab)
      )
      (loop for am in sml do
        (cond
         ((eq :no am) 
          (if (eq n 0) 
            (format t "NO~a|" #\tab)
            (format t "~a|" #\tab)))

         ((eq :∅ am)
          (if (eq n 0) 
            (format t "Φ~a|" #\tab)
            (format t "~a|" #\tab)))

        (t  (p-eterm (nth n am))) 
        )
      finally
        (format t "~%")
      )
    )
  )
)

 
(defun pum-p (aum)
  "ums = ((ll1 ll2) (m11 m12 ...)(m21 m22 ...)...(mk1 mk2 ...))"
  (let (rt ct)
    (setq rt (nth 0 (car aum)))
    (setq ct (nth 1 (car aum)))

    (format t "~a" #\tab)
    (loop for cn in ct do (format t "|~a~a|" cn #\tab)) 
    (format t "~%")
    (loop for aml in (cdr aum) as rn in rt do
      (pum-row-s rn aml)
    ) 
  )
)

(defun pum (ums)
  (let (pred)
    (setq pred (nth 0 ums))
    (format t "~%+~ax+~a~%" pred pred)
    (pum-p (nth 1 ums))
    (format t "~%-~ax-~a~%" pred pred)
    (pum-p (nth 2 ums))
    (format t "~%+~ax-~a~%" pred pred)
    (pum-p (nth 3 ums))
  )
) 

(defun pums (umss)
 (loop with pred for ums in umss do
   (setq pred (nth 0 ums))
   (format t "~%~%[~a]" pred)
   (pum  ums)
   (format t "[end of ~a]" pred)
 )
)

;; unify-atoms
(defun unify-atoms (lid1 lid2)
  (let* ((vs (union (varsof (cidof lid1)) (varsof (cidof lid2))))
         (a1 (latomicof lid1))
         (a2 (latomicof lid2))
         (sig (funification vs a1 a2)))
    (if (eq :NO sig) :NO (list vs sig))
  )
)

;;;;;;


(defun col-all (a j n)
  (loop for 0 to n collect (aref a j))
)

(defun isolated-l (umat)
  (loop for i from 0 to n thereis
    (loop for j from 0 to m always
    (eq (getf imet i j) :FAIL)
  )
)

