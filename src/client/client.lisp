(defpackage #:bow-person.client
  (:use #:cl)
  (:export #:homepage))
(in-package #:bow-person.client)

(defun homepage (params)
  (declare (ignorable params))
  "Hello from the internetses")
