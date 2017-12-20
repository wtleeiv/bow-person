(defpackage #:bow-person.server.routes
  (:use #:cl)
  (:import-from #:ningle
                #:route)
  (:import-from #:bow-person.server
                #:*app*
                #:new-player)
  (:import-from #:bow-person.client
                #:homepage)
  (:import-from #:bow-person.client.style
                #:style-css)
  (:import-from #:bow-person.client.script
                #:script-js)
  (:import-from #:bow-person.core.client
                #:client-helpers-js))
(in-package #:bow-person.server.routes)

(setf (route *app* "/")
      #'homepage)

(setf (route *app* "/new-player")
      #'new-player)

(setf (route *app* "/style.css")
      #'style-css)

(setf (route *app* "/script.js")
      #'script-js)

(setf (route *app* "/lib/client-helpers.js")
      #'client-helpers-js)

(setf (route *app* "/lib/three.min.js")
      #P"../../lib/three.min.js")

(setf (route *app* "/lib/controls.js")
      #P"../../lib/controls.js")
