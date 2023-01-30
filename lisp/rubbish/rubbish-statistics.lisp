;; rubbish-statistics.lisp

(in-package :rubbish)

(defun reset-stat ()
  (setq *num-of-input-literals* 0)   
  (setq *num-of-trials* 0)
  (setq *num-of-proof-steps* 0)

  (setq *num-of-contradictions* 0)
  (setq *num-of-literals* 0)
  (setq *input-clauses* ())
  (setq *input-literals* ())
  (setq *num-of-resolvents* 0)
)

;; statics by computed

;(defun print-pcodes (&optional (cids *clist*))
;   (loop for cid in cids do (format t "~a ~a~%" cid (pcode cid)))
;)

(defun uniq-pcodes (&optional (cids *clist*))
  (uniq (loop for cid in cids collect (pcode cid)))
;  (loop for cid in cids with ss = () do
;    (pushnew (pcode cid) ss :test #'equal)
;    finally (return ss)
;  )
)
   
(defun find-cid-by-pcode (pcode &optional (cids *clist*))
  (loop for cid in cids 
    when (equal pcode (pcode cid)) collect cid
  )
)

(defun classify-cid-by-pcode (&optional (cids *clist*))
  (let (pcodes )
    (setq pcodes (uniq-pcodes cids))
    (loop for pc in pcodes collect
      (list pc (find-cid-by-pcode pc))
    )
  )
)


;;;;
(defun analyze-pcode0 (&optional (cids *clist*))
  (let (xx yy zz)
    (setq xx (classify-cid-by-pcode cids))
    (setq yy (loop for pc in xx collect (list (length (cadr pc) )(car pc))))
    (setq zz (sort yy (lambda (x y) (> (car x)(car y)))))
    zz
  )
)

(defun analyze-pcode ()
  (analyze-pcode0 (car (lscova)))
)

(defun reportc (csp)
  (terpri t)
  (format t "kqc file             : ~a~%" *kqcfile*)
  (show-parameter0 t)
  
  (format t "~%# of pcodes          : ~a~%" (length csp))
  (loop for z in csp do (format t "~a ~a~%" (car z)(cadr z)))
)


;;
;(defun print-p2codes (&optional (cids *clist*))
;   (loop for cid in cids do (format t "~a ~a~%" cid (p2code cid)))
;)

(defun uniq-p2codes (&optional (cids *clist*))
  (uniq (loop for cid in cids collect (p2code cid)))
)
   
(defun find-cid-by-p2code (p2code &optional (cids *clist*))
  (loop for cid in cids 
    when (equal p2code (p2code cid)) collect cid
  )
)

(defun classify-cid-by-p2code (&optional (cids *clist*))
  (let (p2codes)
    (setq p2codes (uniq-p2codes cids))
    (loop for pc in p2codes collect
      (list pc (find-cid-by-p2code pc))
    )
  )
)

;;; 
(defun analyze-p2code0 (&optional (cids *clist*))
  (let (xx yy zz)
    (setq xx (classify-cid-by-p2code cids))
    (setq yy (loop for pc in xx collect (list (length (cadr pc) )(car pc))))
    (setq zz (sort yy (lambda (x y) (> (car x)(car y)))))
    zz
  )
)

(defun analyze-p2code ()
  (analyze-p2code0 (car (lscova)))
)


;;; convert p2code to pcode

(defun p2top (p2c)
  (sort 
    (loop for lid in (loop for p2 in p2c append p2) with ns = ()
      do 
        (pushnew lid ns :test #'equal)
      finally
        (return ns)
    )
  #'lid>
  )
)

;;  cb2 ≈ (analyze-p2code) 
(defun p2top* (cb2)
  (loop for cs in cb2 with ns = () do 
    (pushnew (p2top (cadr cs)) ns :test #'equal)
  finally (return ns)
  )
)


    
;; test run 
(defun test-graph (mc kqcfile &optional (goals '(1)))
  (in-package :rubbish)
;  (setq *enable-semantics* nil)
  (setq *max-contradictions* mc)

  (play-prover-gtrail goals kqcfile)

;  (reportc (analyze-pcode))
;  (reportc (analyze-p2code))
)
