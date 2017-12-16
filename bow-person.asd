(asdf:defsystem #:bow-person
  :description "3D bow fighting game"
  :license "Don't be a Jerk"
  :author "Tyler Lee"
  :mailto "wtleeiv@gmail.com"
  :homepage "http://wtleeiv.com"
  :depends-on (#:clack
               #:ningle
               #:cl-who
               #:parenscript)
  :serial t
  :components ((:module "src"
                :serial t
                :components ((:module "client"
                              :serial t
                              :components ((:file "client")))
                             (:module "server"
                              :serial t
                              :components ((:file "server")
                                           (:file "routes")))
                             (:file "bow-person")))))
