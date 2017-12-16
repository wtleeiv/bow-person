(defpackage #:bow-person
  (:use #:cl)
  (:export #:start
           #:stop))
(in-package #:bow-person)

(defun start (&key (server :hunchentoot)
                (port 5000)
                (debug t)
                silent)
  (clack:clackup bow-person.server:*app* server port debug silent))
(defun stop()
  (clack:stop *app*))
