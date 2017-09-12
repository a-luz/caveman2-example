(in-package :cl-user)
(defpackage caveman2-example-asd
  (:use :cl :asdf))
(in-package :caveman2-example-asd)

(defsystem caveman2-example
  :version "0.1"
  :author "Arthur Luz"
  :license ""
  :depends-on (:clack
               :lack
               :caveman2
               :envy
               :cl-ppcre
               :uiop
               ;; for @route annotation
               :cl-syntax-annot

               ;; HTML Template
               :djula

               ;; for DB
               :datafly
               :sxql
               ;; for other tasks
               :drakma
               :cl-json
               :md5)
  :components ((:module "src"
                :components
                ((:file "main" :depends-on ("config" "view" "db"))
                 (:file "web" :depends-on ("model" "view"))
                 (:file "view" :depends-on ("config"))
                 (:file "model" :depends-on ("config"))
                 (:file "db" :depends-on ("model" "config"))
                 (:file "config"))))
  :description ""
  :in-order-to ((test-op (load-op caveman2-example-test))))
