(defpackage #:bow-person.server
  (:use #:cl)
  (:export #:*app*
           #:new-player))
(in-package #:bow-person.server)

(defvar *app* (make-instance 'ningle:<app>))

(defconstant +alphabet+  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")

(defun random-string (&optional (word-len 32))
  (let ((word (make-string word-len))
        (alph-len (length +alphabet+)))
    (dotimes (i word-len word)
      (setf (aref word i) (aref +alphabet+ (random alph-len))))))

(defun new-player (params)
  (declare (ignore params))
  (random-string))
