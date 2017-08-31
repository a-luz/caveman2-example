(in-package :cl-user)
(defpackage estudo-cave.web
  (:use :cl
        :caveman2
        :estudo-cave.config
        :estudo-cave.view
        :estudo-cave.db
        :datafly
        :sxql)
  (:export :*web*))
(in-package :estudo-cave.web)

;; for @route annotation
(syntax:use-syntax :annot)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)

;;
;; Routing rules

(defroute "/" ()
  (render #P"index.html"))

(defroute ("/mult" :method :post) (&key |number|)
  (let* ((multiplied (* 2 (parse-integer |number|)))
         (resp  `(,multiplied)))
    (render-json resp)))

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
