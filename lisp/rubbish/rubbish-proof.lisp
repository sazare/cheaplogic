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


(defun print-literal0 (lid &optional (ind 0)(out t))
  (format out "~a" (nspace ind))
  (print-literal lid out)
)

(defun print-clause0 (cid &optional (ind 0) (out t))
  (cond
    ((isvalid cid)
     (if (bodyof cid)
       (format out  "~a~a: ~a = ~a <VALID>~%" (nspace ind) cid (nameof cid)(lit*of (bodyof cid)))
       (format out  "~a~a: ~a = [] <VALID>~%" (nspace ind) cid (nameof cid))
     )
    )
    ((iscontradiction cid)
     (if (bodyof cid)
       (format out "~a~a: ~a = ~a~%" (nspace ind) cid (nameof cid)(lit*of (bodyof cid)))
       (format out "~a~a: ~a = []~%" (nspace ind) cid (nameof cid))
     )
    )
    (t
     (format out "~a~a: ~a ~a [~a]~%" (nspace ind) cid (nameof cid)(varsof cid)(lit*of (bodyof cid)))
    )
  )
)

(defun print-proof0 (cid &optional (ind 0) (out t))
  (let ()
    (print-clause0 cid ind out)
    (cond
      ((eq (ruleof cid) :resolution)
        (let* ((llid (car (rpairof cid)))(rlid (cadr (rpairof cid))))
          (cond 
            ((iscontradiction cid) 
               (format out "~a~a [] ~a : <~a:~a>~%" (nspace ind) cid (ruleof cid) llid rlid))
            ((car (proofof cid)) 
               (format out "~a~a ~a ~a : <~a:~a>~%" (nspace ind) cid (bodyof cid) (ruleof cid)  llid rlid))
            (t (format out "~ainput0 ~% ~a ~a~%" (nspace ind) cid (bodyof cid)) )
          )
          (let ()
            (print-literal0 llid (+ 2 ind) out)
            (if (null (plidof llid)) (format out "input1~%") (format out " in~%"))
            (print-proof0  (cidof llid) (+ 2 ind) out))
          (let () 
            (print-literal0 rlid (+ 2 ind) out)
            (if (null (plidof llid)) (format t "input2~%") (format out " in~%") )
            (print-proof0  (cidof rlid) (+ 2 ind) out))
        )
      )
      ((eq (ruleof cid) :REDUCED-BY-SEMANTIX)
        (let* ((pr (proofof cid))(flits (cadddr pr)))
          (cond
            ((iscontradiction cid) 
              (format out "~a~a ~a [] removed are..~a~%~a" (nspace ind) cid (ruleof cid) flits (nspace ind)))
            (t 
              (format out "~a~a ~a ~a removed are..~a~%~a" (nspace ind) cid (ruleof cid) (bodyof cid) flits (nspace ind)))
          )
          (loop for flid in flits do 
            (print-literal0 flid (+ 2 ind) out)
            (format out "~%")
            (print-proof0 (cidof flid) (+ 2 ind) out))
        )
      )
    )
  )
)

(defun print-proof (cid &optional (ind 0) (out t))
  (let ()
    (print-clause0 cid ind out)
    (cond
      ((eq (ruleof cid) :resolution)
        (let* ((llid (car (rpairof cid)))(rlid (cadr (rpairof cid))))
          (cond 
            ((iscontradiction cid) 
               (format out "~a~a [] ~a : <~a:~a>~%" (nspace ind) cid (ruleof cid) llid rlid))
            ((car (proofof cid)) 
               (format out "~a~a ~a ~a : <~a:~a>~%" (nspace ind) cid (bodyof cid) (ruleof cid)  llid rlid))
            (t (format out "~ainput ~a ~a~%" (nspace ind) cid (bodyof cid)) )
          )
          (let ()
            (print-literal0 llid (+ 2 ind) out)
            (if (null (plidof llid)) (format out "input") (format out " in"))
            (terpri out)
            (print-proof  (cidof llid) (+ 2 ind) out))
          (let () 
            (print-literal0 rlid (+ 2 ind) out)
            (if (null (plidof llid)) (format t "input") (format out " in") )
            (terpri out)
            (print-proof  (cidof rlid) (+ 2 ind) out))
        )
      )
      ((eq (ruleof cid) :REDUCED-BY-SEMANTIX)
        (let* ((pr (proofof cid))(flits (cadddr pr)))
          (cond
            ((iscontradiction cid) 
              (format out "~a~a ~a [] removed are..~a~%~a" (nspace ind) cid (ruleof cid) flits (nspace ind)))
            (t 
              (format out "~a~a ~a ~a removed are..~a~%~a" (nspace ind) cid (ruleof cid) (bodyof cid) flits (nspace ind)))
          )
          (loop for flid in flits do 
            (print-literal0 flid (+ 2 ind) out)
            (terpri out)
            (print-proof (cidof flid) (+ 2 ind) out))
        )
      )
    )
  )
)

(defun list-proof0 (cid)
  (list
    cid
    (cond
      ((eq (ruleof cid) :resolution)
        (let* ((llid (car (rpairof cid)))(rlid (cadr (rpairof cid))))
          (list 
            (ruleof cid) 
            (list llid (if (plidof llid) (list-proof0 (cidof llid)) :input))
            (list rlid (if (plidof rlid) (list-proof0 (cidof rlid)) :input))
          )
        )
      )
      ((null (ruleof cid)) :input)
      (t 
        (let* ((pr (proofof cid))(flits (cadddr pr)) )
            (loop for flid in flits collect 
              (list (ruleof cid) (list-proof0 (cidof flid)) )
            )
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

;;;; invariant of clause in Σ

(defun invariantof (cid)
  (list 
    (list-mgu cid)
    (with-output-to-string (out) (print-clause0 cid 0 out))
  )
)



        
