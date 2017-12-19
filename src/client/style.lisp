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
     (:margin "0"
      :font-family "arial"))
    (("canvas")
     (:width "100%"
      :height "100%"))
    (("#blocker")
     (:width "100%"
      :height "100%"
      :position "absolute"
      :background-color "rgba(0,0,0,0.5)"))
    (("#instructions")
     (:width "100%"
      :height "100%"

      :display "-webkit-box"
      :display "-moz-box"
      :display "box"

      :-webkit-box-orient "horizontal"
      :-moz-box-orient "horizontal"
      :box-orient "horizontal"

      :-webkit-box-pack "center"
      :-moz-box-pack "center"
      :box-pack "center"

      :-webkit-box-align "center"
      :-moz-box-align "center"
      :box-align "center"

      :color "#FFFFFF"
      :text-align "center"

      :cursor "pointer"))
    ))
