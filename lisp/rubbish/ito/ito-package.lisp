; ito oriented design
(in-package :cl-user)

(defpackage :ito
  (:use :cl)
  (:export
     :defito 
     :intend-skip 
     :intend-t 
     :intend-f 
     :intend-eq 
     :intend-neq 
     :intend-equal 
     :intend-notequal 
     :intend-multiple-equal 
     :intend-multiple-notequal 
     :intend->
     :intend->=
     :intend-<
     :intend-<=
     :intend-=
     :ito-set
     :report-result
     :performance
    )
 )

