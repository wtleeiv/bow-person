(defpackage #:bow-person.server
  (:use #:cl)
  (:export #:*app*))
(in-package #:bow-person.server)

(defvar *app* (make-instance 'ningle:<app>))
