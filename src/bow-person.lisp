(defpackage #:bow-person
  (:use #:cl)
  (:import-from #:bow-person.server
                #:*app*)
  (:export #:start
           #:stop))
(in-package #:bow-person)

(defun start (&key (server :hunchentoot)
                (port 5000)
                (debug t)
                silent)
  (clack:clackup *app* server port debug silent))

;; TODO broken (potential ningle/clack incompatibility)
(defun stop()
  (clack:stop *app*))
