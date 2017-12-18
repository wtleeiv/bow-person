(defpackage #:bow-person.client.style
  (:use #:cl)
  (:import-from #:css-lite
                #:css)
  (:export #:style-css))
(in-package #:bow-person.client.style)

(defun style-css (params)
  (declare (ignore params))
  (css
   (("body")
    (:margin "0"))
   (("canvas")
    (:width "100%"
     :height "100%"))))
