(in-package :cl-user)
(defpackage caveman2-example.db
  (:use :cl :sxql)
  (:import-from :caveman2-example.config
                :config)
  (:import-from :datafly
                :*connection*
                :retrieve-all
                :retrieve-one
                :execute)
  (:import-from :cl-dbi
                :connect-cached)
  (:export :insert-user
           :retrieve-user-by-name
           :delete-user
           :update-user-email))
(in-package :caveman2-example.db)

(defun connection-settings (&optional (db :maindb))
  (cdr (assoc db (config :databases))))

(defun db (&optional (db :maindb))
  (apply #'connect-cached (connection-settings db)))

(defmacro with-connection (conn &body body)
  `(let ((*connection* ,conn))
     ,@body))


(defun insert-user (connection user)
  (caveman2-example.db:with-connection connection
    (datafly:execute
     (sxql:insert-into :usr
       (sxql:set= :usrName (user-name user)
                  :usrEmail (user-email user)
                  :usrPwd (user-password user))))))

(defun retrieve-user-by-name (connection name)
  (caveman2-example.db:with-connection connection
    (datafly:retrieve-all
     (select :*
       (sxql:from :usr)
       (sxql:where (:= :usrName name))))))

(defun delete-user ())
(defun update-user-email ())
