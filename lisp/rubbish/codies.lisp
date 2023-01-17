[文字列をS式に変換する方法]

(read (make-string-input-stream "(abc)"))
=>
(abc)


(let ((s (make-string-input-stream "(abc)(bb)"))) (list (read s) (read s)))
=>
((abc)(bb))

----
[SBCLパラメタ参照]


sb-ext:*posix-argv*
が、文字列のlistになる
carは、sbclのパス
オプションは含まず


---
[性能測定]
　time (dotimes (i 10) (testfn)))
---
[ loop のmore]
* (defun list-join (separator list)
     (loop for (element . more) on list
           collect element
           when more
             collect separator))
 LIST-JOIN
 * (list-join ’+ (loop for i below 5 collect i))
 (0 + 1 + 2 + 3 + 4)

---
[データファイルの読み込み]
(with-open-file (out "/tmp/data"
                                  :direction :output
                                  :element-type '(signed-byte 16))
               (dolist (byte '(28483 27503 28514 27503))
                 (write-byte byte out)))
使用例
(defun dump-file (infile)
  (with-open-file (in infile :element-type '(signed-byte 8))
    (loop for byte = (read-byte in nil)
      while byte
      collect (format nil "~a" (code-char byte)))
  )
)

---

[クラス]
 (defclass acc () 
   ((b 
        :initarg :b
        :accessor b 
        :initform :hex)
    (c 
        :initarg :c
        :accessor c
        :initform 0)
   )
)

(defparameter h (make-instance  'acc :b :hex :c 12))

ccccc
(with-open-file (out "/tmp/data"
                                  :direction :output
                                  :if-exists :supersede
                                  :element-type '(signed-byte 16))
               (write-sequence '(100 200 300 400 500 600 700)  out
                                 :start 2 :end 6))

(with-open-file (in "/tmp/data"
                                 :element-type '(signed-byte 16))
               (let ((result (make-array 8 :initial-element 0)))
                 (read-sequence result in :start 3 :end 7)
                 result))
---
