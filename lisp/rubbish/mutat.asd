; rubbish system definition
(defsystem :mutat
  :description "fact-knowledge system with contradiction management"
  :version "0.0.1"
  :author "Shinichi OMURA(song.of.sand@gmail.com)"
  :licence "MIT licence"
  :serial t
  :components 
    (
      (:file "rubbish-package")
      (:file "rubbish-mutat" :depends-on ("rubbish-package"))
    )
)
