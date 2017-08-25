(in-package :cl-user)
(defpackage estudo-cave-test-asd
  (:use :cl :asdf))
(in-package :estudo-cave-test-asd)

(defsystem estudo-cave-test
  :author "Arthur Luz"
  :license ""
  :depends-on (:estudo-cave
               :prove)
  :components ((:module "t"
                :components
                ((:file "estudo-cave"))))
  :perform (load-op :after (op c) (asdf:clear-system c)))
