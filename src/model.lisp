(in-package :cl-user)
(defpackage language-popularity.model
  (:use :cl
        :cl-json
        :drakma
        :vecto
        :md5
        :split-sequence)
  (:import-from :language-popularity.config
                :config)
  (:export :get-language-sub-stats
           :pie-chart))

(in-package :estudo-cave)


(defun pie-chart (slices)
  slices)

(defun get-language-sub-stats (x)
  x)

(defclass Language ()
  ((Subscribers
    :accessor subs
    :initarg :subs
    :initform 0)
   (Last-Updated
    :accessor last-updated
    :initarg :last-updated
    :initform 0)
   (About
    :accessor about
    :initarg :about
    :initform "Some details abou the language."))
  (:documentation "Language stats and details"))


(defun char-vector-to-string (v)
  "Transforms a vector of characters into a string"
  (format nil "~{~a~}" (mapcar #'code-char (coerce v 'list))))

(defun remote-json-request (v)
  "Pull in remote JSON. Drakma returns it as a large vector of character
  codes so we have to parse it out to a string form for cl-json"
  (let* ((json-response-raw (http-request uri))
         (json-response-string (char-vector-to-string json-response-raw))
         (json (decode-json-from-string json-response-string)))
    json))

(defparameter *language-stats* (make-hash-table :test #'equal))
(defconstant +cache-time+ (* 60 60)) ;; 1 hour

(defmacro jkey (k &rest rest)
  `(cdr (assoc ,k ,@rest)))

(defun set-language-stats (language)
  "Build language stats into our lang class via external sources of
popularity."
  (let ((lang-class (or (gethash language *language-stats*) (make-instance 'Language))))
    (when (> (- (get-universal-time) (last-updated lang-class)) +cache-time+)
      (let ((reddit-json
             (remote-json-request
              (format nil "http://reddit.com/r/~a/about.json"
                      language))))
        (when (jkey :subscribers (jkey :data reddit-json))
          (setf (subs lang-class) (jkey :subscribers (jkey :data reddit-json))))
        (setf (last-updated lang-class) (get-universal-time))))
    (setf (gethash language *language-stats*) lang-class)
    (cons (intern (string-upcase language)) (subs lang-class))))
