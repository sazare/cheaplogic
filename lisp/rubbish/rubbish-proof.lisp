; rubbish-proof.lisp

(in-package :rubbish)

;; proof manager

;; find all contradictions
(defun lscova ()
  (loop with con = () with val = () 
    for cid in *clist* 
    when (and (iscontradiction cid)(not (isvalid cid))) do (push cid con)
    when (isvalid cid) do (push cid val)
    finally (return (list con val))
  )
)

;; rule = :reso, :merge, :rename
;; proof is (rule vars sigma parents)
;;  parents = (left::Lid . right::Lid)

(defun entry-proof (cid rule vars sigma conflicts)
  (setf (get cid :proof)  (list rule vars sigma conflicts))
)

(defun proofof (cid)
  (get cid :proof)
)

(defun ruleof (cid)
  (car (proofof cid))
)

(defun sigof (cid)
  (list (cadr (proofof cid)) (caddr (proofof cid)))
)

(defun rpairof (cid)
  (cadddr (proofof cid))
)

(defun truesof (cid)
  (cadddr (proofof cid))
)

;(defun print-proof (cid &optional (ind 0))
;  (let ()
;    (cond 
;      ((eq (ruleof cid) :resolution)
;        (let* ((llid (car (rpairof cid)))(rlid (cadr (rpairof cid)))(sig (sigof cid)))
;          (cond 
;            ((iscontradiction cid) 
;               (format t "~a~a [] ~a ~a <- ~a : <~a:~a> ~%" 
;                 (nspace ind) cid (ruleof cid) (car sig) (cadr sig) llid rlid))
;            ((car (proofof cid)) 
;               (format t "~a~a ~a ~a ~a <- ~a : <~a:~a> ~%" 
;                 (nspace ind) cid (bodyof cid) (ruleof cid) (car sig) (cadr sig) llid rlid))
;            (t (format t "~ainput ~a ~a~%" (nspace ind) cid (bodyof cid)))
;          )
;          (when (cidof llid)
;            (print-literal0 llid (1+ ind))
;            (format t "in~%")
;            (print-proof (cidof llid))(+ 2 ind))
;          (when (cidof rlid) 
;            (print-literal0 rlid (1+ ind))
;            (format t "in~%")
;            (print-proof (cidof rlid)(+ 2 ind)))
;          ))
;      ((eq (ruleof cid) :REDUCED-BY-SEMANTIX)
;        (let* ((pr (proofof cid))(flits (cadddr pr)))
;          (cond
;            ((iscontradiction cid) 
;               (format t "~a~a ~a [] are removed~%" (nspace ind) cid (ruleof cid)))
;            (t 
;               (format t "~a~a ~a ~a are removed~%" (nspace ind) cid (ruleof cid) (bodyof cid)))
;          )
;          (loop for flid in flits do 
;            (print-literal0 flid (1+ ind))
;;            (terpri *standard-output*)
;            (print-proof (cidof flid)(+ 2 ind)))
;        ))
;    )
;  )
;)

(defun print-literal0 (lid &optional (ind 0))
  (format t "~a" (nspace ind))
  (print-literal lid)
)

(defun print-clause0 (cid &optional (ind 0))
  (cond
    ((isvalid cid)
     (if (bodyof cid)
       (format t "~a~a: ~a = ~a <VALID>~%" (nspace ind) cid (nameof cid)(lit*of (bodyof cid)))
       (format t "~a~a: ~a = [] <VALID>~%" (nspace ind) cid (nameof cid))
     )
    )
    ((iscontradiction cid)
     (if (bodyof cid)
       (format t "~a~a: ~a = ~a~%" (nspace ind) cid (nameof cid)(lit*of (bodyof cid)))
       (format t "~a~a: ~a = []~%" (nspace ind) cid (nameof cid))
     )
    )
    (t
     (format t "~a~a: ~a ~a [~a]~%" (nspace ind) cid (nameof cid)(varsof cid)(lit*of (bodyof cid)))
    )
  )
)

(defun print-proof0 (cid &optional (ind 0))
  (let ()
    (print-clause0 cid ind)
    (cond
      ((eq (ruleof cid) :resolution)
        (let* ((llid (car (rpairof cid)))(rlid (cadr (rpairof cid))))
          (cond 
            ((iscontradiction cid) 
               (format t "~a~a [] ~a : <~a:~a>~%" (nspace ind) cid (ruleof cid) llid rlid))
            ((car (proofof cid)) 
               (format t "~a~a ~a ~a : <~a:~a>~%" (nspace ind) cid (bodyof cid) (ruleof cid)  llid rlid))
            (t (format t "~ainput ~a ~a~%" (nspace ind) cid (bodyof cid)) )
          )
          (let ()
            (print-literal0 llid (+ 2 ind))
            (if (null (plidof llid)) (format t "input") (format t " in"))
            (terpri *standard-output*)             
            (print-proof0  (cidof llid)(+ 2 ind)))
          (let () 
            (print-literal0 rlid (+ 2 ind))
            (if (null (plidof llid)) (format t "input") (format t " in") )
            (terpri *standard-output*)             
            (print-proof0  (cidof rlid)(+ 2 ind)))
        )
      )
      ((eq (ruleof cid) :REDUCED-BY-SEMANTIX)
        (let* ((pr (proofof cid))(flits (cadddr pr)))
          (cond
            ((iscontradiction cid) 
              (format t "~a~a ~a [] removed are..~a~%~a" (nspace ind) cid (ruleof cid) flits (nspace ind)))
            (t 
              (format t "~a~a ~a ~a removed are..~a~%~a" (nspace ind) cid (ruleof cid) (bodyof cid) flits (nspace ind)))
          )
          (loop for flid in flits do 
            (print-literal0 flid (+ 2 ind))
            (terpri *standard-output*)             
            (print-proof0 (cidof flid)(+ 2 ind)))
        )
      )
    )
  )
)


;(defun fullproof (cid)
;  (if (proofof cid)  ;; should check :resolution too
;    (cond 
;      ((eq (ruleof cid) :resolution)
;        (let (rpa) 
;          (setq rpa (rpairof cid))
;          (cond 
;            ((null rpa) (bodyof cid ))
;            (t (list 
;      ;             (ruleof cid)
;                   (when (car rpa) (list (car rpa) (fullproof (cidof (car rpa)))))
;                   (when (cadr rpa) (list (cadr rpa) (fullproof (cidof (cadr rpa)))))
;                 ))
;            )
;          )
;           (bodyof cid )
;          )
;      ((eq (ruleof cid) :REDUCED-BY-SEMANTIX)
;        (let* ((pr (proofof cid))(flits (cadddr pr)))
;          (loop for flid in flits collect 
;            (fullproof (cidof flid))
;          )
;        )
;      ))
;  )
;)
;
