(defpackage #:bow-person.client
  (:use #:cl)
  (:import-from #:cl-who
                #:html-mode
                #:with-html-output)
  (:export #:homepage))
(in-package #:bow-person.client)

(setf (html-mode) :html5)

(defun homepage (params)
  (declare (ignorable params))
  (with-html-output
      (*standard-output* nil :prologue t :indent t)
    (:html :lang "en"
           (:head
            (:meta :charset "utf-8")
            ;; declare charset first
            (:title "bow-person")
            ;; three.js mobile control
            (:meta :name "viewport" :content "width=device-width, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0")
            ;; load stylesheet before page
            (:link :type "text/css"
                   :rel "stylesheet"
                   :href "/style.css"))
           (:body
            (:script :src "/lib/three.min.js")
            ;; load dependencies first within body
            ;; better to let three.js make it's own canvas
            ;; (:canvas :id "myCanvas")
            ;; load script after page
            (:script :src "/script.js")))))
