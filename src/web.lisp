(in-package :cl-user)
(defpackage caveman2-example.web
  (:use :cl
        :caveman2
        :caveman2-example.model
        :caveman2-example.config
        :caveman2-example.view
        :caveman2-example.db
        :datafly
        :sxql)
  (:export :*web*))
(in-package :caveman2-example.web)

;; for @route annotation
(syntax:use-syntax :annot)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)

;;
;; Routing rules
;; Routes to the index page
(defroute "/" ()
  "Renders the index page template"
  (render #P"index.html"
          ;;send list of users retrieved in the DB
          (list :users (caveman2-example.db:retrieve-users (caveman2-example.db:db)))))

;; AJAX routing example
(defroute ("/mult" :method :post) (&key |number|)
  "Receives an object via post (i.e \"{number: 3}\"), multiplies
   the number by 2 and sends the response back as a JSON object"

  (let* ((multi (* 2 (parse-integer |number|)))
         (resp  (list multi)))
    (render-json resp)))

;; Route to insert an user into the database
(defroute ("/insert" :method :post)
    (&key |usrName| |usrEmail| |usrPwd|)
  ;;creates an instance of the structure user
  (let ((user-instance (caveman2-example.model:make-user :name |usrName|
                                                         :email |usrEmail|
                                                         :password |usrPwd|)))
    ;;calls insert-user from db.lisp to insert user into database db
    (caveman2-example.db:insert-user (db) user-instance)
    ;;renders a true response in JSON format to feedback the client-side
    (render-json (list t))))




;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
