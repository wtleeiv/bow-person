(defpackage #:bow-person.server.routes
  (:use #:cl)
  (:import-from #:ningle
                #:route)
  (:import-from #:bow-person.server
                #:*app*)
  (:import-from #:bow-person.client
                #:homepage)
  (:import-from #:bow-person.client.style
                #:style-css)
  (:import-from #:bow-person.client.script
                #:script-js))
(in-package #:bow-person.server.routes)

(setf (route *app* "/")
      #'homepage)

(setf (route *app* "/style.css")
      #'style-css)

(setf (route *app* "/script.js")
      #'script-js)

;; super easy to server static pages, just return pathname
(setf (route *app* "/lib/three.min.js")
      #p"../../lib/three.min.js")
