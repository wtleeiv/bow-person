(defpackage #:bow-person.server.routes
  (:use #:cl)
  (:import-from #:ningle
                #:route)
  (:import-from #:bow-person.server
                #:*app*)
  (:import-from #:bow-person.client
                #:homepage))
(in-package #:bow-person.server.routes)

(setf (route *app* "/")
      #'homepage)
;;; test forms
;; (lambda (parms)
;;   "hello")

;; (format nil "~A<br>~A<br>~A<br>" (assoc :test parms) (assoc :again parms) parms)
