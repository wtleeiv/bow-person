(defpackage #:bow-person
  (:use #:cl)
  (:export #:*app*
           #:start))
(in-package #:bow-person)

(defvar *app* (make-instance 'ningle:<app>))

(defun homepage (params)
  (declare (ignorable params))
  "Hello from the internetses")

(setf (ningle:route *app* "/")
      #'homepage)

(defun start ()
  (clack:clackup *app*))
