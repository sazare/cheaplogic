; Exhausted Prover
(defsystem :exhp
  :description "exhaustive prover" 
  :version "0.1.0"
  :author "Shinichi OMURA(song.of.sand@gmail.com)"
  :licence "MIT licence"
  :serial t
  :components 
    (
      (:file "rubbish-package")
;; essential functions of commonlisp
      (:file "rubbish-essential" :depends-on ("rubbish-package"))

;gensym -- not use gen-noran now.
      (:file "rubbish-gen" :depends-on ("rubbish-package"))
;; concern atom and symbol. for CID, LID
      (:file "rubbish-base" :depends-on ("rubbish-package"))

; parameters of rubbish
      (:file "rubbish-params" :depends-on ("rubbish-package"))
;; reading kqc
      (:file "rubbish-kqcio" :depends-on ("rubbish-package"))

;; unification
      (:file "rubbish-unif" :depends-on ("rubbish-package"))

;; resolution
      (:file "rubbish-reso" :depends-on ("rubbish-package"))

;; resolution with lid
      (:file "rubbish-resoid" :depends-on ("rubbish-package"))

; sunif and punif sertup
      (:file "rubbish-setup-unif" :depends-on ("rubbish-package"))

;; statistics for prover
      (:file "rubbish-statistics" :depends-on ("rubbish-package"))

;; utilities
;; essential printer
      (:file "rubbish-print" :depends-on ("rubbish-package"))
;; beauty printer
      (:file "rubbish-beauty" :depends-on ("rubbish-package"))
;; printer of proof
      (:file "rubbish-proof" :depends-on ("rubbish-package"))

;; maybe partial evaluation. 
      (:file "rubbish-peval" :depends-on ("rubbish-package"))
;; semantix means if evaluate a term to constant in lisp, it use as the value.
      (:file "rubbish-semantx" :depends-on ("rubbish-package"))

;; logging
      (:file "rubbish-log" :depends-on ("rubbish-package"))
;; logging on files
      (:file "rubbish-flog" :depends-on ("rubbish-package"))


; concern lsymbol
      (:file "rubbish-prover" :depends-on ("rubbish-package"))
      (:file "rubbish-prover-exhaustive" :depends-on ("rubbish-package"))

;pcs bps,...
      (:file "rubbish-goods" :depends-on ("rubbish-package"))
;; experimentals
; lid -> vars and unify. nplist combination checking
      (:file "rubbish-explore" :depends-on ("rubbish-package"))
; concerns adjacent matrix
      (:file "rubbish-analyze" :depends-on ("rubbish-package"))
; mujun checker
      (:file "rubbish-mujun" :depends-on ("rubbish-package"))
; I don't know
      (:file "rubbish-disolver" :depends-on ("rubbish-package"))
    )
)
