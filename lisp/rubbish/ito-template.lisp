;; ito-template.lisp
;;; 
(myload "ito.lisp") ; for general ito
(load "ito-rubbish-tools.lisp") ; for rubbish, contains ito.lisp

; load file be tested
(load "???.lisp")


(defito ito-???()
  "what test is this"
  (intend-equal "test what?" expected testform)
)

;;
(defito ito-all-??? () ;;; my style 
  "test for all test"
  (ito-???)
)

(ito-all-???)

