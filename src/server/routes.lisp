(defpackage #:bow-person.server.routes
  (:use #:cl))
(in-package #:bow-person.server.routes)

(setf (ningle:route bow-person.server:*app* "/")
      #'bow-person.client:homepage)
;;; test forms
;; (lambda (parms)
;;   "hello")

;; (format nil "~A<br>~A<br>~A<br>" (assoc :test parms) (assoc :again parms) parms)
