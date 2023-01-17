(require :gtrail)

(in-package :rubbish)

(defparameter *enable-semantics* nil)

(defparameter *max-contradictions* (parse-integer (nth 1 SB-EXT:*POSIX-ARGV*)))
(readkqc (nth 2 SB-EXT:*POSIX-ARGV*))
(prover-gtrail (read (make-string-input-stream (nth 3 SB-EXT:*POSIX-ARGV*))))

(print-analyze (analyze-pcode))
