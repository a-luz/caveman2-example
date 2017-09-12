(in-package :cl-user)
(defpackage caveman2-example.model
  (:use :cl
        :datafly)
  (:import-from :caveman2-example.config
                :config)
  (:export :user
           :make-user
           :user-name
           :user-email
           :user-password))

(in-package :caveman2-example.model)

(defstruct user
  name
  email
  password)
