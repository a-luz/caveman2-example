(in-package :cl-user)
(defpackage caveman2-example.db
  (:use :cl :sxql :caveman2-example.model)
  (:import-from :caveman2-example.config
                :config)
  (:import-from :datafly
                :*connection*
                :retrieve-all
                :retrieve-one
                :execute)
  (:import-from :cl-dbi
                :connect-cached)
  (:export :connection-settings
           :db
           :with-connection
           :insert-user
           :retrieve-users
           :retrieve-user-by-name
           :delete-user-by-name
           :update-user-email))
(in-package :caveman2-example.db)

;; THE DATABASE CONNECTION INSTRUCTIONS ARE DESCRIBED IN src/config.lisp
;; CHECK IT OUT TO SEE HOW IT IS DONE.

(defun connection-settings (&optional (db :maindb))
  (cdr (assoc db (config :databases))))

(defun db (&optional (db :maindb))
  (apply #'connect-cached (connection-settings db)))

(defmacro with-connection (conn &body body)
  `(let ((*connection* ,conn))
     ,@body))

;; Function that connects to the database and executes
;; an insert query and inserts a new user to the db.
(defun insert-user (connection user)
  (caveman2-example.db:with-connection connection
    (datafly:execute
     (sxql:insert-into :usr
       (sxql:set= :usrName (caveman2-example.model:user-name user)
                  :usrEmail (caveman2-example.model:user-email user)
                  :usrPwd (caveman2-example.model:user-password user))))))

(defun retrieve-users (connection)
  (caveman2-example.db:with-connection connection
    (datafly:retrieve-all
     (sxql:select :*
       (sxql:from :usr)))))


;; Funtion that connects to the database and executes
;; a select query and retrieves all users with a given name.
(defun retrieve-user-by-name (connection name)
  (caveman2-example.db:with-connection connection
    (datafly:retrieve-all
     (sxql:select :*
       (sxql:from :usr)
       (sxql:where (:= :usrName name))))))

(defun delete-user-by-name (connection name)
  (caveman2-example.db:with-connection connection
    (datafly:execute
     (sxql:delete-from :usr 
       (sxql:where (:= :usrName name))))))

(defun update-user-email ())
