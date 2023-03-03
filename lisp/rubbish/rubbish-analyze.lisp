; rubbish-analyze.lisp for analyzing tools on proofs
(in-package :rubbish)

;;; trans of mapn
(defun trans-mat (adjm)
  (loop for i from 0 to (1- (length adjm)) collect
    (loop for j from 0 to (1- (length adjm)) collect
      (nth i (nth j adjm))
    )
  )
)


;;; make-adjmatrix nnmap to adjent matrix for R
(defun conv-to-bitmap (size aline)
  (loop with flat = (second aline)
    for i from 0  to size collect
      (if (member i flat) 1 0)
  )
)

(defun conv-to-adjacent (mapn)
  "convert mapn to adjcent matrix. node number is the size of mapn"
  (loop for line in mapn collect
    (conv-to-bitmap (1- (length mapn)) line)
  )
)

;; write R Adjcent matirx form
(defun writeadjm (fname adjm)
  (with-open-file (out fname 
      :direction :output
      :if-exists :supersede)
    (let ((elem1 T))
      (format out "mjda= c(~%")
      (loop for line in adjm do
        (loop for a in line do
          (if elem1
            (progn (format out "~a" a) (setq elem1 nil))
            (format out ",~a" a)
          )
        )
        (terpri out)
      )
      (format out ")~%")
    )
  )
)

;;; writebfile write a file a s-exp a line
(defun writebfile (fname objects)
  (with-open-file (out fname 
      :direction :output
      :if-exists :supersede)
    (loop for o in objects do
      (if o 
        (format out "~a~%"  o)
        (format out "\(\)~%")
      )
    )
  )
)

;text part
(defun write-report (sccp2n fname) 
  (with-open-file (out fname
      :direction :output
      :if-exists :supersede)
    (format out "REPORT~%~%")
    (format out "PARAMETERS")
    (show-parameter0 () out)
    (format out "~%SUMMARY")
    (summary0 out)
    (format out "~%N-P2CODE~%")
    (loop for x in sccp2n do (format out "~a ~a~%" (third x)(second x)))
;    (print-clauses *clist* out)
  )
)

; do analyze
(defun analyze-p2 (kqcfile &optional (goal '(C1)) (max-clauses 500) (max-contradictions 50))
  (let (ccp2 sccp2 sp2 sccp2n amap mapn adja)
    (setq *max-clauses* max-clauses)
    (setq *max-contradictions* max-contradictions)
 
    (readkqc kqcfile) 
    (prover-gtrail goal)

    ;; ccp2は同じp2codeをもつcidのリストつきのリスト
    (setq ccp2 (classify-cid-by-p2code))
    
    ;sccp2はccp2のfirstの長さでソートしたもの。secondはcidのリスト
    (setq sccp2 (sort-ccp2 ccp2))
    
    ;sp2は長さ順のp2codeのlist
    (setq sp2 (loop for x in sccp2 collect (first x)))
    
    ;sccp2に番号をわりふる。cidのリストがついている
    (setq sccp2n (numbering-sccp2 sccp2))
    
    ; amapはsccp2のp2codeのお隣り(arrow)map (p2code (p2c1 p2c2 ...))* 
    (setq amap (make-nnmap sccp2))
    
    ; amapのp2codeを番号に置き換えたもの
    (setq mapn (map-in-number amap sccp2n))

    ;; Rでのグラフ表示用(tkplotはよい)に隣接行列を作るなど
    ; for print graph (in Julia or R), adjmap may prefered. so translate mapn to adjmap 
    ; not a must
    ; (setq adja (nnmap-to-adjmap mapn))

    ;all (values ccp2 sccp2 sp2 sccp2n amap mapn adja)
    (values sccp2n mapn)
  )
)
