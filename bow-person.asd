(asdf:defsystem #:bow-person
  :description "3D bow fighting game"
  :license "Don't be a Jerk"
  :author "Tyler Lee"
  :mailto "wtleeiv@gmail.com"
  :homepage "http://wtleeiv.com"
  :depends-on (#:clack
               #:ningle
               #:cl-who
               #:css-lite
               #:parenscript)
  :serial t
  :components ((:module "src"
                :serial t
                :components ((:module "core"
                              :serial t
                              :components ((:file "client")))
                             (:module "client"
                              :serial t
                              :components ((:file "style")
                                           (:file "script")
                                           (:file "client")))
                             (:module "server"
                              :serial t
                              :components ((:file "server")
                                           (:file "routes")))
                             (:file "bow-person")))))
