; rubbish system definition
(defsystem :gtrail
  :description "gtrail: a proof analyzer"
  :version "0.1.1"
  :author "Shinichi OMURA(song.of.sand@gmail.com)"
  :licence "MIT licence"
  :serial t
  :components 
    (
      (:file "rubbish-package")
      (:file "rubbish-essential" :depends-on ("rubbish-package"))
      (:file "rubbish-gen" :depends-on ("rubbish-package"))
      (:file "rubbish-params" :depends-on ("rubbish-package"))
      (:file "rubbish-base" :depends-on ("rubbish-package"))
      (:file "rubbish-kqcio" :depends-on ("rubbish-package"))
      (:file "rubbish-unif" :depends-on ("rubbish-package"))
      (:file "rubbish-reso" :depends-on ("rubbish-package"))
      (:file "rubbish-setup-unif" :depends-on ("rubbish-package"))
      (:file "rubbish-statistics" :depends-on ("rubbish-package"))
      (:file "rubbish-resoid" :depends-on ("rubbish-package"))
      (:file "rubbish-print" :depends-on ("rubbish-package"))
      (:file "rubbish-proof" :depends-on ("rubbish-package"))
      (:file "rubbish-prover" :depends-on ("rubbish-package"))
      (:file "rubbish-prover-gtrail" :depends-on ("rubbish-package"))
      (:file "rubbish-peval" :depends-on ("rubbish-package"))
      (:file "rubbish-semantx" :depends-on ("rubbish-package"))
      (:file "rubbish-log" :depends-on ("rubbish-package"))
    )
)
