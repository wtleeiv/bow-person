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
            ;; three.js mobile viewport
            (:meta :name "viewport" :content "width=device-width, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0")
            ;; load stylesheet before page
            (:link :type "text/css"
                   :rel "stylesheet"
                   :href "/style.css"))
           (:body
            ;; load dependencies first (within body)
            (:script :src "/lib/three.min.js")
            (:script :src "/lib/controls.js")
            (:script :src "/lib/client-helpers.js")
            ;; instructions
            (:div :id "blocker"
                  (:div :id "instructions"
                        (:span :style "font-size:300%" "Click to play")
                        (:br)
                        "WASD = Move, SPACE = Jump, MOUSE = Aim, CLICK = Fire"))
            ;; canvas
            (:div :id "container"
                  (:canvas :id "my-canvas"))
            ;; load game script after page elements
            (:script :src "/script.js")))))
