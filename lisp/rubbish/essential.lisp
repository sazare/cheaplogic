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

