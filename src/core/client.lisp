(defpackage #:bow-person.core.client
  (:use #:cl #:parenscript)
  (:export #:defjs
           #:new-three
           #:client-helpers-js))
(in-package #:bow-person.core.client)

(defmacro defjs (name &body body)
  `(defun ,name (params)
     (declare (ignore params))
     (ps-to-stream *standard-output*
       ,@body)))

(defpsmacro new-three (&body body)
  `(new (chain *three* ,@body)))

(defjs client-helpers-js
  (defun http-get-async (url fn)
    ;; create new request
    (let ((req (new (*x-m-l-http-request))))
      ;; add response listener
      (setf (@ req onreadystatechange)
            (lambda ()
              ;; listen when
              (when (and (=== (@ req ready-state) 4) ; request is finished
                         (=== (@ req status) 200)) ; and request successful
                (fn (@ req response-text))))) ; callback fn on response text
      (chain req (open "GET" url t)) ; open request
      (chain req (send))))) ; send request
