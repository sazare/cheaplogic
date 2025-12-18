;; unifier matrix of P for same signs and oppo signs

(in-package :rubbish)

;; unify-atoms
(defun unify-atoms (lid1 lid2)
  (let* ((vs (union (varsof (cidof lid1)) (varsof (cidof lid2))))
         (a1 (latomicof lid1))
         (a2 (latomicof lid2))
         (sig (funification vs a1 a2)))
    (if (eq :NO sig) :NO (list vs sig))
  )
)

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
  (let (um)
    (setq um (make-array (list (length llids) (length rlids))))
    (loop for llid in llids as x from 0 to (length llids) do
      (loop for rlid in rlids as y from 0 to (length rlids) do
        (setf (aref um x y) (unify-atoms llid rlid) )
      )
    )
    (cons (list llids rlids) um)
  )
)

;; printing umatrix
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

(defun puma (rt uma)
  (let (am dim)
    (setq dim (array-dimensions uma))
    (loop for r from 0 to (1- (car dim)) do
      (format t "~a " (nth r rt))
      (loop for c from 0 to (1- (cadr dim)) do
        (setq am (aref uma r c))
        (if (eq :NO am)
          (format t "|NO")
          (format t "|~a" (strip-mgu-eq am))
        )
       finally (format t "~%")
      )
    )
  )
)

;(defun puma (ct uma)
;  (let (am dim)
;    (setq dim (array-dimensions uma))
;    (loop for r from 0 to (1- (car dim)) do
;      (format t "~a " (nth r ct))
;      (loop for c from 0 to (1- (cadr dim)) do
;        (setq am (aref uma r c))
;        (if (eq :NO am)
;          (format t "|NO")
;          (format t "|~a" (strip-mgu-raw am))
;        )
;       finally (format t "~%")
;      )
;    )
;  )
;)

(defun pum-p0 (aum)
  (let (rt ct)
    (setq rt (nth 0 (car aum)))
    (setq ct (nth 1 (car aum)))
    (format t "     ")
    (loop for c in ct do (format t "|~a" c) finally (format t "~%"))
    (puma rt (cdr aum))
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

(defun checker-col (am c rt)
  (loop for r from 0 to (1- rt) always (equal (aref am c r) :NO))
)

(defun checker-allcol (am ct rt)
  (loop for c from 0 to (1- ct) collect (checker-col am c rt))
)

(defun checker-row (am r ct)
  (loop for c from 0 to (1- ct) always (equal (aref am c r) :NO))
)

(defun checker-allrow (am rt ct)
  (loop for r from 0 to (1- rt) collect (checker-row am r ct))
)

(defun nopa (aum)
  (let (rt ct am rc cc)
    (setq rt (length (nth 0 (car aum))))
    (setq ct (length (nth 1 (car aum))))
    (setq am (cdr aum))
    
    (setq rc (checker-allcol am rt ct))
    (setq cc (checker-allrow am ct rt))
    (append
      (which rc (nth 0 (car aum)))
      (which cc (nth 1 (car aum)))
    )
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

;;;;;;


