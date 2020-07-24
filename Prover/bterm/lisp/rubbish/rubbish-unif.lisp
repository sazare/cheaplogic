;; disag and unify

;; primitives
(defun isvar (vars sym)
  (member sym vars)
)

(defun vof (s) (car s))
(defun exof (s) (cdr s))
(defun issym (e) (atom e))
(defun sigma (v e) (cons v e))

(defun fof (e) (car e))
(defun e*of (e) (cdr e))
(defun form (f as) (cons f as))


;;; common subst
;; subst1 replace v1 with e1 on e

(defun subst1 (e v1 e1)
  (cond
    ((atom e)
      (cond
        ((equal e v1) e1)
        (t e)))
    ((consp e) (cons (car e)(subst1* (cdr e) v1 e1)))
  )    
)

(defun subst1* (e* v1 e1)
  (cond
    ((null e*) ())
    (t (cons (subst1 (car e*) v1 e1) (subst1* (cdr e*) v1 e1)))
  )
)

;;; subst on snot, ss is snot
;; substs digs on ss
(defun substs (e ss) 
  (cond
    ((null ss) e)
    (t (substs (subst1 e (caar ss)(cdar ss)) (cdr ss)))
  )
)


;;; substv replace v1 with e1 of v
;; substv1 is a restriceted function of subst1
(defun substv1 (v v1 e1)
  (cond
    ((equal v v1) e1)
    (t v)
  )
)

;;; substv apply s=(v1.e1) to v
(defun substv (v s)
  (substv1 v (car s)(cdr s))
)

;;; substvs apply ss to v. v:var, ss:subst
(defun substvs (v ss)
  (cond 
    ((null ss) v)
    ((eq v (caar ss)) (substv v (car ss)))
    (t  (substvs (substv v (car ss)) (cdr ss)))
  )
)

;;; substvs* apply ss to vs(var list)
(defun substvs* (vs ss) 
  (cond
    ((null vs) ())
    (t (cons (substvs (car vs) ss)(substvs* (cdr vs) ss)))
  )
)


;;; subsub* : s1 x s2 -> s3

;;;; subsubs1 : snot v1 e1 -> snot
; common v in s1,s2 then s2's (v.*) is ignored.

(defun subsubs1 (s v1 e1)
  (subsubs1h s v1 e1 nil)
)

;;; subsubs1h : replace v1 with e1 in s. no v1 in s, add (v1.e1) at end.
; has means v1 of s2 in s1. common v1.
(defun subsubs1h (s v1 e1 has)
  (cond
    ((null s)
      (cond (has ())
            (t (list (cons v1 e1)))))
    (t (cons (cons (caar s)(subst1 (cdar s) v1 e1))
             (subsubs1h (cdr s) v1 e1 (or has (eq (caar s) v1)))))
  )
)

;; subsubs1w is an alternative subsubs1
(defun subsubs1w (s v1 e1)
  (subsubs1w0 s v1 e1 (list (cons v1 e1)))
)

; keep as the subst will be added at the end
(defun subsubs1w0 (s v1 e1 as)
  (cond
    ((null s) as)
    (t (cons (cons (caar s)(subst1 (cdar s) v1 e1))
             (subsubs1w0 (cdr s) v1 e1 (cond ((eq (caar s) v1) ())(t as)) )))
  )
)

;;; subsubs s1,s2 snot
(defun subsubs (s1 s2)
  (cond
    ((null s2) s1)
    (t (subsubs (subsubs1 s1 (caar s2)(cdar s2)) (cdr s2)))
  )
)


;;; default fun do nothing
(defun normalf (e v1 e1)
  e
)

;;; putpnot apply a v1<-e1 to s. vs is a var list
;; when normalf, this do nothing on default
(defun putpnot (vs s v1 e1 &optional (fn #'normalf))
  (loop for v in vs for e in s collect
    (cond 
      ((eq v v1) e1)
      (t (funcall fn e v1 e1)))
  )
)

;;; replace v1 with e1 on s : pnot 
(defun substp1 (vs s v1 e1)
  (putpnot vs s v1 e1 #'subst1)
)


;;; subst pnot 
; vs : vars list
; ex is expr
; es is p-not (es corr. vs)
; substp p-not subst es on ex
(defun substp (vs ex es)
  (let ((nex ex))
    (loop for v in vs for e in es do
      (setf nex (subst1 nex v e))
    )
    nex
  )
)

;; subsubp
; subsubp1 p-not replace v1 with s2 on s1

(defun subsubp1 (vs s1 v1 s2)
  (loop for v in vs for e1 in s1 collect
    (if (eq v v1)
      (if (eq v e1)  ;; empty substitution
          s2
          (subst1 e1 v1 s2)
      )
      (subst1 e1 v1 s2)
    )
  )
)

(defun subsubp (vs s1 s2)
  (let ((rs s1))
    (loop for v2 in vs for e2 in s2 do 
      (setf rs (subsubp1 vs rs v2 e2))
    )
    rs
  )
)

;;;; conversion s-not with p-not
;;;; snot to pnot; ss is snot
(defun s2p (vs ss)
  (substvs* vs ss)
)

;;;; pnot to snot
(defun p2s (vs es)
  (loop for v in vs for e in es
    collect (cons v e))
)

;;;;; disgreee is a core of unify
;;; inverse of disagreement and unify

;; fn is called with each disagreement pair
(defun disagree (vs e1 e2 se fn)
  (disag vs e1 e2 se fn)
)

;; disag use m for keeping sigma
(defun disag (vs e1 e2 m fn)
  (cond
    ((equal e1 e2) m)
    ((atom e1) (funcall fn vs e1 e2 m))
    ((atom e2) (funcall fn vs e2 e1 m))
    ((not (eq (car e1)(car e2))) 'NO) ;; this should be in fn...?
    (t (disag* vs (cdr e1)(cdr e2) m fn))
  )
)

(defun disag* (vs es1 es2 m fn)
  (cond 
    ((null es1) m)
    (t (disag* vs (cdr es1)(cdr es2) (disag vs (car es1)(car es2) m fn) fn))
  )
)

; showit is an example fn
; showit is a stub for testing disagree
;(defun showit (vs e1 e2 m)
; (format t "~a:~a ~a~%" vs e1 e2)
; m
;)

;; collect is an sample disagree-fn
(defun collect (vs e1 e2 m)
 vs
 (append m (list (cons e1 e2)))
)

;;; insidep check v in e. no vs 
(defun insidep (v e)
  ;; (eq v e) never T because unifics presume
  (cond
    ((eq v e) NIL)
    ((not (atom v)) NIL)
    (T (insidep0 v e))
  )
)

(defun insidep0 (v e)
  ;; (eq v e) is T here.
  (cond
    ((eq v e) T)
    ((atom e) NIL)
    (T (insidep0* v e))
  )
)

(defun insidep0* (v e*)
  (cond 
    ((null e*) NIL)
    (T (or (insidep0 v (car e*))(insidep0* v (cdr e*))))
  )
)

;; unify variation
;; s for snot, p for pnot

;; unifics is for unify with s-not
(defun unifics (vs d1 d2 m)
;; assume d1!=d2
;; if v is var(d1 or d2) v never in m in context of unify.
;; because d1 or d2 is alredy substed by m.
  (cond
    ((isvar vs d1) (makesubsubs vs m (substs d1 m)(substs d2 m)))
;;; when (substs d1 m) is another var,
;;; (substs d1 m) inside (substs d2 m) ?
;;; if not, this pair be sigma.(note: d1 already in m)

;;; if (substs d1 m) is not var, then 
;;; do (unifics (substs d1 m)(substs d2 m))?
;;; this seems disag on them... or (unifys vs (substs d1 m)(substs d2 m))?
;;; WHY SO COMPLEX???

    ((isvar vs d2) (makesubsubs vs m (substs d2 m)(substs d1 m)))

;;; if (substs d2 m) is not var, what can i do for...
;;; (substs d2 m) inside (substs d1 m) ?
;;; BUT if <(substs d1 m):(substs d2 m)> needed?

    ((or (atom d1)(atom d2)) (throw 'unifications 'NO)) ;; it is consts/fun conflict
    ((eq (car d1)(car d2))(unifics* vs (cdr d1)(cdr d2) m)) ;; func rec.
    (t (throw 'unifications 'NO))
  )
)

(defun unifics* (vs e1* e2* m)
  (cond
    ((null e1*) m)
    (t (unifics* vs (cdr e1*)(cdr e2*) (unifics vs (car e1*)(car e2*) m)))
  )
)


;;; makesubsubs subsub in s-not
; v is (subst d? m), may be fterm.
(defun makesubsubs (vs s v e)
  (cond 
    ((isvar vs v) 
      (cond ((insidep v e) (throw 'unifications 'NO))
            (T (subsubs1 s v e))))
    ((isvar vs e)
      (cond ((insidep e v) (throw 'unifications 'NO))
            (T (subsubs1 s e v))))
    ((or (atom v)(atom e)) (throw 'unifications 'NO))
    (T (let ((si (unifys vs v e)))
            (subsubs s si)))
  )
)

;;; unifys is unify s-not with unifics
(defun unifys (vs e1 e2)
  (disagree vs e1 e2 () #'unifics)
)

;;; unifications
(defun unifications (vs e1 e2)
  (catch 'unifications
    (unifys vs e1 e2)
  )
)

;;; p-not
;; unifysp unify p-not ; unifys and s2p
(defun unifysp (vs e1 e2)
   (s2p vs (unifys vs e1 e2))
)

;;; unificationsp

(defun unificationsp (vs e1 e2)
;; (s2p vs (unifications vs e1 e2))
  (let ((ru (unifications vs e1 e2)))
    (cond ((eq ru 'NO) ru)
     (t (s2p vs ru))
    )
  )
)

;;;; unifyp is another naive implementaion of unifysp
;; s for subst e, p for compose mgu
;; in substs m should be snot, in subsubp m should be pnot.
;; it is not both valid.
;;;; unifysp may be identical unifyp

(defun unificp (vs d1 d2 m)
;; assume d1!=d2
  (cond
    ((isvar vs d1) (makesubsubp vs m (substp vs d1 m)(substp vs d2 m)))
    ((isvar vs d2) (makesubsubp vs m (substp vs d2 m)(substp vs d1 m)))
    ((or (atom d1)(atom d2)) (throw 'unificationp 'NO))
    ((eq (car d1)(car d2))(unificp* vs (cdr d1)(cdr d2) m))
    (t (throw 'unificationp 'NO))
  )
)

(defun unificp* (vs e1* e2* m)
  (cond
    ((null e1*) m)
    (t (unificp* vs (cdr e1*)(cdr e2*) (unificp vs (car e1*)(car e2*) m)))
  )
)

;; makesubsubp is p-not makesubsub
(defun makesubsubp (vs s v e)
;;  (subsubp1 vs s v e)
  (cond
    ((isvar vs v)
      (cond ((insidep v e) (throw 'unificationp 'NO))
            (T (subsubp1 vs s v e))))
    ((isvar vs e)
      (cond ((insidep e v) (throw 'unificationp 'NO))
            (T (subsubp1 vs s e v))))
    ((or (atom v)(atom e)) (throw 'unificationp 'NO))
    (T (let ((si (unifyp vs v e)))
            (subsubp vs s si)))
  )
)

;; unifyp is..
(defun unifyp (vs e1 e2)
  (disagree vs e1 e2 vs #'unificp)
)

;;; unificationp 
(defun unificationp (vs e1 e2)
  (catch 'unificationp
    (unifyp vs e1 e2)
  )
)



