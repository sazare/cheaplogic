;; essential functions of common lisp


;; refer: https://lisphub.jp/common-lisp/cookbook/index.cgi?Universal%20Timeを文字列に変換する
;;        and reference manual

;; time-now return a string of current date and time
(defun time-now ()
  (let (sec min hr day mon year dow daylight-p zone)
    (multiple-value-setq (sec min hr day mon year dow daylight-p zone)
      (decode-universal-time (get-universal-time)))
    ;; format of 0 prefix decimal from p250 in Practical Common Lisp
    (format nil "~4,'0d~2,'0d~2,'0d.~2,'0d~2,'0d~2,'0d" year (- mon 1) day hr min sec)
  )
)

(defun time-current-secs ()
  (let (sec min hr day mon year dow daylight-p zone)
    (multiple-value-setq (sec min hr day mon year dow daylight-p zone)
      (decode-universal-time (get-universal-time)))
    (+ sec (* min 60) (* hr 3600)(* day 86400))
  )
)

;; today as string
(defun today ()
  (multiple-value-bind (second
                      minute
                      hour
                      date
                      month
                      year
                      day-of-weak
                      daylight-p
                      time-zone)
    (get-decoded-time)
  (format nil "~d-~d-~d" year month date))
)

;; concern atom 
;; 
; for atom plist setup
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

(defun fsetatom (atm bind plist)
  (let ()
    (set atm bind)
    (fsetplist atm plist)
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

(defun remove-atomlist (alist)
  (loop for atm in alist collect
    (remove-atom atm)
  )
)

; proof info in cid

;;;;
(defun nspace (&optional (n 0))
  (if (= n 0) ""
    (loop with aps = "" for i from 1 to n do
      (setq aps (format nil "~a " aps))
     finally (return aps)
    )
  )
)

;; function repeating n times
;; f^n -- not yet work
;; if id is identify, (expf fn 0) may be id. 
(defun expf (fn n)  ; expf: Fun x Number -> Fun
  (cond
    ((= n 1) fn )
    ((> n 1) (expf fn (- n 1)))
    (t (error "should be n(~a)>1" n))
  )
)
; (apply (expf fn 2) a) = (expf fn 2)(a) => (fn (fn a)) = (apply fn (apply fn a))i intended this.
; (expf fn 2) = (function (x) (apply fn (apply fn x)))



