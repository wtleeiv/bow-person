(defpackage #:bow-person.client.style
  (:use #:cl)
  (:import-from #:lack.response
                #:response-headers)
  (:import-from #:ningle
               #:*response*)
  (:import-from #:css-lite
                #:css)
  (:export #:style-css))
(in-package #:bow-person.client.style)

(defun style-css (params)
  (declare (ignore params))
  (setf (response-headers *response*)
        (append (response-headers *response*)
                (list :content-type "text/css")))
  (css
    (("body")
     (:margin "0"))
    ;; let three.js style canvas to window-size
    ;; (("canvas")
    ;;  (:width "100%"
    ;;   :height "100%"))
    ))
