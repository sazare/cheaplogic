; rubbish system definition
(asdf:defsystem :rubbish
  :description "rubbish: a proof analyzer"
  :version "0.0.1"
  :author "Shinichi OMURA(song.of.sand@gmail.com)"
  :licence "MIT licence"
  :serial t
  :components 
    (
      (:file "rubbish-essential")
      (:file "rubbish-gen")
      (:file "rubbish-base")
      (:file "rubbish-kqcio")
      (:file "rubbish-unif")
      (:file "rubbish-reso")
      (:file "rubbish-setup-unif")
      (:file "rubbish-statistics") ; for resoid
      (:file "rubbish-resoid")
      (:file "rubbish-print")
      (:file "rubbish-proof")
      (:file "rubbish-prover")
      (:file "rubbish-prover-gtrail")
      (:file "rubbish-peval")
      (:file "rubbish-semantx")
      (:file "rubbish-log")
    )
)
