(in-package :cl-user)
(defpackage caveman2-example-test-asd
  (:use :cl :asdf))
(in-package :caveman2-example-test-asd)

(defsystem caveman2-example-test
  :author "Arthur Luz"
  :license ""
  :depends-on (:caveman2-example
               :prove)
  :components ((:module "t"
                :components
                ((:file "caveman2-example"))))
  :perform (load-op :after (op c) (asdf:clear-system c)))
